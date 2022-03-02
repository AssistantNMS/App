import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/guide/guide.dart';
import '../../helpers/genericHelper.dart';
import '../../pages/guide/guidesDetailsPage.dart';

final int numberOfDaysAGuideIsConsideredNew = 31;

bool isGuideNew(Guide guideDetails) => guideDetails.date
    .add(Duration(days: numberOfDaysAGuideIsConsideredNew))
    .isAfter(DateTime.now());

Widget guideTilePresenter(BuildContext context, Guide guideDetails) {
  List<Row> firstRow = [
    Row(
      children: [
        Icon(Icons.person),
        Text(guideDetails.author ?? '???'),
      ],
    )
  ];
  if (guideDetails.minutes > 0) {
    firstRow.add(Row(
      children: [
        Icon(Icons.timer),
        Text(getTranslations()
            .fromKey(LocaleKey.minutes)
            .replaceAll('{0}', guideDetails.minutes.toString())),
      ],
    ));
  }
  if (guideDetails.translatedBy != null &&
      guideDetails.translatedBy.length > 0) {
    firstRow.add(Row(
      children: [
        Icon(Icons.translate),
        Text(guideDetails.translatedBy),
      ],
    ));
  }
  Column child = Column(
    children: <Widget>[
      Image(
          image: AssetImage(
        guideDetails.image == null
            ? '${getPath().imageAssetPathPrefix}/defaultGuide.png'
            : 'assets/guide/${guideDetails.folder}/${guideDetails.image}',
      )),
      Padding(
        padding: EdgeInsets.only(top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: firstRow,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 4, right: 4, left: 4),
        child: Text(
          guideDetails.title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
      Wrap(
        alignment: WrapAlignment.center,
        children: guideDetails.tags
            .map((g) => genericChip(context, g, color: Colors.transparent))
            .toList(),
      ),
    ],
  );
  return GestureDetector(
    child: Card(
      child: isGuideNew(guideDetails)
          ? wrapInNewBanner(context, LocaleKey.newItem, child)
          : child,
      margin: const EdgeInsets.all(4),
    ),
    onTap: () async => await getNavigation().navigateAsync(
      context,
      navigateTo: (context) => GuidesDetailsPage(guideDetails),
    ),
  );
}

Widget compactGuideTilePresenter(BuildContext context, Guide guideDetails) {
  String subTitle = (guideDetails.author ?? '???');
  if (guideDetails.translatedBy != null &&
      guideDetails.translatedBy.length > 0) {
    subTitle += ' - ' + guideDetails.translatedBy;
  }
  if (guideDetails.minutes > 0) {
    subTitle += ' - ' +
        getTranslations()
            .fromKey(LocaleKey.minutes)
            .replaceAll('{0}', guideDetails.minutes.toString());
  }
  if (guideDetails.tags.length > 0) {
    subTitle += ' - ' + guideDetails.tags[0];
    for (int tagIndex = 1; tagIndex < guideDetails.tags.length; tagIndex++) {
      subTitle += ', ' + guideDetails.tags[tagIndex];
    }
  }

  ListTile child = genericListTileWithSubtitle(
    context,
    leadingImage: null,
    name: guideDetails.title,
    subtitle: Text(subTitle, maxLines: 1),
    onTap: () async => await getNavigation().navigateAsync(context,
        navigateTo: (context) => GuidesDetailsPage(guideDetails)),
  );
  return Card(
    child: isGuideNew(guideDetails)
        ? wrapInNewBanner(context, LocaleKey.newItem, child)
        : child,
    margin: const EdgeInsets.all(0.0),
  );
}
