// To parse this JSON data, do
//
//     final nomNomInventoryViewModel = nomNomInventoryViewModelFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class NomNomInventoryViewModel {
  final String name;
  final NomNomInventoryType type;
  final NomNomSubInventoryType subType;
  final List<NomNomInventorySlotViewModel> slots;

  NomNomInventoryViewModel({
    required this.name,
    required this.type,
    required this.subType,
    required this.slots,
  });

  factory NomNomInventoryViewModel.fromRawJson(String str) =>
      NomNomInventoryViewModel.fromJson(json.decode(str));

  factory NomNomInventoryViewModel.fromJson(Map<String, dynamic>? json) =>
      NomNomInventoryViewModel(
        name: readStringSafe(json, 'name'),
        type: nomNomInventoryTypeValues
            .map[readIntSafe(json, 'type').toString()]!,
        subType: nomNomSubInventoryTypeValues
            .map[readIntSafe(json, 'subType').toString()]!,
        slots: readListSafe<NomNomInventorySlotViewModel>(
          json,
          'slots',
          (dynamic json) => NomNomInventorySlotViewModel.fromJson(json),
        ),
      );
}

class NomNomInventorySlotViewModel {
  final String appId;
  final int quantity;

  NomNomInventorySlotViewModel({
    required this.appId,
    required this.quantity,
  });

  factory NomNomInventorySlotViewModel.fromRawJson(String str) =>
      NomNomInventorySlotViewModel.fromJson(json.decode(str));

  factory NomNomInventorySlotViewModel.fromJson(Map<String, dynamic>? json) =>
      NomNomInventorySlotViewModel(
        appId: readStringSafe(json, 'appId'),
        quantity: readIntSafe(json, 'quantity'),
      );
}

enum NomNomInventoryType {
  unknown,
  exosuit,
  starship,
  roamer,
  nomad,
  pilgrim,
  colossus,
  minotaur,
  nautilon,
  freighter,
  storageContainer0,
  storageContainer1,
  storageContainer2,
  storageContainer3,
  storageContainer4,
  storageContainer5,
  storageContainer6,
  storageContainer7,
  storageContainer8,
  storageContainer9,
  nutrientProcessor,
  multiTool,
}

final nomNomInventoryTypeValues = EnumValues({
  "0": NomNomInventoryType.unknown,
  "1": NomNomInventoryType.exosuit,
  "2": NomNomInventoryType.starship,
  "3": NomNomInventoryType.roamer,
  "4": NomNomInventoryType.nomad,
  "5": NomNomInventoryType.pilgrim,
  "6": NomNomInventoryType.colossus,
  "7": NomNomInventoryType.minotaur,
  "8": NomNomInventoryType.nautilon,
  "9": NomNomInventoryType.freighter,
  "10": NomNomInventoryType.storageContainer0,
  "11": NomNomInventoryType.storageContainer1,
  "12": NomNomInventoryType.storageContainer2,
  "13": NomNomInventoryType.storageContainer3,
  "14": NomNomInventoryType.storageContainer4,
  "15": NomNomInventoryType.storageContainer5,
  "16": NomNomInventoryType.storageContainer6,
  "17": NomNomInventoryType.storageContainer7,
  "18": NomNomInventoryType.storageContainer8,
  "19": NomNomInventoryType.storageContainer9,
  "20": NomNomInventoryType.nutrientProcessor,
  "21": NomNomInventoryType.multiTool,
});

enum NomNomSubInventoryType {
  unknown,
  general,
  cargo,
  tech,
}

final nomNomSubInventoryTypeValues = EnumValues({
  "0": NomNomSubInventoryType.unknown,
  "1": NomNomSubInventoryType.general,
  "2": NomNomSubInventoryType.cargo,
  "3": NomNomSubInventoryType.tech,
});
