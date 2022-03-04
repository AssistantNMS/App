import 'package:flutter/material.dart';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../contracts/menuItem.dart';
import '../pages/catalogue/catalogueItemPage.dart';

List<MenuItem> getCatalogueItemData(context) {
  List<MenuItem> menuItems = List.empty(growable: true);
  menuItems.add(MenuItem(
    image: getListTileImage('drawer/rawmaterials.png'),
    title: LocaleKey.rawMaterials,
    navigateTo: (context) => const CatalogueItemPage(
      LocaleKey.rawMaterials,
      [LocaleKey.rawMaterialsJson],
    ),
  ));
  menuItems.add(MenuItem(
    image: getListTileImage('drawer/crafted.png'),
    title: LocaleKey.products,
    navigateTo: (context) => const CatalogueItemPage(
      LocaleKey.products,
      [LocaleKey.productsJson],
    ),
  ));
  menuItems.add(MenuItem(
    image: getListTileImage('drawer/equipment.png'),
    title: LocaleKey.technologies,
    navigateTo: (context) => const CatalogueItemPage(
      LocaleKey.technologies,
      [LocaleKey.technologiesJson],
    ),
  ));
  menuItems.add(MenuItem(
    image: getListTileImage('drawer/constructedTechnology.png'),
    title: LocaleKey.constructedTechnologies,
    navigateTo: (context) => const CatalogueItemPage(
      LocaleKey.constructedTechnologies,
      [LocaleKey.constructedTechnologyJson],
    ),
  ));
  menuItems.add(MenuItem(
    image: getListTileImage('drawer/building.png'),
    title: LocaleKey.buildings,
    navigateTo: (context) => const CatalogueItemPage(
      LocaleKey.buildings,
      [LocaleKey.buildingsJson],
    ),
  ));
  menuItems.add(MenuItem(
    image: getListTileImage('drawer/tradeItems.png'),
    title: LocaleKey.tradeItems,
    navigateTo: (context) => const CatalogueItemPage(
      LocaleKey.tradeItems,
      [LocaleKey.tradeItemsJson],
    ),
  ));
  menuItems.add(MenuItem(
    image: getListTileImage('drawer/curiosities.png'),
    title: LocaleKey.curiosities,
    navigateTo: (context) => const CatalogueItemPage(
      LocaleKey.curiosities,
      [LocaleKey.curiosityJson],
    ),
  ));
  menuItems.add(MenuItem(
    image: getListTileImage('drawer/cooking.png'),
    title: LocaleKey.cooking,
    navigateTo: (context) => const CatalogueItemPage(
      LocaleKey.cooking,
      [LocaleKey.cookingJson],
    ),
  ));
  menuItems.add(MenuItem(
    image: getListTileImage('drawer/upgradeModules.png'),
    title: LocaleKey.upgradeModules,
    navigateTo: (context) => const CatalogueItemPage(
      LocaleKey.upgradeModules,
      // [LocaleKey.upgradeModulesJson],
      [LocaleKey.technologyModulesJson],
    ),
  ));
  menuItems.add(MenuItem(
    image: getCorrectlySizedImageFromIcon(context, Icons.dashboard,
        colour: getTheme().getDarkModeSecondaryColour()),
    title: LocaleKey.others,
    navigateTo: (context) => const CatalogueItemPage(
      LocaleKey.others,
      [LocaleKey.otherItemsJson],
    ),
  ));

  return menuItems;
}
