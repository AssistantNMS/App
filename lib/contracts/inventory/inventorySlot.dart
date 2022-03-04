import './inventorySlotDetails.dart';

class InventorySlot {
  String typeName;
  String id;
  String icon;
  int quantity;

  InventorySlot({InventorySlotDetails pageItem, this.quantity}) {
    typeName = pageItem.typeName;
    id = pageItem.id;
    icon = pageItem.icon;
  }

  factory InventorySlot.fromJson(Map<String, dynamic> json) => InventorySlot(
      pageItem: InventorySlotDetails.fromJson(json["pageItem"]),
      quantity: json["quantity"] as int);

  Map<String, dynamic> toJson() => {
        'pageItem': InventorySlotDetails(
          typeName: typeName,
          id: id,
          icon: icon,
        ).toJson(),
        'quantity': quantity
      };
}
