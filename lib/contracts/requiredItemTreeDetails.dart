import 'requiredItem.dart';
import 'requiredItemDetails.dart';

class RequiredItemTreeDetails extends RequiredItem {
  String icon;
  String name;
  String colour;
  int cost;
  List<RequiredItemTreeDetails> children;

  RequiredItemTreeDetails({
    id,
    this.icon,
    this.name,
    this.colour,
    quantity,
    this.cost,
    this.children,
  }) {
    this.id = id;
    this.quantity = quantity;
  }

  factory RequiredItemTreeDetails.fromRequiredItemDetails(
      RequiredItemDetails req, int cost) {
    List<RequiredItemTreeDetails> children = List.empty(growable: true);
    return RequiredItemTreeDetails(
      id: req.id,
      colour: req.colour,
      icon: req.icon,
      name: req.name,
      quantity: req.quantity,
      cost: cost,
      children: children,
    );
  }

  // factory RequiredItemTreeDetails.fromGenericPageItem(
  //     GenericPageItem generic, int quantity) {
  //   return RequiredItemTreeDetails(
  //     id: generic.id,
  //     colour: generic.colour,
  //     icon: generic.icon,
  //     name: generic.name,
  //     quantity: quantity,
  //   );
  // }

  @override
  String toString() {
    return "${quantity}x $name";
  }
}
