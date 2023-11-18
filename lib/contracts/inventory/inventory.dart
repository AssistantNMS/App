import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import 'inventory_slot.dart';

class Inventory {
  late String uuid;
  String name;
  String icon;
  List<InventorySlot> slots;

  Inventory({
    required this.name,
    required this.slots,
    required this.icon,
    String? uuid,
  }) {
    this.uuid = uuid ?? getNewGuid();
  }

  Inventory copyWith({
    String? uuid,
    String? name,
    String? icon,
    List<InventorySlot>? slots,
  }) {
    return Inventory(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      slots: slots ?? this.slots,
    );
  }

  factory Inventory.initial(String name) => Inventory(
        uuid: getNewGuid(),
        name: name,
        icon: '',
        slots: [],
      );

  factory Inventory.fromJson(Map<String, dynamic>? json) => Inventory(
        uuid: readStringSafe(json, 'uuid'),
        name: readStringSafe(json, 'name'),
        icon: readStringSafe(json, 'icon'),
        slots: readListSafe(
          json,
          'slots',
          (i) => InventorySlot.fromJson(i),
        ),
      );

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
        'icon': icon,
        'slots': slots,
      };
}
