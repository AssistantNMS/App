import 'genericPageItem.dart';
import 'requiredItem.dart';
import 'requiredItemTreeDetails.dart';

class RequiredItemDetails extends RequiredItem {
  String icon;
  String name;
  String? colour;

  RequiredItemDetails({
    required String id,
    required this.icon,
    required this.name,
    this.colour,
    int quantity = 0,
  }) : super(id: id, quantity: quantity);

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

  factory RequiredItemDetails.initial() => RequiredItemDetails(
        id: '',
        colour: '',
        icon: '',
        name: '',
        quantity: 0,
      );

  @override
  String toString() {
    return "${quantity}x $name";
  }
}
