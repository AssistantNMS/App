import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../genericPageItem.dart';

class InventorySlotDetails {
  String id;
  String icon;

  InventorySlotDetails({this.id, this.icon});

  factory InventorySlotDetails.fromJson(Map<String, dynamic> json) =>
      InventorySlotDetails(
        id: readStringSafe(json, 'id'),
        icon: readStringSafe(json, 'icon'),
      );

  factory InventorySlotDetails.fromGenericPageItem(GenericPageItem generic) =>
      InventorySlotDetails(
        id: generic.id,
        icon: generic.icon,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'icon': icon,
      };
}
