import 'package:redux/redux.dart';

import '../../../contracts/redux/appState.dart';
import '../../../contracts/redux/inventoryState.dart';
import '../../../contracts/redux/portalState.dart';
import '../inventory/actions.dart';
import '../portal/actions.dart';
import '../setting/selector.dart';

class SyncPageViewModel {
  final PortalState portalState;
  final InventoryState inventoryState;
  final bool isPatron;

  final Function(PortalState newState) restorePortals;
  final Function(InventoryState newState) restoreInventory;

  SyncPageViewModel({
    required this.portalState,
    required this.inventoryState,
    required this.restorePortals,
    required this.restoreInventory,
    required this.isPatron,
  });

  static SyncPageViewModel fromStore(Store<AppState> store) {
    return SyncPageViewModel(
      portalState: store.state.portalState,
      inventoryState: store.state.inventoryState,
      isPatron: getIsPatron(store.state),
      //
      restorePortals: (PortalState newState) =>
          store.dispatch(RestorePortalsAction(newState)),
      restoreInventory: (InventoryState newState) =>
          store.dispatch(RestoreInventoryAction(newState)),
    );
  }
}
