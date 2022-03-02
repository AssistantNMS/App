import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

enum OrderByOptionType {
  name,
  unitPrice,
  nanitePrice,
  quicksilverPrice,
}

LocaleKey getOrderByLocale(OrderByOptionType type) {
  switch (type) {
    case OrderByOptionType.name:
      return LocaleKey.name;
    case OrderByOptionType.unitPrice:
      return LocaleKey.unitPrice;
    case OrderByOptionType.nanitePrice:
      return LocaleKey.nanitePrice;
    case OrderByOptionType.quicksilverPrice:
      return LocaleKey.quicksilverPrice;
    default:
      return LocaleKey.name;
  }
}
