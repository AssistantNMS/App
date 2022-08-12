import './inventorySlotDetails.dart';
import 'inventorySlot.dart';

class InventorySlotWithGenericPageItem extends InventorySlot {
  String name;

  InventorySlotWithGenericPageItem(
      {InventorySlotDetails pageItem, String name, int quantity})
      : super(pageItem: pageItem, quantity: quantity) {
    name = name;
  }
}
