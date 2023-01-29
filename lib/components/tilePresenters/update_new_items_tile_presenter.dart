import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/data/update_item_detail.dart';

import '../../pages/newItemsInUpdate/new_item_details_page.dart';

Widget updateNewItemsTilePresenter(
    BuildContext context, UpdateItemDetail updateNewItems,
    {void Function()? onTap}) {
  return genericListTileWithSubtitle(
    context,
    leadingImage: null,
    name: updateNewItems.name,
    subtitle: Text(
      '${updateNewItems.date} - ${updateNewItems.itemIds.length} ${getTranslations().fromKey(LocaleKey.newItem)}',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    onTap: () async => await getNavigation().navigateAsync(context,
        navigateTo: (context) => NewItemsDetailPage(updateNewItems)),
  );
}
