import 'inventoryBasicInfo.dart';
import 'inventorySlotWithGenericPageItem.dart';

class InventorySlotWithContainersAndGenericPageItem
    extends InventorySlotWithGenericPageItem {
  List<InventoryBasicInfo> containers;

  InventorySlotWithContainersAndGenericPageItem({
    String id,
    InventoryBasicInfo container,
    String name,
    int quantity,
  }) : super(id: id, name: name, quantity: quantity) {
    containers = List.empty(growable: true);
    containers.add(container);
  }
}
