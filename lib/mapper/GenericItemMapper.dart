import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../constants/IdPrefix.dart';
import '../contracts/genericPageItem.dart';
import '../contracts/requiredItem.dart';
import '../contracts/requiredItemDetails.dart';

Future<RequiredItemDetails> toRequiredItemDetails(
    context, RequiredItem requiredItem, GenericPageItem genericItem) async {
  return RequiredItemDetails(
    id: requiredItem.id,
    quantity: requiredItem.quantity,
    icon: genericItem.icon,
    name: genericItem.name,
    colour: genericItem.colour,
  );
}

List<RequiredItemDetails> mapUsedInToRequiredItemsWithDescrip(
        List<GenericPageItem> usedInRecipes) =>
    (usedInRecipes.isEmpty)
        ? List.empty(growable: true)
        : usedInRecipes
            .map(
              (recipe) => RequiredItemDetails(
                  id: recipe.id,
                  icon: recipe.icon,
                  name: recipe.name,
                  colour: recipe.colour,
                  quantity: 0),
            )
            .toList();

// List<GenericPageItem> mapGenericPageItems(
//     context, List<ItemBaseDetail> details) {
//   List<GenericPageItem> result = List.empty(growable: true);
//   for (int baseIndex = 0; baseIndex < details.length; baseIndex++) {
//     ItemBaseDetail detail = details[baseIndex];
//     // ignore: unnecessary_null_comparison
//     if (detail.id == null) continue;

//     GenericPageItem newItem = GenericPageItem.fromBaseWithDetails(detail);
//     // ignore: prefer_is_empty
//     if ((newItem.name.length) < 1) {
//       newItem.name = getTranslations().fromKey(LocaleKey.unknown);
//     }
//     result.add(newItem);
//   }
//   return result;
// }

String getTypeName(context, String id) {
  LocaleKey? key = LocaleKey.unknown;

  if (id.contains(IdPrefix.building)) {
    key = LocaleKey.buildings;
  }
  if (id.contains(IdPrefix.cooking)) {
    key = LocaleKey.cooking;
  }
  if (id.contains(IdPrefix.curiosity)) {
    key = LocaleKey.curiosities;
  }
  if (id.contains(IdPrefix.other)) {
    key = LocaleKey.others;
  }
  if (id.contains(IdPrefix.procProd)) {
    key = LocaleKey.proceduralProducts;
  }
  if (id.contains(IdPrefix.product)) {
    key = LocaleKey.products;
  }
  if (id.contains(IdPrefix.rawMaterial)) {
    key = LocaleKey.rawMaterials;
  }
  if (id.contains(IdPrefix.conTech)) {
    key = LocaleKey.constructedTechnologies;
  }
  if (id.contains(IdPrefix.techMod)) {
    key = LocaleKey.technologies;
  }
  if (id.contains(IdPrefix.technology)) {
    key = LocaleKey.technologies;
  }
  if (id.contains(IdPrefix.trade)) {
    key = LocaleKey.tradeItems;
  }
  if (id.contains(IdPrefix.upgrade)) {
    key = LocaleKey.upgradeModules;
  }

  return getTranslations().fromKey(key);
}
