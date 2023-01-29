import '../../../contracts/redux/appState.dart';
import '../../../contracts/cart/cart_item.dart';

List<CartItem> getCartItems(AppState state) => state.cartState.craftingItems;
