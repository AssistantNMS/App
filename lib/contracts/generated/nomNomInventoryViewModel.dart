// To parse this JSON data, do
//
//     final nomNomInventoryViewModel = nomNomInventoryViewModelFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class NomNomInventoryViewModel {
  NomNomInventoryViewModel({
    this.name,
    this.slots,
  });

  final String name;
  final List<NomNomInventorySlotViewModel> slots;

  factory NomNomInventoryViewModel.fromRawJson(String str) =>
      NomNomInventoryViewModel.fromJson(json.decode(str));

  factory NomNomInventoryViewModel.fromJson(Map<String, dynamic> json) =>
      NomNomInventoryViewModel(
        name: readStringSafe(json, 'name'),
        slots: readListSafe<NomNomInventorySlotViewModel>(
          json,
          'slots',
          (dynamic json) => NomNomInventorySlotViewModel.fromJson(json),
        ),
      );
}

class NomNomInventorySlotViewModel {
  NomNomInventorySlotViewModel({
    this.appId,
    this.quantity,
  });

  final String appId;
  final int quantity;

  factory NomNomInventorySlotViewModel.fromRawJson(String str) =>
      NomNomInventorySlotViewModel.fromJson(json.decode(str));

  factory NomNomInventorySlotViewModel.fromJson(Map<String, dynamic> json) =>
      NomNomInventorySlotViewModel(
        appId: readStringSafe(json, 'appId'),
        quantity: readIntSafe(json, 'quantity'),
      );
}
