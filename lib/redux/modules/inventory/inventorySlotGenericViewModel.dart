import 'package:redux/redux.dart';

import '../../../contracts/inventory/inventory.dart';
import '../../../contracts/inventory/inventorySlot.dart';
import '../../../contracts/redux/appState.dart';
import '../setting/selector.dart';
import 'actions.dart';
import 'selector.dart';

class InventorySlotGenericViewModel {
  final bool displayGenericItemColour;
  List<Inventory> containers;

  Function(String inventoryUuid, InventorySlot slot)
      addInventorySlotToInventory;

  InventorySlotGenericViewModel({
    required this.containers,
    required this.displayGenericItemColour,
    required this.addInventorySlotToInventory,
  });

  static InventorySlotGenericViewModel fromStore(Store<AppState> store) {
    bool mergeInventoryQuantities = getMergeInventoryQuantities(store.state);
    return InventorySlotGenericViewModel(
      containers: getContainers(store.state),
      displayGenericItemColour: getDisplayGenericItemColour(store.state),
      addInventorySlotToInventory: (String inventoryUuid, InventorySlot slot) =>
          store.dispatch(
        mergeInventoryQuantities
            ? AddInventorySlotToInventoryWithMergeAction(inventoryUuid, slot)
            : AddInventorySlotToInventoryAction(inventoryUuid, slot),
      ),
    );
  }
}
