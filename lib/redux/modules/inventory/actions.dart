import '../../../contracts/inventory/inventory.dart';
import '../../../contracts/inventory/inventory_order_by_type.dart';
import '../../../contracts/inventory/inventory_slot.dart';
import '../../../contracts/redux/inventory_state.dart';
import '../base/persist_to_storage.dart';

class AddInventoryAction extends PersistToStorage {
  final Inventory inventory;
  AddInventoryAction(this.inventory);
}

class EditInventoryAction extends PersistToStorage {
  final Inventory inventory;
  EditInventoryAction(this.inventory);
}

class SetInventoryOrderAction extends PersistToStorage {
  final InventoryOrderByType orderByType;
  SetInventoryOrderAction(this.orderByType);
}

class RemoveInventoryAction extends PersistToStorage {
  final String inventoryUuid;
  RemoveInventoryAction(this.inventoryUuid);
}

class AddInventorySlotToInventoryAction extends PersistToStorage {
  final String inventoryUuid;
  final InventorySlot slot;
  AddInventorySlotToInventoryAction(this.inventoryUuid, this.slot);
}

class AddInventorySlotToInventoryWithMergeAction extends PersistToStorage {
  final String inventoryUuid;
  final InventorySlot slot;
  AddInventorySlotToInventoryWithMergeAction(this.inventoryUuid, this.slot);
}

class EditInventorySlotInInventoryAction extends PersistToStorage {
  final String inventoryUuid;
  final InventorySlot slot;
  EditInventorySlotInInventoryAction(
    this.inventoryUuid,
    this.slot,
  );
}

class RemoveInventorySlotFromInventoryAction extends PersistToStorage {
  final String inventoryUuid;
  final InventorySlot slot;
  RemoveInventorySlotFromInventoryAction(
    this.inventoryUuid,
    this.slot,
  );
}

class RestoreInventoryAction extends PersistToStorage {
  InventoryState newState;
  RestoreInventoryAction(this.newState);
}
