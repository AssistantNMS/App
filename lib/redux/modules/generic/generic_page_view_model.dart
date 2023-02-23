import 'package:redux/redux.dart';

import '../../../contracts/cart/cart_item.dart';
import '../../../contracts/generic_page_item.dart';
import '../../../contracts/inventory/inventory.dart';
import '../../../contracts/redux/app_state.dart';
import '../cart/actions.dart';
import '../cart/selector.dart';
import '../inventory/selector.dart';
import '../setting/selector.dart';

class GenericPageViewModel {
  final bool genericTileIsCompact;
  final bool displayGenericItemColour;
  final List<CartItem> cartItems;
  final List<Inventory> containers;
  final bool isPatron;
  final int platformIndex;
  final String selectedLanguage;

  Function(GenericPageItem item, int quantity) addToCart;

  GenericPageViewModel({
    required this.genericTileIsCompact,
    required this.displayGenericItemColour,
    required this.cartItems,
    required this.containers,
    required this.isPatron,
    required this.platformIndex,
    required this.selectedLanguage,
    //
    required this.addToCart,
  });

  static GenericPageViewModel fromStore(Store<AppState> store) {
    return GenericPageViewModel(
      genericTileIsCompact: getGenericTileIsCompact(store.state),
      displayGenericItemColour: getDisplayGenericItemColour(store.state),
      cartItems: getCartItems(store.state),
      containers: getContainers(store.state),
      isPatron: getIsPatron(store.state),
      platformIndex: getLastPlatformIndex(store.state),
      selectedLanguage: getSelectedLanguage(store.state),
      //
      addToCart: (GenericPageItem item, int quantity) =>
          store.dispatch(AddCraftingToCartAction(item, quantity)),
    );
  }
}
