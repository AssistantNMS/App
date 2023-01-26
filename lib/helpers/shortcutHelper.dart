import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../constants/Routes.dart';

List<ActionItem> getShortcutActions(
  BuildContext context, {
  bool hideCart = false,
  bool hideInventory = false,
  List<ActionItem>? additionalShortcutLinks,
}) {
  List<ActionItem> items = List.empty(growable: true);
  items.add(ActionItem(
    icon: Icons.star,
    image: getCorrectlySizedImageFromIcon(context, Icons.star,
        colour: getTheme().getDarkModeSecondaryColour()),
    text: getTranslations().fromKey(LocaleKey.favourites),
    onPressed: () => getNavigation()
        .navigateHomeAsync(context, navigateToNamed: Routes.favourites),
  ));
  if (!hideCart) {
    items.add(ActionItem(
      icon: Icons.shopping_basket, //fallback
      image: getListTileImage('drawer/cart.png'),
      text: getTranslations().fromKey(LocaleKey.cart),
      onPressed: () => getNavigation()
          .navigateHomeAsync(context, navigateToNamed: Routes.cart),
    ));
  }
  if (!hideInventory) {
    items.add(ActionItem(
      icon: Icons.storage, //fallback
      text: getTranslations().fromKey(LocaleKey.inventoryManagement),
      image: getListTileImage('drawer/inventory.png'),
      onPressed: () => getNavigation()
          .navigateHomeAsync(context, navigateToNamed: Routes.inventoryList),
    ));
  }

  if (additionalShortcutLinks != null) {
    items.addAll(additionalShortcutLinks);
  }

  return items;
}
