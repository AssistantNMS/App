import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/guide/guide.dart';
import '../../helpers/genericHelper.dart';
import '../../pages/guide/guidesDetailsPage.dart';

const int numberOfDaysAGuideIsConsideredNew = 31;

bool isGuideNew(NmsGuide guideDetails) => guideDetails.date
    .add(const Duration(days: numberOfDaysAGuideIsConsideredNew))
    .isAfter(DateTime.now());

Widget guideTilePresenter(BuildContext context, NmsGuide guideDetails) {
  List<Row> firstRow = [
    Row(
      children: [
        const Icon(Icons.person),
        Text(guideDetails.author ?? '???'),
      ],
    )
  ];
  if ((guideDetails.minutes ?? 0) > 0) {
    firstRow.add(Row(
      children: [
        const Icon(Icons.timer),
        Text(getTranslations()
            .fromKey(LocaleKey.minutes)
            .replaceAll('{0}', guideDetails.minutes.toString())),
      ],
    ));
  }
  if (guideDetails.translatedBy != null &&
      guideDetails.translatedBy.isNotEmpty) {
    firstRow.add(Row(
      children: [
        const Icon(Icons.translate),
        Text(guideDetails.translatedBy),
      ],
    ));
  }
  Column child = Column(
    children: <Widget>[
      Image(
          image: AssetImage(
        guideDetails.image.isEmpty
            ? '${getPath().imageAssetPathPrefix}/defaultGuide.png'
            : 'assets/guide/${guideDetails.folder}/${guideDetails.image}',
      )),
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: firstRow,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 4, right: 4, left: 4),
        child: Text(
          guideDetails.title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
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

Widget compactGuideTilePresenter(BuildContext context, NmsGuide guideDetails) {
  String subTitle = (guideDetails.author ?? '???');
  if (guideDetails.translatedBy != null &&
      guideDetails.translatedBy.isNotEmpty) {
    subTitle += ' - ' + guideDetails.translatedBy;
  }
  if ((guideDetails.minutes ?? 0) > 0) {
    subTitle += ' - ' +
        getTranslations()
            .fromKey(LocaleKey.minutes)
            .replaceAll('{0}', guideDetails.minutes.toString());
  }
  if (guideDetails.tags.isNotEmpty) {
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
