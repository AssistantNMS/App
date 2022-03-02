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
  _GuidesDetailsWidget createState() => _GuidesDetailsWidget(this.details);
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
    this.appApi = getGuideApiService();
    this.isMetaLoading = false;
  }

  void handleGetGuideMetaData() {
    if (this.meta != null && this.meta.guid != null) return;
    if (this.details == null || this.details.guid == null) return;

    appApi.getGuideMetaData(this.details.guid).then((metaDataResult) {
      if (metaDataResult.hasFailed) {
        print(metaDataResult.errorMessage);
        return;
      }
      setState(() {
        this.meta = metaDataResult.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    this.handleGetGuideMetaData();
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
    if (details.translatedBy != null && details.translatedBy.length > 0) {
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
      padding: EdgeInsets.only(top: 12),
    );
    if (this.meta != null &&
        this.meta.guid != null &&
        this.meta.guid.length > 0 &&
        !this.isMetaLoading) {
      Future<void> Function() likeFunc = () async {
        if (this.isMetaLoading) return;
        setState(() {
          this.isMetaLoading = true;
        });
        Result apiResult = await this.appApi.likeGuide(this.meta.guid);
        if (apiResult.hasFailed) {
          simpleDialog(
            context,
            getTranslations().fromKey(LocaleKey.error),
            getTranslations().fromKey(LocaleKey.likeNotSubmitted),
            buttons: [simpleDialogCloseButton(context)],
          );
          setState(() {
            this.isMetaLoading = false;
          });
          return;
        }
        setState(() {
          this.isMetaLoading = false;
          this.meta.likes += 1;
        });
      };
      metaWidget = Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            genericIconWithText(
              Icons.thumb_up,
              this.meta.likes.toString(),
              onTap: likeFunc,
            ),
            genericIconWithText(
              Icons.remove_red_eye,
              this.meta.views.toString(),
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
      header: Container(height: 0, width: 0),
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
