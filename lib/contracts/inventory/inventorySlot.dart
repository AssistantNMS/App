import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import './inventorySlotDetails.dart';

class InventorySlot {
  String typeName;
  String uuid;
  String id;
  String icon;
  int quantity;

  InventorySlot({InventorySlotDetails pageItem, this.quantity, this.uuid}) {
    typeName = pageItem.typeName;
    id = pageItem.id;
    icon = pageItem.icon;
  }

  factory InventorySlot.fromJson(Map<String, dynamic> json) => InventorySlot(
        pageItem: InventorySlotDetails.fromJson(json["pageItem"]),
        quantity: readIntSafe(json, 'quantity'),
        uuid: getNewGuid(),
      );

  Map<String, dynamic> toJson() => {
        'pageItem': InventorySlotDetails(
          typeName: typeName,
          id: id,
          icon: icon,
        ).toJson(),
        'quantity': quantity
      };
}
