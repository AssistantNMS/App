import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';

import '../../components/dialogs/asyncInputDialog.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../contracts/genericPageItem.dart';
import '../../contracts/search/orderByOptionType.dart';
import '../../contracts/search/searchOption.dart';
import '../../contracts/search/searchOptionType.dart';
import '../../helpers/futureHelper.dart';
import '../../helpers/genericHelper.dart';
import '../../mapper/RarityMapper.dart';
import 'advancedSearchResults.dart';

class AdvancedSearch extends StatefulWidget {
  @override
  _AdvancedSearchWidget createState() => _AdvancedSearchWidget(
        (context) => getMegaList(context),
      );
}

class _AdvancedSearchWidget extends State<AdvancedSearch> {
  final getAllItemsList;
  List<String> groups = List.empty(growable: true);
  bool showResults = false;

  List<SearchOption> searchOptions = List.empty(growable: true);
  OrderByOptionType orderByType = OrderByOptionType.name;

  _AdvancedSearchWidget(this.getAllItemsList) {
    searchOptions.add(SearchOption(
        title: LocaleKey.itemName,
        image: 'drawer/language.png',
        type: SearchOptionType.title));
    searchOptions.add(SearchOption(
        title: LocaleKey.type,
        image: 'search/refiner.png',
        type: SearchOptionType.type));
    searchOptions.add(SearchOption(
        title: LocaleKey.group,
        image: 'search/refiner.png',
        type: SearchOptionType.group));
    searchOptions.add(SearchOption(
        title: LocaleKey.isConsumable,
        image: 'cooking/130.png',
        type: SearchOptionType.isConsumable));
    searchOptions.add(SearchOption(
        title: LocaleKey.minValue,
        image: 'credits.png',
        type: SearchOptionType.minValue));
    searchOptions.add(SearchOption(
        title: LocaleKey.maxValue,
        image: 'credits.png',
        type: SearchOptionType.maxValue));
  }

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.searchOptions),
      body: getbody(context),
    );
  }

  Widget getbody(BuildContext context) {
    List<Widget> items = List.empty(growable: true);
    for (var searchOption in searchOptions) {
      items.add(flatCard(
        child: genericListTileWithSubtitle(context,
            leadingImage: searchOption.image,
            name: getTranslations().fromKey(searchOption.title),
            subtitle: Text(searchOption.value),
            onTap: () => editSearchOption(context, searchOption.type)),
      ));
    }

    items.add(customDivider());

    items.add(flatCard(
      child: genericListTileWithSubtitle(context,
          leadingImage: 'search/orderBy.png',
          name: getTranslations().fromKey(LocaleKey.orderBy),
          subtitle: Text(
            getTranslations().fromKey(getOrderByLocale(orderByType)),
          ),
          onTap: () => editOrderByOption(context)),
    ));

    items.add(searchButton(context));
    items.add(clearButton(context));

    return listWithScrollbar(
      itemCount: items.length,
      itemBuilder: (context, index) => items[index],
    );
  }

  Future editSearchOption(context, SearchOptionType type) async {
    ResultWithValue<List<GenericPageItem>> allItems =
        ResultWithValue<List<GenericPageItem>>(false, null, '');
    if (type == SearchOptionType.group || type == SearchOptionType.rarity) {
      allItems = await this.getAllItemsList(context);
    }

    String result = '';
    dynamic actualValue = '';
    switch (type) {
      case SearchOptionType.type:
        String temp = await getNavigation().navigateAsync(
          context,
          navigateTo: (context) => OptionsListPageDialog(
              getTranslations().fromKey(LocaleKey.type), getTypes(context)),
        );
        result = (temp == null || temp.length <= 0) ? '' : temp;
        break;
      case SearchOptionType.group:
        if (allItems.hasFailed) return;
        var uniqueGroupItems = allItems.value
            .map((ai) => removeAllNameVariables(ai.group))
            .toSet()
            .where((ai) => ai.isNotEmpty)
            .map((g) => DropdownOption(g))
            .toList();
        String temp = await getNavigation().navigateAsync(
          context,
          navigateTo: (context) => OptionsListPageDialog(
              getTranslations().fromKey(LocaleKey.group), uniqueGroupItems),
        );
        result = (temp == null || temp.length <= 0) ? '' : temp;
        break;
      case SearchOptionType.isConsumable:
        List<DropdownOption> options = List.empty(growable: true);
        options.add(DropdownOption(getTranslations().fromKey(LocaleKey.yes)));
        options.add(DropdownOption(getTranslations().fromKey(LocaleKey.no)));
        String temp = await getNavigation().navigateAsync(
          context,
          navigateTo: (context) => OptionsListPageDialog(
              getTranslations().fromKey(LocaleKey.isConsumable), options),
        );
        result = (temp == null || temp.length <= 0) ? '' : temp;
        break;
      case SearchOptionType.rarity:
        if (allItems.hasFailed) return;
        // TODO Search rarity
        var uniqueRarity = []; //allItems.value
        // .where((ur) => ur is RawMaterial)
        // .map((ur) => (ur as RawMaterial).rarity)
        // .toSet()
        // .map((rarity) => mapRarityToDropdownOption(context, rarity))
        // .where((dropDown) => dropDown != null)
        // .toList();
        String temp = await getNavigation().navigateAsync(
          context,
          navigateTo: (context) => OptionsListPageDialog(
              getTranslations().fromKey(LocaleKey.rarity), uniqueRarity),
        );
        var rarityTemp = (temp == null || temp.length <= 0) ? '' : temp;
        result = mapStringToRarityText(context, rarityTemp);
        actualValue = rarityTemp;
        if (result == null) result = '';
        break;
      case SearchOptionType.title:
        LocaleKey key = LocaleKey.itemName;
        var temp =
            await asyncInputDialog(context, getTranslations().fromKey(key));
        result = (temp == null || temp.length <= 0) ? '' : temp;
        break;
      case SearchOptionType.minValue:
      case SearchOptionType.maxValue:
        LocaleKey key = (type == SearchOptionType.minValue)
            ? LocaleKey.minValue
            : LocaleKey.maxValue;
        var temp = await asyncInputDialog(
            context, getTranslations().fromKey(key),
            inputType: TextInputType.number);
        result = (temp == null || temp.length <= 0) ? '' : temp;
        break;
      default:
        var temp = await asyncInputDialog(context, '');
        result = (temp == null || temp.length <= 0) ? '' : temp;
        break;
    }
    setValue(type, result, actualValue);
  }

  Future editOrderByOption(context) async {
    List<DropdownOption> options = List.empty(growable: true);
    options.add(DropdownOption(
      getTranslations().fromKey(getOrderByLocale(OrderByOptionType.name)),
      value: EnumToString.convertToString(OrderByOptionType.name),
    ));
    options.add(DropdownOption(
      getTranslations().fromKey(getOrderByLocale(OrderByOptionType.unitPrice)),
      value: EnumToString.convertToString(OrderByOptionType.unitPrice),
    ));
    options.add(DropdownOption(
      getTranslations()
          .fromKey(getOrderByLocale(OrderByOptionType.nanitePrice)),
      value: EnumToString.convertToString(OrderByOptionType.nanitePrice),
    ));
    options.add(DropdownOption(
      getTranslations()
          .fromKey(getOrderByLocale(OrderByOptionType.quicksilverPrice)),
      value: EnumToString.convertToString(OrderByOptionType.quicksilverPrice),
    ));

    String temp = await getNavigation().navigateAsync(
      context,
      navigateTo: (context) => OptionsListPageDialog(
          getTranslations().fromKey(LocaleKey.group), options),
    );
    var result = (temp == null || temp.length <= 0) ? '' : temp;
    setState(() {
      orderByType = EnumToString.fromString(OrderByOptionType.values, result);
    });
  }

  Widget searchButton(context) {
    return Container(
      child: MaterialButton(
        child: Text(getTranslations().fromKey(LocaleKey.search)),
        color: getTheme().getSecondaryColour(context),
        onPressed: () async {
          ResultWithValue<List<GenericPageItem>> allItems =
              await this.getAllItemsList(context);
          if (allItems.hasFailed) return;
          await getNavigation().navigateAsync(context,
              navigateTo: (context) => AdvancedSearchResults(
                    allItems.value,
                    this.searchOptions,
                    this.orderByType,
                  ));
        },
      ),
      margin: EdgeInsets.all(4),
    );
  }

  Widget clearButton(context) {
    return Container(
      child: MaterialButton(
        child: Text(getTranslations().fromKey(LocaleKey.clear)),
        color: Colors.red,
        onPressed: () {
          for (var searchOpt in searchOptions) {
            setValue(searchOpt.type, '', '');
          }
        },
      ),
      margin: EdgeInsets.all(4),
    );
  }

  void setValue(SearchOptionType type, String value, dynamic actualValue) {
    List<SearchOption> newSearchOptions = List.empty(growable: true);
    for (var searchOpt in searchOptions) {
      if (searchOpt.type == type) {
        searchOpt.value = value;
        searchOpt.actualValue = actualValue;
      }
      newSearchOptions.add(searchOpt);
    }
    setState(() {
      searchOptions = newSearchOptions;
    });
  }

  void setVisibility(SearchOptionType type, bool hidden) {
    List<SearchOption> newSearchOptions = List.empty(growable: true);
    for (var searchOpt in searchOptions) {
      if (searchOpt.type == type) {
        searchOpt.hidden = hidden;
      }
      newSearchOptions.add(searchOpt);
    }
    setState(() {
      searchOptions = newSearchOptions;
    });
  }

  List<DropdownOption> getTypes(BuildContext context) {
    List<DropdownOption> types = List.empty(growable: true);
    types.add(DropdownOption(getTranslations().fromKey(LocaleKey.buildings)));
    types.add(DropdownOption(getTranslations().fromKey(LocaleKey.cooking)));
    types.add(DropdownOption(getTranslations().fromKey(LocaleKey.curiosities)));
    types.add(DropdownOption(getTranslations().fromKey(LocaleKey.others)));
    types.add(DropdownOption(getTranslations().fromKey(LocaleKey.products)));
    types
        .add(DropdownOption(getTranslations().fromKey(LocaleKey.rawMaterials)));
    types
        .add(DropdownOption(getTranslations().fromKey(LocaleKey.technologies)));
    types.add(DropdownOption(
        getTranslations().fromKey(LocaleKey.constructedTechnologies)));
    types.add(DropdownOption(getTranslations().fromKey(LocaleKey.tradeItems)));
    types.add(
        DropdownOption(getTranslations().fromKey(LocaleKey.upgradeModules)));
    types.add(DropdownOption(
        getTranslations().fromKey(LocaleKey.proceduralProducts)));
    return types;
  }
}
