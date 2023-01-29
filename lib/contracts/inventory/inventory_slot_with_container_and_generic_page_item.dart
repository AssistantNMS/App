import 'inventory_basic_info.dart';
import 'inventory_slot_with_generic_page_item.dart';

class InventorySlotWithContainersAndGenericPageItem
    extends InventorySlotWithGenericPageItem {
  late List<InventoryBasicInfo> containers;

  InventorySlotWithContainersAndGenericPageItem({
    required String id,
    required InventoryBasicInfo container,
    required String name,
    required int quantity,
  }) : super(id: id, name: name, quantity: quantity) {
    containers = List.empty(growable: true);
    containers.add(container);
  }
}
