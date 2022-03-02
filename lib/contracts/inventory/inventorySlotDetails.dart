import '../genericPageItem.dart';

class InventorySlotDetails {
  String typeName;
  String id;
  String icon;
  String name;

  InventorySlotDetails({this.typeName, this.id, this.icon, this.name});

  factory InventorySlotDetails.fromJson(Map<String, dynamic> json) =>
      InventorySlotDetails(
        typeName: json["typeName"] as String,
        id: json["id"] as String,
        icon: json["icon"] as String,
        name: json["name"] as String,
      );

  factory InventorySlotDetails.fromGenericPageItem(GenericPageItem generic) =>
      InventorySlotDetails(
        typeName: generic.typeName,
        id: generic.id,
        icon: generic.icon,
        name: generic.name,
      );

  Map<String, dynamic> toJson() => {
        'typeName': this.typeName,
        'id': this.id,
        'icon': this.icon,
        'name': this.name,
      };
}
