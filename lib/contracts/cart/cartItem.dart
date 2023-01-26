import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../genericPageItem.dart';
import '../requiredItem.dart';

class CartItem {
  late String typeName;
  late String id;
  late String icon;
  late String colour;
  List<RequiredItem>? requiredItems;
  int quantity;

  CartItem({
    required GenericPageItem pageItem,
    required this.quantity,
  }) {
    typeName = pageItem.typeName;
    id = pageItem.id;
    icon = pageItem.icon;
    colour = pageItem.colour;
    requiredItems = pageItem.requiredItems;
  }

  factory CartItem.fromJson(Map<String, dynamic>? json) => CartItem(
        pageItem: GenericPageItem.fromJson(json?["pageItem"]),
        quantity: readIntSafe(json, 'quantity'),
      );

  Map<String, dynamic> toJson() => {
        'typeName': typeName,
        'id': id,
        'icon': icon,
        'colour': colour,
        'requiredItems': requiredItems,
        'quantity': quantity
      };
}
