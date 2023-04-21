import 'package:flutter/material.dart';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../contracts/custom_menu_item.dart';
import '../pages/catalogue/catalogue_item_page.dart';
import '../pages/catalogue/cooking_page.dart';

List<CustomMenuItem> getCatalogueItemData(context) {
  List<CustomMenuItem> menuItems = List.empty(growable: true);
  menuItems.add(CustomMenuItem(
    image: const ListTileImage(partialPath: 'drawer/rawmaterials.png'),
    title: LocaleKey.rawMaterials,
    navigateTo: (context) => const CatalogueItemPage(
      LocaleKey.rawMaterials,
      [LocaleKey.rawMaterialsJson],
    ),
  ));
  menuItems.add(CustomMenuItem(
    image: const ListTileImage(partialPath: 'drawer/crafted.png'),
    title: LocaleKey.products,
    navigateTo: (context) => const CatalogueItemPage(
      LocaleKey.products,
      [LocaleKey.productsJson],
    ),
  ));
  menuItems.add(CustomMenuItem(
    image: const ListTileImage(partialPath: 'drawer/equipment.png'),
    title: LocaleKey.technologies,
    navigateTo: (context) => const CatalogueItemPage(
      LocaleKey.technologies,
      [LocaleKey.technologiesJson],
    ),
  ));
  menuItems.add(CustomMenuItem(
    image: const ListTileImage(partialPath: 'drawer/constructedTechnology.png'),
    title: LocaleKey.constructedTechnologies,
    navigateTo: (context) => const CatalogueItemPage(
      LocaleKey.constructedTechnologies,
      [LocaleKey.constructedTechnologyJson],
    ),
  ));
  menuItems.add(CustomMenuItem(
    image: const ListTileImage(partialPath: 'drawer/building.png'),
    title: LocaleKey.buildings,
    navigateTo: (context) => const CatalogueItemPage(
      LocaleKey.buildings,
      [LocaleKey.buildingsJson],
    ),
  ));
  menuItems.add(CustomMenuItem(
    image: const ListTileImage(partialPath: 'drawer/tradeItems.png'),
    title: LocaleKey.tradeItems,
    navigateTo: (context) => const CatalogueItemPage(
      LocaleKey.tradeItems,
      [LocaleKey.tradeItemsJson],
    ),
  ));
  menuItems.add(CustomMenuItem(
    image: const ListTileImage(partialPath: 'drawer/curiosities.png'),
    title: LocaleKey.curiosities,
    navigateTo: (context) => const CatalogueItemPage(
      LocaleKey.curiosities,
      [LocaleKey.curiosityJson],
    ),
  ));
  menuItems.add(CustomMenuItem(
    image: const ListTileImage(partialPath: 'drawer/cooking.png'),
    title: LocaleKey.cooking,
    navigateTo: (context) => CookingTrackingPage(),
  ));
  menuItems.add(CustomMenuItem(
    image: const ListTileImage(partialPath: 'drawer/upgradeModules.png'),
    title: LocaleKey.upgradeModules,
    navigateTo: (context) => const CatalogueItemPage(
      LocaleKey.upgradeModules,
      // [LocaleKey.upgradeModulesJson],
      [LocaleKey.technologyModulesJson],
    ),
  ));
  menuItems.add(CustomMenuItem(
    image: CorrectlySizedImageFromIcon(
      icon: Icons.dashboard,
      colour: getTheme().getDarkModeSecondaryColour(),
    ),
    title: LocaleKey.others,
    navigateTo: (context) => const CatalogueItemPage(
      LocaleKey.others,
      [LocaleKey.otherItemsJson],
    ),
  ));

  return menuItems;
}
