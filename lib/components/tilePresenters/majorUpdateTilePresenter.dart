import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/data/majorUpdateItem.dart';

Widget majorUpdateTilePresenter(
    BuildContext context, MajorUpdateItem updateNewItems) {
  List<Row> firstRow = [
    Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
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

  Image backgroundImgSource = Image.asset(
    '${getPath().imageAssetPathPrefix}/${updateNewItems.icon}',
    fit: BoxFit.fitWidth,
  );

  return InkWell(
    child: Padding(
      child: Stack(
        children: [
          backgroundImgSource,
          Positioned(
            left: 0,
            right: 0,
            bottom: -1,
            child: Container(
              color: const Color.fromRGBO(0, 0, 0, 0.65),
              child: genericItemName(updateNewItems.title),
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.only(bottom: 24),
    ),
    // onTap: ontap,
  );
}
