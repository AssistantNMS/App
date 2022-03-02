class FavouriteItem {
  String id;
  String icon;

  FavouriteItem({
    this.id,
    this.icon,
  });

  factory FavouriteItem.fromJson(Map<String, dynamic> json) => FavouriteItem(
        id: json["id"] as String,
        icon: json["icon"] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'icon': this.icon,
      };
}
