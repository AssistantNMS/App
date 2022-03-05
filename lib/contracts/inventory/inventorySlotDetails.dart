import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../genericPageItem.dart';

class InventorySlotDetails {
  String typeName;
  String id;
  String icon;
  String name;

  InventorySlotDetails({this.typeName, this.id, this.icon, this.name});

  factory InventorySlotDetails.fromJson(Map<String, dynamic> json) =>
      InventorySlotDetails(
        typeName: readStringSafe(json, 'typeName'),
        id: readStringSafe(json, 'id'),
        icon: readStringSafe(json, 'icon'),
        name: readStringSafe(json, 'name'),
      );

  factory InventorySlotDetails.fromGenericPageItem(GenericPageItem generic) =>
      InventorySlotDetails(
        typeName: generic.typeName,
        id: generic.id,
        icon: generic.icon,
        name: generic.name,
      );

  Map<String, dynamic> toJson() => {
        'typeName': typeName,
        'id': id,
        'icon': icon,
        'name': name,
      };
}
