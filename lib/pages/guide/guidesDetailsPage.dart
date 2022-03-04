// ignore_for_file: no_logic_in_create_state

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import '../../contracts/guide/guideSection.dart';
import '../../contracts/guide/guideSectionItem.dart';

import '../../components/dialogs/baseDialog.dart';
import '../../components/guide/stickRowPresenters.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/generated/guideMetaViewModel.dart';
import '../../contracts/guide/guide.dart';
import '../../contracts/guide/guideType.dart';
import '../../helpers/genericHelper.dart';
import '../../integration/dependencyInjection.dart';
import '../../services/api/guideApiService.dart';

class GuidesDetailsPage extends StatefulWidget {
  final Guide details;
  const GuidesDetailsPage(this.details, {Key key}) : super(key: key);

  @override
  _GuidesDetailsWidget createState() => _GuidesDetailsWidget(details);
}

class _GuidesDetailsWidget extends State<GuidesDetailsPage> {
  final Guide details;
  GuideMetaViewModel meta;
  GuideApiService appApi;
  bool isMetaLoading;

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
    if (meta != null && meta.guid != null) return;
    if (details == null || details.guid == null) return;

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

  Widget getBody(BuildContext context, Guide details) {
    List<Widget> widgets = List.empty(growable: true);

    String dateString = simpleDate(details.date.toLocal());

    List<Widget> firstSectionWidgets = List.empty(growable: true);
    firstSectionWidgets.add(genericItemDescription(details.author));
    if (details.translatedBy != null && details.translatedBy.isNotEmpty) {
      firstSectionWidgets.add(genericItemDescription(details.translatedBy));
    }
    firstSectionWidgets.add(genericItemDescription(dateString));
    widgets.add(sectionListItem(context, details.title, firstSectionWidgets));

    for (GuideSection section in details.sections) {
      List<Widget> sectionItemWidgets = List.empty(growable: true);
      for (GuideSectionItem sectionItem in section.items) {
        switch (sectionItem.type) {
          case GuideType.Text:
            sectionItemWidgets.add(textListItem(sectionItem));
            break;
          case GuideType.Link:
            sectionItemWidgets.add(linkListItem(sectionItem));
            break;
          case GuideType.Image:
            sectionItemWidgets
                .add(imageListItem(context, sectionItem, details.folder));
            break;
          case GuideType.Markdown:
            sectionItemWidgets.add(markdownListItem(sectionItem));
            break;
          case GuideType.Table:
            sectionItemWidgets.add(tableListItem(context, sectionItem));
            break;
          default:
            break;
        }
      }
      widgets.add(
        sectionListItem(context, section.heading, sectionItemWidgets),
      );
    }

    Widget metaWidget = Padding(
      child: getLoading().loadingIndicator(),
      padding: const EdgeInsets.only(top: 12),
    );
    if (meta != null &&
        meta.guid != null &&
        meta.guid.isNotEmpty &&
        !isMetaLoading) {
      Future<void> Function() likeFunc;
      likeFunc = () async {
        if (isMetaLoading) return;
        setState(() {
          isMetaLoading = true;
        });
        Result apiResult = await appApi.likeGuide(meta.guid);
        if (apiResult.hasFailed) {
          simpleDialog(
            context,
            getTranslations().fromKey(LocaleKey.error),
            getTranslations().fromKey(LocaleKey.likeNotSubmitted),
            buttons: [simpleDialogCloseButton(context)],
          );
          setState(() {
            isMetaLoading = false;
          });
          return;
        }
        setState(() {
          isMetaLoading = false;
          meta.likes += 1;
        });
      };
      metaWidget = Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            genericIconWithText(
              Icons.thumb_up,
              meta.likes.toString(),
              onTap: likeFunc,
            ),
            genericIconWithText(
              Icons.remove_red_eye,
              meta.views.toString(),
            ),
          ],
        ),
      );
    }

    List<Widget> metaList = [
      metaWidget,
      emptySpace8x(),
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
    // widgets.add(emptySpace8x());

    return CustomScrollView(slivers: widgets);
  }
}
