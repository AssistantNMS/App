// ignore_for_file: constant_identifier_names

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

enum AlienPuzzleType {
  Unknown,
  RadioTower,
  Monolith,
  Factory,
  Harvester,
  Observatory,
  StationCore,
  CrashedFreighter,
  Plaque,
  AtlasStation,
  AbandonedBuildings,
}

final alienPuzzleTypeValues = EnumValues({
  "Unknown": AlienPuzzleType.Unknown,
  "RadioTower": AlienPuzzleType.RadioTower,
  "Monolith": AlienPuzzleType.Monolith,
  "Factory": AlienPuzzleType.Factory,
  "Harvester": AlienPuzzleType.Harvester,
  "Observatory": AlienPuzzleType.Observatory,
  "StationCore": AlienPuzzleType.StationCore,
  "CrashedFreighter": AlienPuzzleType.CrashedFreighter,
  "Plaque": AlienPuzzleType.Plaque,
  "AtlasStation": AlienPuzzleType.AtlasStation,
  "AbandonedBuildings": AlienPuzzleType.AbandonedBuildings,
});
