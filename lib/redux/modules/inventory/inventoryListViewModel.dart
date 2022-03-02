import 'package:redux/redux.dart';

import '../../../contracts/inventory/inventory.dart';
import '../../../contracts/inventory/inventoryOrderByType.dart';
import '../../../contracts/redux/appState.dart';
import 'actions.dart';
import 'selector.dart';

class InventoryListViewModel {
  List<Inventory> containers;
  InventoryOrderByType orderByType;

  Function(Inventory inventory) addInventory;
  Function(Inventory inventory) editInventory;
  Function(String inventoryUuid) removeInventory;
  Function(InventoryOrderByType orderByType) setOrderByType;

  InventoryListViewModel({
    this.containers,
    this.orderByType,
    this.addInventory,
    this.editInventory,
    this.removeInventory,
    this.setOrderByType,
  });

  static InventoryListViewModel fromStore(Store<AppState> store) {
    return InventoryListViewModel(
      containers: getContainers(store.state),
      orderByType: getOrderByType(store.state),
      addInventory: (Inventory inventory) =>
          store.dispatch(AddInventoryAction(inventory)),
      editInventory: (Inventory inventory) =>
          store.dispatch(EditInventoryAction(inventory)),
      removeInventory: (String inventoryUuid) =>
          store.dispatch(RemoveInventoryAction(inventoryUuid)),
      setOrderByType: (InventoryOrderByType orderByType) =>
          store.dispatch(SetInventoryOrderAction(orderByType)),
    );
  }
}
