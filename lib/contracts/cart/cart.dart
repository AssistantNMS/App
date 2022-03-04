import 'cartItem.dart';

class Cart {
  List<CartItem> cartItems;

  Cart() {
    cartItems = List.empty(growable: true);
  }
}
