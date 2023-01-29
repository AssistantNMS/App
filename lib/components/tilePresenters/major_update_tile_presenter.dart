import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/NmsUIConstants.dart';
import '../../contracts/data/majorUpdateItem.dart';
import '../../pages/newItemsInUpdate/majorUpdatesDetailPage.dart';

Widget majorUpdateTilePresenter(
  BuildContext context,
  MajorUpdateItem updateNewItems, {
  void Function()? onTap,
  bool isPatronLocked = false,
}) {
  Widget backgroundImgSource = Padding(
    child: ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Image.asset(
        '${getPath().imageAssetPathPrefix}/${updateNewItems.icon}',
        fit: BoxFit.fitWidth,
      ),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 1),
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
          child: Column(children: [
            GenericItemName(updateNewItems.title),
          ]),
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
              right: 1,
            )
          ],
        )
      : content;

  return InkWell(
    child: Padding(
      child: contentToDisplay,
      padding: const EdgeInsets.only(top: 18, right: 12, bottom: 0, left: 12),
    ),
    onTap: onTap ??
        () => getNavigation().navigateAwayFromHomeAsync(
              context,
              navigateTo: (_) =>
                  MajorUpdatesDetailPage(updateNewItems: updateNewItems),
            ),
  );
}

Widget majorUpdateItemDetailTilePresenter(
  BuildContext context,
  MajorUpdateItem updateItem,
) {
  return FlatCard(
    child: ListTile(
      leading: ClipRRect(
        borderRadius: NMSUIConstants.gameItemBorderRadius,
        child: LocalImage(
          imagePath: updateItem.icon.replaceAll('.png', '-icon.png'),
          boxfit: BoxFit.fill,
        ),
      ),
      title: Text(updateItem.title),
      subtitle: Text(simpleDate(updateItem.releaseDate)),
      trailing: (updateItem.emoji != null && updateItem.emoji!.isNotEmpty)
          ? Text(updateItem.emoji!, style: const TextStyle(fontSize: 25))
          : null,
      onTap: () => getNavigation().navigateAwayFromHomeAsync(
        context,
        navigateTo: (_) => MajorUpdatesDetailPage(updateNewItems: updateItem),
      ),
    ),
  );

  /*
  genericListTileWithSubtitle(
      context,
      leadingImage: updateItem.icon,
      name: updateItem.title,
      subtitle: Text(simpleDate(updateItem.releaseDate)),
      trailing: Text(updateItem.emoji),
      onTap: () => getNavigation().navigateAwayFromHomeAsync(
        context,
        navigateTo: (_) => MajorUpdatesDetailPage(updateNewItems: updateItem),
      ),
    ),
   */
}
