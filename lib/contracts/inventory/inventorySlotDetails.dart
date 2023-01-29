import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../generic_page_item.dart';

class InventorySlotDetails {
  String? id;

  InventorySlotDetails({this.id});

  factory InventorySlotDetails.fromJson(Map<String, dynamic>? json) =>
      InventorySlotDetails(
        id: readStringSafe(json, 'id'),
      );

  factory InventorySlotDetails.fromGenericPageItem(GenericPageItem generic) =>
      InventorySlotDetails(
        id: generic.id,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
      };
}
