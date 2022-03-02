import 'package:redux/redux.dart';

import '../../../contracts/cart/cartItem.dart';
import '../../../contracts/genericPageItem.dart';
import '../../../contracts/redux/appState.dart';
import '../setting/selector.dart';
import 'actions.dart';
import 'selector.dart';

class CartViewModel {
  List<CartItem> craftingItems;
  final bool displayGenericItemColour;

  Function addToCart;
  Function editCartItem;
  Function removeFromCart;
  Function removeAllFromCart;

  CartViewModel({
    this.craftingItems,
    this.displayGenericItemColour,
    this.addToCart,
    this.editCartItem,
    this.removeAllFromCart,
    this.removeFromCart,
  });

  static CartViewModel fromStore(Store<AppState> store) {
    return CartViewModel(
        craftingItems: getCartItems(store.state),
        displayGenericItemColour: getDisplayGenericItemColour(store.state),
        addToCart: (GenericPageItem item, int quantity) =>
            store.dispatch(AddCraftingToCartAction(item, quantity)),
        editCartItem: (String itemId, int quantity) =>
            store.dispatch(EditCraftingToCartAction(itemId, quantity)),
        removeFromCart: (String id) =>
            store.dispatch(RemoveCraftingFromCartAction(id)),
        removeAllFromCart: () =>
            store.dispatch(RemoveAllCraftingFromCartAction()));
  }
}
