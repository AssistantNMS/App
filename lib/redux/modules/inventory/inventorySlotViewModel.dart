import 'package:redux/redux.dart';

import '../../../contracts/inventory/inventorySlot.dart';
import '../../../contracts/redux/appState.dart';
import 'actions.dart';

class InventorySlotViewModel {
  Function(String inventoryUuid, InventorySlot slot)
      addInventorySlotToInventory;
  Function(String inventoryUuid, InventorySlot slot)
      editInventorySlotInInventory;
  Function(String inventoryUuid, String inventorySlotId)
      removeInventorySlotToInventory;

  InventorySlotViewModel({
    this.addInventorySlotToInventory,
    this.editInventorySlotInInventory,
    this.removeInventorySlotToInventory,
  });

  static InventorySlotViewModel fromStore(Store<AppState> store) {
    return InventorySlotViewModel(
      addInventorySlotToInventory: (String inventoryUuid, InventorySlot slot) =>
          store
              .dispatch(AddInventorySlotToInventoryAction(inventoryUuid, slot)),
      editInventorySlotInInventory:
          (String inventoryUuid, InventorySlot slot) => store.dispatch(
              EditInventorySlotInInventoryAction(inventoryUuid, slot)),
      removeInventorySlotToInventory:
          (String inventoryUuid, String inventorySlotId) => store.dispatch(
              RemoveInventorySlotToInventoryAction(
                  inventoryUuid, inventorySlotId)),
    );
  }
}
