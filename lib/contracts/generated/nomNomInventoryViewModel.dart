// To parse this JSON data, do
//
//     final nomNomInventoryViewModel = nomNomInventoryViewModelFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class NomNomInventoryViewModel {
  final String name;
  final List<NomNomInventorySlotViewModel> slots;

  NomNomInventoryViewModel({
    this.name,
    this.slots,
  });

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
  final String appId;
  final String icon;
  final int quantity;

  NomNomInventorySlotViewModel({
    this.appId,
    this.icon,
    this.quantity,
  });

  factory NomNomInventorySlotViewModel.fromRawJson(String str) =>
      NomNomInventorySlotViewModel.fromJson(json.decode(str));

  factory NomNomInventorySlotViewModel.fromJson(Map<String, dynamic> json) =>
      NomNomInventorySlotViewModel(
        appId: readStringSafe(json, 'appId'),
        quantity: readIntSafe(json, 'quantity'),
      );
}
