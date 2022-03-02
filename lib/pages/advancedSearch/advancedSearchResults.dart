import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../helpers/genericHelper.dart';

import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/genericTilePresenter.dart';
import '../../constants/IdPrefix.dart';
import '../../contracts/enum/currencyType.dart';
import '../../contracts/genericPageItem.dart';
import '../../contracts/search/orderByOptionType.dart';
import '../../contracts/search/searchOption.dart';
import '../../contracts/search/searchOptionType.dart';
import '../../helpers/searchHelpers.dart';

class AdvancedSearchResults extends StatelessWidget {
  final List<GenericPageItem> items;
  final List<SearchOption> searchOptions;
  final OrderByOptionType orderByType;
  AdvancedSearchResults(this.items, this.searchOptions, this.orderByType);

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.searchResults),
      body: getbody(context),
    );
  }

  Widget getbody(BuildContext context) {
    List<GenericPageItem> displayItems = items;
    for (var searchOpt in searchOptions) {
      if (searchOpt.value == null || searchOpt.value == '') continue;

      var value = (searchOpt.value ?? '');
      var valueToLower = value.toLowerCase();
      switch (searchOpt.type) {
        case SearchOptionType.title:
          displayItems =
              displayItems.where((i) => search(i, valueToLower)).toList();
          break;
        case SearchOptionType.group:
          displayItems = displayItems
              .where((i) => searchGroup(
                    i,
                    removeAllNameVariables(value).toLowerCase(),
                  ))
              .toList();
          break;
        case SearchOptionType.type:
          displayItems =
              displayItems.where((i) => searchType(i, valueToLower)).toList();
          break;
        case SearchOptionType.rarity:
          var realValue = searchOpt.actualValue ?? value;
          displayItems =
              displayItems.where((i) => searchRarity(i, realValue)).toList();
          break;
        // case SearchOptionType.isConsumable:
        //   if (value == getTranslations().fromKey(LocaleKey.yes)) {
        //     displayItems = displayItems
        //         .where((i) => i.consumable != null && i.consumable == true)
        //         .where((i) =>
        //             i.id.contains(IdPrefix.cooking) ||
        //             i.id.contains(IdPrefix.rawMaterial))
        //         .toList();
        //   }
        //   if (value == getTranslations().fromKey(LocaleKey.no)) {
        //     displayItems = displayItems
        //         .where((i) => i.consumable == null || i.consumable == false)
        //         .toList();
        //   }
        //   break;
        case SearchOptionType.minValue:
          displayItems = displayItems
              .where((i) => searchMinCredit(i, int.parse(value)))
              .toList();
          break;
        case SearchOptionType.maxValue:
          displayItems = displayItems
              .where((i) => searchMaxCredit(i, int.parse(value)))
              .toList();
          break;
        default:
          break;
      }
    }

    if (orderByType == OrderByOptionType.name) {
      displayItems.sort((a, b) => a.name.compareTo(b.name));
    }

    if (orderByType == OrderByOptionType.unitPrice) {
      displayItems.removeWhere((item) =>
          item.currencyType != CurrencyType.CREDITS ||
          item.baseValueUnits <= 1);
      displayItems.sort((a, b) => a.baseValueUnits.compareTo(b.baseValueUnits));
    }

    if (orderByType == OrderByOptionType.nanitePrice) {
      displayItems.removeWhere((item) =>
          item.currencyType != CurrencyType.NANITES ||
          item.baseValueUnits <= 1);
      displayItems.sort((a, b) => a.baseValueUnits.compareTo(b.baseValueUnits));
    }

    if (orderByType == OrderByOptionType.quicksilverPrice) {
      displayItems.removeWhere((item) =>
          item.currencyType != CurrencyType.QUICKSILVER ||
          item.baseValueUnits <= 1);
      displayItems.sort((a, b) => a.baseValueUnits.compareTo(b.baseValueUnits));
    }

    return SearchableList<GenericPageItem>(
      getSearchListFutureFromList(displayItems),
      listItemDisplayer: (BuildContext ctx, GenericPageItem item) =>
          genericTilePresenter(ctx, item, false),
      listItemSearch: search,
      key: Key(getTranslations().currentLanguage),
      hintText: getTranslations().fromKey(LocaleKey.searchItems),
    );
  }
}
