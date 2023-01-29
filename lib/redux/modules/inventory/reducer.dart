import 'package:redux/redux.dart';

import '../../../contracts/inventory/inventory.dart';
import '../../../contracts/inventory/inventory_slot.dart';
import '../../../contracts/redux/inventoryState.dart';
import 'actions.dart';

final inventoryReducer = combineReducers<InventoryState>([
  TypedReducer<InventoryState, AddInventoryAction>(_addInventoryAction),
  TypedReducer<InventoryState, EditInventoryAction>(_editInventoryAction),
  TypedReducer<InventoryState, SetInventoryOrderAction>(
      _setInventoryOrderAction),
  TypedReducer<InventoryState, RemoveInventoryAction>(_removeInventoryAction),
  TypedReducer<InventoryState, AddInventorySlotToInventoryAction>(
      _addInventorySlotToInventoryAction),
  TypedReducer<InventoryState, AddInventorySlotToInventoryWithMergeAction>(
      _addInventorySlotToInventoryWithMergeAction),
  TypedReducer<InventoryState, EditInventorySlotInInventoryAction>(
      _editInventorySlotInInventoryAction),
  TypedReducer<InventoryState, RemoveInventorySlotFromInventoryAction>(
      _removeInventorySlotToInventoryAction),
  TypedReducer<InventoryState, RestoreInventoryAction>(_restoreInventoryAction),
]);

InventoryState _addInventoryAction(
    InventoryState state, AddInventoryAction action) {
  List<Inventory> containers = state.containers;
  containers.add(action.inventory);
  return state.copyWith(containers: containers);
}

InventoryState _editInventoryAction(
    InventoryState state, EditInventoryAction action) {
  List<Inventory> newItems = List.empty(growable: true);
  for (int inventoryIndex = 0;
      inventoryIndex < state.containers.length;
      inventoryIndex++) {
    Inventory temp = state.containers[inventoryIndex];
    if (state.containers[inventoryIndex].uuid == action.inventory.uuid) {
      temp = temp.copyWith(
        name: action.inventory.name,
        icon: action.inventory.icon,
        slots: action.inventory.slots,
      );
    }
    newItems.add(temp);
  }
  return state.copyWith(containers: newItems);
}

InventoryState _setInventoryOrderAction(
  InventoryState state,
  SetInventoryOrderAction action,
) {
  return state.copyWith(orderByType: action.orderByType);
}

InventoryState _removeInventoryAction(
    InventoryState state, RemoveInventoryAction action) {
  List<Inventory> newItems = List.empty(growable: true);
  for (int inventoryIndex = 0;
      inventoryIndex < state.containers.length;
      inventoryIndex++) {
    Inventory temp = state.containers[inventoryIndex];
    if (state.containers[inventoryIndex].uuid == action.inventoryUuid) continue;
    newItems.add(temp);
  }
  return state.copyWith(containers: newItems);
}

InventoryState _addInventorySlotToInventoryAction(
  InventoryState state,
  AddInventorySlotToInventoryAction action,
) {
  List<Inventory> newContainers = List.empty(growable: true);
  for (int inventoryIndex = 0;
      inventoryIndex < state.containers.length;
      inventoryIndex++) {
    Inventory tempInventory = state.containers[inventoryIndex];
    if (tempInventory.uuid != action.inventoryUuid) {
      newContainers.add(tempInventory);
      continue;
    }
    List<InventorySlot> newSlots = List.empty(growable: true);
    for (int slotIndex = 0;
        slotIndex < tempInventory.slots.length;
        slotIndex++) {
      InventorySlot tempSlot = tempInventory.slots[slotIndex];
      newSlots.add(tempSlot);
    }
    newSlots.add(action.slot);
    tempInventory.slots = newSlots;
    newContainers.add(tempInventory);
  }
  return state.copyWith(containers: newContainers);
}

