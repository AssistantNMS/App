import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

enum InventoryOrderByType {
  name,
  icons,
}

LocaleKey getOrderByLocale(InventoryOrderByType type) {
  switch (type) {
    case InventoryOrderByType.name:
      return LocaleKey.name;
    case InventoryOrderByType.icons:
      return LocaleKey.icons;
    default:
      return LocaleKey.name;
  }
}

int inventoryOrderByTypeToInt(InventoryOrderByType type) {
  switch (type) {
    case InventoryOrderByType.name:
      return 0;
    case InventoryOrderByType.icons:
      return 1;
    default:
      return 0;
  }
}
