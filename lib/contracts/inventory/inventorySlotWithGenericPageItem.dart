import 'inventorySlot.dart';

class InventorySlotWithGenericPageItem extends InventorySlot {
  String name;
  String icon;

  InventorySlotWithGenericPageItem({
    String id,
    this.name,
    this.icon,
    int quantity,
  }) : super(id: id, quantity: quantity);
}
