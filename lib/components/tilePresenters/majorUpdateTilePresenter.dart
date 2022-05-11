import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/data/majorUpdateItem.dart';

import '../../pages/newItemsInUpdate/newItemDetailsPage.dart';

Widget majorUpdateTilePresenter(
    BuildContext context, MajorUpdateItem updateNewItems) {
  List<Row> firstRow = [
    Row(
      children: [
        const Icon(Icons.date_range),
        Text(simpleDate(updateNewItems.releaseDate)),
      ],
    )
  ];
  if (updateNewItems.itemIds.isNotEmpty) {
    String trans = getTranslations().fromKey(LocaleKey.newItem);
    firstRow.add(Row(
      children: [
        const Icon(Icons.card_giftcard_rounded),
        Text('${updateNewItems.itemIds.length} $trans'),
      ],
    ));
  }

  return GestureDetector(
    child: Card(
      child: Column(
        children: <Widget>[
          localImage(
              '${getPath().imageAssetPathPrefix}/${updateNewItems.icon}'),
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 4, left: 4),
            child: genericItemGroup(updateNewItems.title),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: firstRow,
            ),
          ),
        ],
      ),
      margin: const EdgeInsets.all(4),
    ),
    // onTap: () async => await getNavigation().navigateAsync(
    //   context,
    //   navigateTo: (context) => GuidesDetailsPage(guideDetails),
    // ),
  );
}
