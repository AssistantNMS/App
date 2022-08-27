import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import './inventorySlotDetails.dart';

class InventorySlot {
  String uuid;
  String id;
  int quantity;

  InventorySlot({this.id, this.quantity, this.uuid});

  factory InventorySlot.fromJson(Map<String, dynamic> json) => InventorySlot(
        id: InventorySlotDetails.fromJson(json["pageItem"])?.id ?? '',
        quantity: readIntSafe(json, 'quantity'),
        uuid: getNewGuid(),
      );

  Map<String, dynamic> toJson() => {
        'pageItem': InventorySlotDetails(
          id: id,
        ).toJson(),
        'quantity': quantity
      };
}
