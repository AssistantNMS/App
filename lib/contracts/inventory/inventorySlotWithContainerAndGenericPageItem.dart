import './inventorySlotDetails.dart';
import 'inventoryNameAndId.dart';
import 'inventorySlotWithGenericPageItem.dart';

class InventorySlotWithContainersAndGenericPageItem
    extends InventorySlotWithGenericPageItem {
  List<InventoryNameAndId> containers;

  InventorySlotWithContainersAndGenericPageItem(
      {InventorySlotDetails pageItem,
      InventoryNameAndId container,
      int quantity})
      : super(pageItem: pageItem, quantity: quantity) {
    this.containers = List.empty(growable: true);
    this.containers.add(container);
  }
}
