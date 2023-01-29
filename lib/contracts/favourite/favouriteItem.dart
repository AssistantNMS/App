import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class FavouriteItem {
  String id;
  String? icon;

  FavouriteItem({
    required this.id,
    this.icon,
  });

  factory FavouriteItem.fromJson(Map<String, dynamic>? json) => FavouriteItem(
        id: readStringSafe(json, 'id'),
        icon: readStringSafe(json, 'icon'),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'icon': icon,
      };
}
