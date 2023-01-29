import 'package:redux/redux.dart';

import '../../../contracts/cart/cart_item.dart';
import '../../../contracts/favourite/favouriteItem.dart';
import '../../../contracts/inventory/inventory.dart';
import '../../../contracts/generic_page_item.dart';
import '../../../contracts/redux/appState.dart';
import '../cart/actions.dart';
import '../cart/selector.dart';
import '../favourite/actions.dart';
import '../favourite/selector.dart';
import '../inventory/selector.dart';
import '../setting/selector.dart';

class GenericPageViewModel {
  final bool genericTileIsCompact;
  final bool displayGenericItemColour;
  final List<CartItem> cartItems;
  final List<Inventory> containers;
  final List<FavouriteItem> favourites;
  final bool isPatron;
  final int platformIndex;
  final String selectedLanguage;

  Function(String itemId) removeFavourite;
  Function(FavouriteItem newItem) addFavourite;
  Function(GenericPageItem item, int quantity) addToCart;

  GenericPageViewModel({
    required this.genericTileIsCompact,
    required this.displayGenericItemColour,
    required this.cartItems,
    required this.containers,
    required this.favourites,
    required this.isPatron,
    required this.platformIndex,
    required this.selectedLanguage,
    //
    required this.addToCart,
    required this.addFavourite,
    required this.removeFavourite,
  });

  static GenericPageViewModel fromStore(Store<AppState> store) {
    return GenericPageViewModel(
      genericTileIsCompact: getGenericTileIsCompact(store.state),
      displayGenericItemColour: getDisplayGenericItemColour(store.state),
      cartItems: getCartItems(store.state),
      containers: getContainers(store.state),
      favourites: getFavourites(store.state),
      isPatron: getIsPatron(store.state),
      platformIndex: getLastPlatformIndex(store.state),
      selectedLanguage: getSelectedLanguage(store.state),
      //
      addFavourite: (FavouriteItem newItem) =>
          store.dispatch(AddFavouriteAction(newItem)),
      addToCart: (GenericPageItem item, int quantity) =>
          store.dispatch(AddCraftingToCartAction(item, quantity)),
      removeFavourite: (String itemId) =>
          store.dispatch(RemoveFavouriteAction(itemId)),
    );
  }
}
