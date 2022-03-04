import '../genericPageItem.dart';
import '../requiredItem.dart';

class CartItem {
  String typeName;
  String id;
  String icon;
  String colour;
  List<RequiredItem> requiredItems;
  int quantity;

  CartItem({GenericPageItem pageItem, int quantity}) {
    quantity = quantity;
    typeName = pageItem.typeName;
    id = pageItem.id;
    icon = pageItem.icon;
    colour = pageItem.colour;
    requiredItems = pageItem.requiredItems;
  }

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
      pageItem: GenericPageItem.fromJson(json["pageItem"]),
      quantity: json["quantity"] as int);

  Map<String, dynamic> toJson() => {
        'pageItem': GenericPageItem(
          typeName: typeName,
          id: id,
          icon: icon,
          colour: colour,
          requiredItems: requiredItems,
        ).toJson(),
        'quantity': quantity
      };
}
