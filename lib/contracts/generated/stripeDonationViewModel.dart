// To parse this JSON data, do
//
//     final stripeDonationViewModel = stripeDonationViewModelFromJson(jsonString);
//https://app.quicktype.io/

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class StripeDonationViewModel {
  double amount;
  String currency;
  String token;
  bool isGooglePay;

  StripeDonationViewModel({
    required this.amount,
    required this.currency,
    required this.token,
    required this.isGooglePay,
  });

  factory StripeDonationViewModel.fromRawJson(String str) =>
      StripeDonationViewModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StripeDonationViewModel.fromJson(Map<String, dynamic>? json) =>
      StripeDonationViewModel(
        amount: readDoubleSafe(json, 'Amount'),
        currency: readStringSafe(json, 'Currency'),
        token: readStringSafe(json, 'Token'),
        isGooglePay: readBoolSafe(json, 'IsGooglePay'),
      );

  Map<String, dynamic> toJson() => {
        "Amount": amount,
        "Currency": currency,
        "Token": token,
        "IsGooglePay": isGooglePay,
      };
}
