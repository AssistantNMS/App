import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/data/majorUpdateItem.dart';
import '../../pages/newItemsInUpdate/majorUpdatesDetailPage.dart';

Widget majorUpdateTilePresenter(
  BuildContext context,
  MajorUpdateItem updateNewItems, {
  void Function() onTap,
  bool isPatronLocked = false,
}) {
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

  Widget backgroundImgSource = ClipRRect(
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(12),
      topRight: Radius.circular(12),
    ),
    child: Image.asset(
      '${getPath().imageAssetPathPrefix}/${updateNewItems.icon}',
      fit: BoxFit.fitWidth,
    ),
  );

  Widget content = Column(
    mainAxisSize: MainAxisSize.max,
    children: [
      backgroundImgSource,
      ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        child: Container(
          color: const Color.fromRGBO(0, 0, 0, 0.45),
          child: Column(
            children: [
              genericItemName(updateNewItems.title),
            ],
          ),
          width: double.infinity,
        ),
      ),
    ],
  );

  Widget contentToDisplay = isPatronLocked
      ? Stack(
          children: [
            content,
            Positioned(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                child: Container(
                  color: const Color.fromRGBO(241, 101, 81, 0.85),
                  child: const Padding(
                    child: Icon(
                      Icons.lock_clock,
                      color: Colors.white,
                      size: 64,
                    ),
                    padding: EdgeInsets.all(12),
                  ),
                ),
              ),
              top: 0,
              right: 0,
            )
          ],
        )
      : content;

  return InkWell(
    child: Padding(
      child: contentToDisplay,
      padding: const EdgeInsets.all(12),
    ),
    onTap: onTap ??
        () => getNavigation().navigateAwayFromHomeAsync(
              context,
              navigateTo: (_) =>
                  MajorUpdatesDetailPage(updateNewItems: updateNewItems),
            ),
  );
}
