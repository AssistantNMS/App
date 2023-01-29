import 'package:redux/redux.dart';

import '../../../contracts/inventory/inventory.dart';
import '../../../contracts/inventory/inventory_order_by_type.dart';
import '../../../contracts/redux/appState.dart';
import '../setting/selector.dart';
import 'actions.dart';
import 'selector.dart';

class InventoryListViewModel {
  List<Inventory> containers;
  InventoryOrderByType orderByType;
  bool mergeInventoryQuantities;
  bool isPatron;

  Function(Inventory inventory) addInventory;
  Function(Inventory inventory) editInventory;
  Function(String inventoryUuid) removeInventory;
  Function(InventoryOrderByType orderByType) setOrderByType;

  InventoryListViewModel({
    required this.containers,
    required this.orderByType,
    required this.addInventory,
    required this.editInventory,
    required this.removeInventory,
    required this.setOrderByType,
    required this.mergeInventoryQuantities,
    required this.isPatron,
  });

  static InventoryListViewModel fromStore(Store<AppState> store) {
    return InventoryListViewModel(
      containers: getContainers(store.state),
      orderByType: getOrderByType(store.state),
      mergeInventoryQuantities: getMergeInventoryQuantities(store.state),
      isPatron: getIsPatron(store.state),
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
