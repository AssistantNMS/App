import 'package:collection/collection.dart';
import 'package:redux/redux.dart';

import '../../../contracts/cart/cart_item.dart';
import '../../../contracts/redux/cart_state.dart';
import 'actions.dart';

final cartReducer = combineReducers<CartState>([
  TypedReducer<CartState, AddCraftingToCartAction>(_addCraftingToCart),
  TypedReducer<CartState, EditCraftingToCartAction>(_editCraftingItemInCart),
  TypedReducer<CartState, RemoveCraftingFromCartAction>(
      _removeCraftingFromCart),
  TypedReducer<CartState, RemoveAllCraftingFromCartAction>(
      _removeAllCraftingFromCart),
]);

CartState _addCraftingToCart(CartState state, AddCraftingToCartAction action) {
  bool addedNewItem = false;
  List<CartItem> newItems = List.empty(growable: true);
  for (int craftingIndex = 0;
      craftingIndex < state.craftingItems.length;
      craftingIndex++) {
    CartItem temp = state.craftingItems[craftingIndex];
    if (state.craftingItems[craftingIndex].id == action.item.id) {
      addedNewItem = true;
      temp.quantity = temp.quantity + action.quantity;
    }
    newItems.add(temp);
  }
  if (!addedNewItem) {
    newItems.add(
      CartItem(
        typeName: action.item.typeName,
        id: action.item.id,
        icon: action.item.icon,
        colour: action.item.colour,
        quantity: action.quantity,
        requiredItems: action.item.requiredItems,
      ),
    );
  }
  return state.copyWith(craftingItems: newItems);
}

CartState _editCraftingItemInCart(
    CartState state, EditCraftingToCartAction action) {
  List<CartItem> newItems = List.empty(growable: true);
  for (var craftingIndex = 0;
      craftingIndex < state.craftingItems.length;
      craftingIndex++) {
    var temp = state.craftingItems[craftingIndex];
    if (state.craftingItems[craftingIndex].id == action.itemId) {
      temp.quantity = action.quantity;
    }
    newItems.add(temp);
  }
  return state.copyWith(craftingItems: newItems);
}

CartState _removeCraftingFromCart(
    CartState state, RemoveCraftingFromCartAction action) {
  CartItem? oldCardItem =
      state.craftingItems.firstWhereOrNull((ci) => ci.id == action.id);
  if (oldCardItem == null) return state;

  return state.copyWith(
      craftingItems: List.from(state.craftingItems)..remove(oldCardItem));
}

CartState _removeAllCraftingFromCart(
    CartState state, RemoveAllCraftingFromCartAction action) {
  return state.copyWith(craftingItems: List.empty(growable: true));
}
