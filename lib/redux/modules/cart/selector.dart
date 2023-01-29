import '../../../contracts/redux/app_state.dart';
import '../../../contracts/cart/cart_item.dart';

List<CartItem> getCartItems(AppState state) => state.cartState.craftingItems;
