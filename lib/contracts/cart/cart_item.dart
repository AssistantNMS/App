import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../required_item.dart';

class CartItem {
  String typeName;
  String id;
  String icon;
  String colour;
  int quantity;
  List<RequiredItem>? requiredItems;

  CartItem({
    required this.typeName,
    required this.id,
    required this.icon,
    required this.colour,
    required this.quantity,
    required this.requiredItems,
  });

  factory CartItem.fromJson(Map<String, dynamic>? json) => CartItem(
        typeName: readStringSafe(json, 'typeName'),
        id: readStringSafe(json, 'id'),
        icon: readStringSafe(json, 'icon'),
        colour: readStringSafe(json, 'colour'),
        quantity: readIntSafe(json, 'quantity'),
        requiredItems: readListSafe(
          json,
          'requiredItems',
          (x) => RequiredItem.fromJson(x),
        ),
      );

  Map<String, dynamic> toJson() => {
        'typeName': typeName,
        'id': id,
        'icon': icon,
        'colour': colour,
        'quantity': quantity,
        'requiredItems': requiredItems,
      };
}
