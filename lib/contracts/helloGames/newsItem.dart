import 'dart:convert';

class NewsItem {
  String name;
  String description;
  String date;
  String image;
  String link;

  NewsItem({
    this.name,
    this.description,
    this.date,
    this.image,
    this.link,
  });

  factory NewsItem.fromRawJson(String str) =>
      NewsItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NewsItem.fromJson(Map<String, dynamic> json) => NewsItem(
        name: json["name"],
        description: json["description"],
        date: json["date"],
        image: json["image"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "date": date,
        "image": image,
        "link": link,
      };
}
