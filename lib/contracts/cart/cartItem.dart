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
    this.quantity = quantity;
    this.typeName = pageItem.typeName;
    this.id = pageItem.id;
    this.icon = pageItem.icon;
    this.colour = pageItem.colour;
    this.requiredItems = pageItem.requiredItems;
  }

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
      pageItem: GenericPageItem.fromJson(json["pageItem"]),
      quantity: json["quantity"] as int);

  Map<String, dynamic> toJson() => {
        'pageItem': GenericPageItem(
          typeName: this.typeName,
          id: this.id,
          icon: this.icon,
          colour: this.colour,
          requiredItems: this.requiredItems,
        ).toJson(),
        'quantity': this.quantity
      };
}
