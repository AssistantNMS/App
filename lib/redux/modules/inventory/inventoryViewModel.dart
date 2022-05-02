import 'package:redux/redux.dart';

import '../../../contracts/inventory/inventory.dart';
// import '../../../contracts/inventory/inventorySlot.dart';
import '../../../contracts/redux/appState.dart';
import 'actions.dart';
import 'selector.dart';

class InventoryViewModel {
  List<Inventory> containers;

  Function(Inventory inventory) addInventory;
  Function(Inventory inventory) editInventory;
  Function(String inventoryUuid) removeInventory;

  InventoryViewModel({
    this.containers,
    this.addInventory,
    this.editInventory,
    this.removeInventory,
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
