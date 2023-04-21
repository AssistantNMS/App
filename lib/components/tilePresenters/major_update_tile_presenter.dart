import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/nms_ui_constants.dart';
import '../../contracts/data/major_update_item.dart';
import '../../pages/newItemsInUpdate/major_updates_detail_page.dart';

Widget majorUpdateTilePresenter(
  BuildContext context,
  MajorUpdateItem updateNewItems, {
  void Function()? onTap,
}) {
  Widget backgroundImgSource = Padding(
    child: Image.asset(
      '${getPath().imageAssetPathPrefix}/${updateNewItems.icon}',
      fit: BoxFit.fitWidth,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 1),
  );

  const tileBorder = BorderRadius.only(
    topLeft: Radius.circular(12),
    topRight: Radius.circular(12),
    bottomLeft: Radius.circular(8),
    bottomRight: Radius.circular(8),
  );

  Widget content = InkWell(
    borderRadius: tileBorder,
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        backgroundImgSource,
        Container(
          color: const Color.fromRGBO(0, 0, 0, 0.45),
          child: Column(children: [
            GenericItemName(updateNewItems.title),
          ]),
          width: double.infinity,
        ),
      ],
    ),
    onTap: onTap ??
        () => getNavigation().navigateAwayFromHomeAsync(
              context,
              navigateTo: (_) =>
                  MajorUpdatesDetailPage(updateNewItems: updateNewItems),
            ),
  );

  return Padding(
    child: ClipRRect(
      borderRadius: tileBorder,
      child: content,
    ),
    padding: const EdgeInsets.only(top: 8, right: 12, bottom: 8, left: 12),
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
