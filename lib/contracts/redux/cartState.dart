import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:meta/meta.dart';

import '../cart/cartItem.dart';

@immutable
class CartState {
  final List<CartItem> craftingItems;

  const CartState({
    required this.craftingItems,
  });

  factory CartState.initial() {
    return CartState(craftingItems: List.empty(growable: true));
  }

  CartState copyWith({
    List<CartItem>? craftingItems,
  }) {
    return CartState(
      craftingItems: craftingItems ?? this.craftingItems,
    );
  }

  factory CartState.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CartState.initial();
    try {
      return CartState(
        craftingItems: readListSafe<CartItem>(
          json,
          'craftingItems',
          (i) => CartItem.fromJson(i),
        ).toList(),
      );
    } catch (exception) {
      return CartState.initial();
    }
  }

  Map<String, dynamic> toJson() => {
        'craftingItems': craftingItems,
      };
}