InventoryState _addInventorySlotToInventoryWithMergeAction(
  InventoryState state,
  AddInventorySlotToInventoryWithMergeAction action,
) {
  List<Inventory> newContainers = List.empty(growable: true);
  for (int inventoryIndex = 0;
      inventoryIndex < state.containers.length;
      inventoryIndex++) {
    Inventory tempInventory = state.containers[inventoryIndex];
    if (tempInventory.uuid != action.inventoryUuid) {
      newContainers.add(tempInventory);
      continue;
    }
    bool hasBeenAdded = false;
    List<InventorySlot> newSlots = List.empty(growable: true);
    for (int slotIndex = 0;
        slotIndex < tempInventory.slots.length;
        slotIndex++) {
      InventorySlot tempSlot = tempInventory.slots[slotIndex];
      if (tempSlot.id == action.slot.id) {
        tempSlot.quantity = tempSlot.quantity + action.slot.quantity;
        hasBeenAdded = true;
      }
      newSlots.add(tempSlot);
    }
    if (!hasBeenAdded) {
      newSlots.add(action.slot);
    }
    tempInventory.slots = newSlots;
    newContainers.add(tempInventory);
  }
  return state.copyWith(containers: newContainers);
}

InventoryState _editInventorySlotInInventoryAction(
  InventoryState state,
  EditInventorySlotInInventoryAction action,
) {
  List<Inventory> newItems = List.empty(growable: true);
  for (int inventoryIndex = 0;
      inventoryIndex < state.containers.length;
      inventoryIndex++) {
    Inventory tempInventory = state.containers[inventoryIndex];
    if (tempInventory.uuid != action.inventoryUuid) {
      newItems.add(tempInventory);
      continue;
    }

    List<InventorySlot> newSlots = List.empty(growable: true);
    for (int slotIndex = 0;
        slotIndex < tempInventory.slots.length;
        slotIndex++) {
      InventorySlot tempSlot = tempInventory.slots[slotIndex];
      if (tempSlot.id != action.slot.id) {
        newSlots.add(tempSlot);
        continue;
      }
      newSlots.add(action.slot);
    }
    tempInventory.slots = newSlots;
    newItems.add(tempInventory);
  }
  return state.copyWith(containers: newItems);
}

InventoryState _removeInventorySlotToInventoryAction(
  InventoryState state,
  RemoveInventorySlotFromInventoryAction action,
) {
  if (action.slot.uuid == null) {
    return _removeInventorySlotFromInventoryByAppIdAction(
      state,
      action.inventoryUuid,
      action.slot.id,
      action.slot.quantity,
    );
  }
  return _removeInventorySlotFromInventoryByUuidAction(
    state,
    action.inventoryUuid,
    action.slot.uuid,
  );
}

InventoryState _removeInventorySlotFromInventoryByUuidAction(
  InventoryState state,
  String inventoryUuid,
  String? slotUuid,
) {
  List<Inventory> newItems = List.empty(growable: true);
  for (int inventoryIndex = 0;
      inventoryIndex < state.containers.length;
      inventoryIndex++) {
    Inventory tempInventory = state.containers[inventoryIndex];
    if (tempInventory.uuid != inventoryUuid) {
      newItems.add(tempInventory);
      continue;
    }

    List<InventorySlot> newSlots = List.empty(growable: true);
    for (int slotIndex = 0;
        slotIndex < tempInventory.slots.length;
        slotIndex++) {
      InventorySlot tempSlot = tempInventory.slots[slotIndex];
      if (tempSlot.uuid == slotUuid) continue;
      newSlots.add(tempSlot);
    }
    tempInventory.slots = newSlots;
    newItems.add(tempInventory);
  }
  return state.copyWith(containers: newItems);
}

InventoryState _removeInventorySlotFromInventoryByAppIdAction(
  InventoryState state,
  String inventoryUuid,
  String slotId,
  int quantity,
) {
  List<Inventory> newItems = List.empty(growable: true);
  for (int inventoryIndex = 0;
      inventoryIndex < state.containers.length;
      inventoryIndex++) {
    Inventory tempInventory = state.containers[inventoryIndex];
    if (tempInventory.uuid != inventoryUuid) {
      newItems.add(tempInventory);
      continue;
    }

    List<InventorySlot> newSlots = List.empty(growable: true);
    for (int slotIndex = 0;
        slotIndex < tempInventory.slots.length;
        slotIndex++) {
      InventorySlot tempSlot = tempInventory.slots[slotIndex];
      if (tempSlot.id == slotId && tempSlot.quantity == quantity) continue;
      newSlots.add(tempSlot);
    }
    tempInventory.slots = newSlots;
    newItems.add(tempInventory);
  }
  return state.copyWith(containers: newItems);
}

InventoryState _restoreInventoryAction(
        InventoryState state, RestoreInventoryAction action) =>
    state.copyWith(containers: action.newState.containers);
