import 'cart_item.dart';

class Cart {
  late List<CartItem> cartItems;

  Cart() {
    cartItems = List.empty(growable: true);
  }
}
