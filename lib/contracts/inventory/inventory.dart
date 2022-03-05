import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import 'inventorySlot.dart';

class Inventory {
  String uuid;
  String name;
  String icon;
  List<InventorySlot> slots;

  Inventory({this.name, this.slots, this.icon, uuid}) {
    this.uuid = uuid ?? getNewGuid();
  }

  Inventory copyWith({
    String uuid,
    String name,
    String icon,
    List<InventorySlot> slots,
  }) {
    return Inventory(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      slots: slots ?? this.slots,
    );
  }

  factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
        uuid: json["uuid"],
        name: json["name"],
        icon: json["icon"],
        slots: (json["slots"] as List)
            .map((i) => InventorySlot.fromJson(i as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
        'icon': icon,
        'slots': slots,
      };
}
