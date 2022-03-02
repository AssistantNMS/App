// To parse this JSON data, do
//
//     final stripeDonationViewModel = stripeDonationViewModelFromJson(jsonString);
//https://app.quicktype.io/

import 'dart:convert';

class CommunityLinkViewModel {
  String name;
  String subtitle;
  String externalUrl;
  String iconUrl;

  CommunityLinkViewModel({
    this.name,
    this.subtitle,
    this.externalUrl,
    this.iconUrl,
  });

  factory CommunityLinkViewModel.fromRawJson(String str) =>
      CommunityLinkViewModel.fromJson(json.decode(str));

  factory CommunityLinkViewModel.fromJson(Map<String, dynamic> json) =>
      CommunityLinkViewModel(
        name: json['name'],
        subtitle: json['subtitle'],
        externalUrl: json['externalUrl'],
        iconUrl: json['iconUrl'],
      );
}
