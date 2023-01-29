import 'package:redux/redux.dart';

import '../../../contracts/inventory/inventory.dart';
// import '../../../contracts/inventory/inventory_slot.dart';
import '../../../contracts/redux/app_state.dart';
import 'actions.dart';
import 'selector.dart';

class InventoryViewModel {
  List<Inventory> containers;

  Function(Inventory inventory) addInventory;
  Function(Inventory inventory) editInventory;
  Function(String inventoryUuid) removeInventory;

  InventoryViewModel({
    required this.containers,
    required this.addInventory,
    required this.editInventory,
    required this.removeInventory,
  });

  static InventoryViewModel fromStore(Store<AppState> store) {
    return InventoryViewModel(
      containers: getContainers(store.state),
      addInventory: (Inventory inventory) =>
          store.dispatch(AddInventoryAction(inventory)),
      editInventory: (Inventory inventory) =>
          store.dispatch(EditInventoryAction(inventory)),
      removeInventory: (String inventoryUuid) =>
          store.dispatch(RemoveInventoryAction(inventoryUuid)),
    );
  }
}
