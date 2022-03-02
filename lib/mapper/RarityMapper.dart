import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../contracts/rawMaterialDetail.dart';

DropdownOption mapRarityToDropdownOption(context, Rarity rarity) {
  LocaleKey key = LocaleKey.unknown;
  if (rarity == Rarity.COMMON) {
    key = LocaleKey.common;
  }
  if (rarity == Rarity.UNCOMMON) {
    key = LocaleKey.uncommon;
  }
  if (rarity == Rarity.RARE) {
    key = LocaleKey.rare;
  }

  if (key == LocaleKey.unknown) return null;

  String value = rarityValues.reverse[rarity];
  if (!value.isNotEmpty) return null;

  return DropdownOption(getTranslations().fromKey(key), value: value);
}

String mapStringToRarityText(context, String rarityString) {
  Rarity rarity = rarityValues.map[rarityString];
  LocaleKey key = LocaleKey.unknown;
  if (rarity == Rarity.COMMON) {
    key = LocaleKey.common;
  }
  if (rarity == Rarity.UNCOMMON) {
    key = LocaleKey.uncommon;
  }
  if (rarity == Rarity.RARE) {
    key = LocaleKey.rare;
  }

  if (key == LocaleKey.unknown) return null;

  String value = rarityValues.reverse[rarity];
  if (!value.isNotEmpty) return null;

  return getTranslations().fromKey(key);
}
