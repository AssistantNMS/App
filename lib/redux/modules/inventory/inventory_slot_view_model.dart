import 'package:redux/redux.dart';

import '../../../contracts/inventory/inventory_slot.dart';
import '../../../contracts/redux/app_state.dart';
import '../setting/selector.dart';
import 'actions.dart';

class InventorySlotViewModel {
  Function(String inventoryUuid, InventorySlot slot)
      addInventorySlotToInventory;
  Function(String inventoryUuid, InventorySlot slot)
      editInventorySlotInInventory;
  Function(String inventoryUuid, InventorySlot slot)
      removeInventorySlotFromInventory;

  InventorySlotViewModel({
    required this.addInventorySlotToInventory,
    required this.editInventorySlotInInventory,
    required this.removeInventorySlotFromInventory,
  });

  static InventorySlotViewModel fromStore(Store<AppState> store) {
    bool mergeInventoryQuantities = getMergeInventoryQuantities(store.state);

    return InventorySlotViewModel(
      addInventorySlotToInventory: (String inventoryUuid, InventorySlot slot) =>
          store.dispatch(
        mergeInventoryQuantities
            ? AddInventorySlotToInventoryWithMergeAction(inventoryUuid, slot)
            : AddInventorySlotToInventoryAction(inventoryUuid, slot),
      ),
      editInventorySlotInInventory:
          (String inventoryUuid, InventorySlot slot) => store.dispatch(
        EditInventorySlotInInventoryAction(
          inventoryUuid,
          slot,
        ),
      ),
      removeInventorySlotFromInventory:
          (String inventoryUuid, InventorySlot slot) => store.dispatch(
        RemoveInventorySlotFromInventoryAction(
          inventoryUuid,
          slot,
        ),
      ),
    );
  }
}
