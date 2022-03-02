import 'genericPageItem.dart';
import 'requiredItem.dart';
import 'requiredItemTreeDetails.dart';

class RequiredItemDetails extends RequiredItem {
  String icon;
  String name;
  String colour;

  RequiredItemDetails({id, this.icon, this.name, this.colour, quantity}) {
    this.id = id;
    this.quantity = quantity;
  }

  factory RequiredItemDetails.fromGenericPageItem(
      GenericPageItem generic, int quantity) {
    return RequiredItemDetails(
      id: generic.id,
      colour: generic.colour,
      icon: generic.icon,
      name: generic.name,
      quantity: quantity,
    );
  }

  factory RequiredItemDetails.toRequiredItemDetails(
      RequiredItemTreeDetails reqTree) {
    return RequiredItemDetails(
      id: reqTree.id,
      colour: reqTree.colour,
      icon: reqTree.icon,
      name: reqTree.name,
      quantity: reqTree.quantity,
    );
  }

  @override
  String toString() {
    return "${quantity}x $name";
  }
}
