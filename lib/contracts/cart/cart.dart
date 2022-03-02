import 'cartItem.dart';

class Cart {
  List<CartItem> cartItems;

  Cart() {
    this.cartItems = List.empty(growable: true);
  }
}
