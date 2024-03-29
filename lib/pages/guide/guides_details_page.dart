// ignore_for_file: no_logic_in_create_state

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart'
    hide GuideApiService;
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import '../../contracts/guide/guide_section.dart';
import '../../contracts/guide/guide_section_item.dart';

import '../../components/guide/stick_row_presenters.dart';
import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../constants/analytics_event.dart';
import '../../contracts/generated/guide_meta_view_model.dart';
import '../../contracts/guide/guide.dart';
import '../../contracts/guide/guide_type.dart';
import '../../helpers/generic_helper.dart';
import '../../integration/dependency_injection.dart';
import '../../services/api/guide_api_service.dart';

class GuidesDetailsPage extends StatefulWidget {
  final NmsGuide details;
  const GuidesDetailsPage(this.details, {Key? key}) : super(key: key);

  @override
  _GuidesDetailsWidget createState() => _GuidesDetailsWidget(details);
}

class _GuidesDetailsWidget extends State<GuidesDetailsPage> {
  final NmsGuide details;
  GuideMetaViewModel? meta;
  late GuideApiService appApi;
  late bool isMetaLoading;

  _GuidesDetailsWidget(this.details) {
    getAnalytics().trackEvent(AnalyticsEvent.guideDetailsPage);
  }

  @override
  void initState() {
    super.initState();
    appApi = getGuideApiService();
    isMetaLoading = false;
  }

  void handleGetGuideMetaData() {
    if (meta != null && meta?.guid != null) return;

    appApi.getGuideMetaData(details.guid).then((metaDataResult) {
      if (metaDataResult.hasFailed) {
        return;
      }
      setState(() {
        meta = metaDataResult.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    handleGetGuideMetaData();
    return simpleGenericPageScaffold(
      context,
      title: details.shortTitle,
      body: getBody(context, details),
    );
  }

  Widget getBody(BuildContext context, NmsGuide details) {
    List<Widget> widgets = List.empty(growable: true);

    String dateString = simpleDate(details.date.toLocal());

    List<Widget> firstSectionWidgets = List.empty(growable: true);
    firstSectionWidgets.add(GenericItemDescription(details.author));
    if (details.translatedBy != null && details.translatedBy!.isNotEmpty) {
      firstSectionWidgets.add(GenericItemDescription(details.translatedBy!));
    }
    firstSectionWidgets.add(GenericItemDescription(dateString));
    widgets
        .add(nmsSectionListItem(context, details.title, firstSectionWidgets));

    for (NmsGuideSection section in details.sections) {
      List<Widget> sectionItemWidgets = List.empty(growable: true);
      for (NmsGuideSectionItem sectionItem in section.items) {
        switch (sectionItem.type) {
          case NmsGuideType.Text:
            sectionItemWidgets.add(nmsTextListItem(sectionItem));
            break;
          case NmsGuideType.Link:
            sectionItemWidgets.add(nmsLinkListItem(sectionItem));
            break;
          case NmsGuideType.Image:
            sectionItemWidgets
                .add(nmsImageListItem(context, sectionItem, details.folder));
            break;
          case NmsGuideType.Markdown:
            sectionItemWidgets.add(nmsMarkdownListItem(sectionItem));
            break;
          case NmsGuideType.Table:
            sectionItemWidgets.add(nmsTableListItem(context, sectionItem));
            break;
          default:
            break;
        }
      }
      widgets.add(
        nmsSectionListItem(context, section.heading, sectionItemWidgets),
      );
    }

    Widget metaWidget = Padding(
      child: getLoading().loadingIndicator(),
      padding: const EdgeInsets.only(top: 12),
    );
    if (meta != null && meta?.guid != null && !isMetaLoading) {
      Future<void> Function() likeFunc;
      likeFunc = () async {
        if (isMetaLoading) return;
        setState(() {
          isMetaLoading = true;
        });
        Result apiResult = await appApi.likeGuide(meta!.guid);
        if (apiResult.hasFailed) {
          getDialog().showSimpleDialog(
            context,
            getTranslations().fromKey(LocaleKey.error),
            Text(getTranslations().fromKey(LocaleKey.likeNotSubmitted)),
            buttonBuilder: (BuildContext ctx) => [
              getDialog().simpleDialogCloseButton(ctx),
            ],
          );
          setState(() {
            isMetaLoading = false;
          });
          return;
        }
        setState(() {
          isMetaLoading = false;
          meta!.likes += 1;
        });
      };
      metaWidget = Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            genericIconWithText(
              Icons.thumb_up,
              meta!.likes.toString(),
              onTap: likeFunc,
            ),
            genericIconWithText(
              Icons.remove_red_eye,
              meta!.views.toString(),
            ),
          ],
        ),
      );
    }

    List<Widget> metaList = [
      metaWidget,
      const EmptySpace8x(),
    ];

    widgets.add(SliverStickyHeader(
      header: const SizedBox(height: 0, width: 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_c, i) => metaList[i],
          childCount: metaList.length,
        ),
      ),
    ));
    // widgets.add(const EmptySpace8x());

    return CustomScrollView(slivers: widgets);
  }
}
