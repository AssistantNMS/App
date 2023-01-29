// ignore_for_file: constant_identifier_names

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/app_image.dart';

enum AlienPuzzleRaceType {
  None,
  Traders, // Gek
  Warriors, // Vykeen
  Explorers, // Korvax
  Nexus,
  Robots,
  Atlas,
  Diplomats,
  Exotics,
}

final alienPuzzleRaceTypeValues = EnumValues({
  "None": AlienPuzzleRaceType.None,
  "Traders": AlienPuzzleRaceType.Traders,
  "Warriors": AlienPuzzleRaceType.Warriors,
  "Explorers": AlienPuzzleRaceType.Explorers,
  "Nexus": AlienPuzzleRaceType.Nexus,
  "Robots": AlienPuzzleRaceType.Robots,
  "Atlas": AlienPuzzleRaceType.Atlas,
  "Diplomats": AlienPuzzleRaceType.Diplomats,
  "Exotics": AlienPuzzleRaceType.Exotics,
});

String getFactionImageFromRaceType(AlienPuzzleRaceType? race) {
  switch (race) {
    case AlienPuzzleRaceType.Traders:
      return AppImage.gekFaction;
    case AlienPuzzleRaceType.Warriors:
      return AppImage.vykeenFaction;
    case AlienPuzzleRaceType.Explorers:
      return AppImage.korvaxFaction;
    case AlienPuzzleRaceType.Atlas:
      return AppImage.atlasFaction;
    default:
      return AppImage.allFaction;
  }
}

String getFactionNameFromRaceType(
    BuildContext context, AlienPuzzleRaceType? race) {
  switch (race) {
    case AlienPuzzleRaceType.Traders:
      return getTranslations().fromKey(LocaleKey.gek);
    case AlienPuzzleRaceType.Warriors:
      return getTranslations().fromKey(LocaleKey.vykeen);
    case AlienPuzzleRaceType.Explorers:
      return getTranslations().fromKey(LocaleKey.korvax);
    case AlienPuzzleRaceType.Atlas:
      return getTranslations().fromKey(LocaleKey.atlas);
    default:
      return '';
  }
}
