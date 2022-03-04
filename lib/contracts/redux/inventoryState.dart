import 'dart:convert';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:meta/meta.dart';

import '../inventory/inventory.dart';
import '../inventory/inventoryOrderByType.dart';

@immutable
class InventoryState {
  final List<Inventory> containers;
  final InventoryOrderByType orderByType;

  const InventoryState({this.containers, this.orderByType});

  factory InventoryState.initial() {
    return InventoryState(
      containers: List.empty(growable: true),
      orderByType: InventoryOrderByType.name,
    );
  }

  InventoryState copyWith({
    List<Inventory> containers,
    InventoryOrderByType orderByType,
  }) {
    return InventoryState(
      containers: containers ?? this.containers,
      orderByType: orderByType ?? this.orderByType,
    );
  }

  factory InventoryState.fromJson(Map<String, dynamic> json) {
    if (json == null) return InventoryState.initial();
    try {
      return InventoryState(
        containers: readListSafe<Inventory>(
          json,
          'containers',
          (p) => Inventory.fromJson(p),
        ).toList(),
        orderByType:
            InventoryOrderByType.values[readIntSafe(json, 'orderByType')],
      );
    } catch (exception) {
      return InventoryState.initial();
    }
  }

  Map<String, dynamic> toJson() => {
        'containers': containers,
        'orderByType': inventoryOrderByTypeToInt(orderByType),
      };

  String toGoogleJson() => jsonEncode(toJson());
}
