import '../../../contracts/inventory/inventory.dart';
import '../../../contracts/inventory/inventoryOrderByType.dart';
import '../../../contracts/redux/appState.dart';

List<Inventory> getContainers(AppState state) =>
    state.inventoryState.containers;

InventoryOrderByType getOrderByType(AppState state) =>
    state.inventoryState.orderByType;
