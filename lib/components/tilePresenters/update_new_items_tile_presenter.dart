import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/data/updateItemDetail.dart';

import '../../pages/newItemsInUpdate/newItemDetailsPage.dart';

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
