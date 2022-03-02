// To parse this JSON data, do
//
//     final stripeDonationViewModel = stripeDonationViewModelFromJson(jsonString);
//https://app.quicktype.io/

import 'dart:convert';

class StripeDonationViewModel {
  double amount;
  String currency;
  String token;
  bool isGooglePay;

  StripeDonationViewModel({
    this.amount,
    this.currency,
    this.token,
    this.isGooglePay,
  });

  factory StripeDonationViewModel.fromRawJson(String str) =>
      StripeDonationViewModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StripeDonationViewModel.fromJson(Map<String, dynamic> json) =>
      StripeDonationViewModel(
        amount: json["Amount"].toDouble(),
        currency: json["Currency"],
        token: json["Token"],
        isGooglePay: json["IsGooglePay"],
      );

  Map<String, dynamic> toJson() => {
        "Amount": amount,
        "Currency": currency,
        "Token": token,
        "IsGooglePay": isGooglePay,
      };
}
