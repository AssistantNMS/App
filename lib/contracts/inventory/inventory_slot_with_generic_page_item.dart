import 'inventory_slot.dart';

class InventorySlotWithGenericPageItem extends InventorySlot {
  String name;
  String? icon;

  InventorySlotWithGenericPageItem({
    required String id,
    required this.name,
    this.icon,
    required int quantity,
  }) : super(id: id, quantity: quantity);
}
