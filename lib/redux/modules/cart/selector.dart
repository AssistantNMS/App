import '../../../contracts/redux/appState.dart';
import '../../../contracts/cart/cartItem.dart';

List<CartItem> getCartItems(AppState state) => state.cartState.craftingItems;
