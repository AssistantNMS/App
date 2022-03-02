import 'package:redux/redux.dart';

import '../../../contracts/redux/appState.dart';
import '../../../contracts/redux/inventoryState.dart';
import '../../../contracts/redux/portalState.dart';
import '../inventory/actions.dart';
import '../portal/actions.dart';

class SyncPageViewModel {
  final PortalState portalState;
  final InventoryState inventoryState;

  final Function(PortalState newState) restorePortals;
  final Function(InventoryState newState) restoreInventory;

  SyncPageViewModel({
    this.portalState,
    this.inventoryState,
    this.restorePortals,
    this.restoreInventory,
  });

  static SyncPageViewModel fromStore(Store<AppState> store) {
    return SyncPageViewModel(
      portalState: store.state.portalState,
      inventoryState: store.state.inventoryState,
      restorePortals: (PortalState newState) =>
          store.dispatch(RestorePortalsAction(newState)),
      restoreInventory: (InventoryState newState) =>
          store.dispatch(RestoreInventoryAction(newState)),
    );
  }
}
