import '../../../contracts/redux/inventoryState.dart';

import '../../../contracts/redux/appState.dart';
import '../../../contracts/inventory/inventory.dart';
import '../../../contracts/inventory/inventoryOrderByType.dart';

List<Inventory> getContainers(AppState state) =>
    state.inventoryState?.containers ?? InventoryState.initial().containers;

InventoryOrderByType getOrderByType(AppState state) =>
    state.inventoryState?.orderByType ?? InventoryState.initial().orderByType;
