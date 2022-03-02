import './inventorySlotDetails.dart';

class InventorySlot {
  String typeName;
  String id;
  String icon;
  int quantity;

  InventorySlot({InventorySlotDetails pageItem, int quantity}) {
    this.quantity = quantity;
    this.typeName = pageItem.typeName;
    this.id = pageItem.id;
    this.icon = pageItem.icon;
  }

  factory InventorySlot.fromJson(Map<String, dynamic> json) => InventorySlot(
      pageItem: InventorySlotDetails.fromJson(json["pageItem"]),
      quantity: json["quantity"] as int);

  Map<String, dynamic> toJson() => {
        'pageItem': InventorySlotDetails(
          typeName: this.typeName,
          id: this.id,
          icon: this.icon,
        ).toJson(),
        'quantity': this.quantity
      };
}
