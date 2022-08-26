import './inventorySlotDetails.dart';
import 'inventoryBasicInfo.dart';
import 'inventorySlotWithGenericPageItem.dart';

class InventorySlotWithContainersAndGenericPageItem
    extends InventorySlotWithGenericPageItem {
  List<InventoryBasicInfo> containers;

  InventorySlotWithContainersAndGenericPageItem({
    InventorySlotDetails pageItem,
    InventoryBasicInfo container,
    String name,
    int quantity,
  }) : super(pageItem: pageItem, name: name, quantity: quantity) {
    containers = List.empty(growable: true);
    containers.add(container);
  }
}
