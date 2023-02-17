// ignore_for_file: constant_identifier_names

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

enum CurrencyType {
  NONE,
  CREDITS,
  NANITES,
  QUICKSILVER,
  SALVAGEDDATA,
  FACTORYOVERRIDE,
}

final currencyTypeValues = EnumValues({
  "None": CurrencyType.NONE,
  "Credits": CurrencyType.CREDITS,
  "Nanites": CurrencyType.NANITES,
  "Quicksilver": CurrencyType.QUICKSILVER,
  "SalvagedData": CurrencyType.SALVAGEDDATA,
  "FactoryOverride": CurrencyType.FACTORYOVERRIDE,
});
