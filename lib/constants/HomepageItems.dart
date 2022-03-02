import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../contracts/enum/homepageType.dart';
import 'Routes.dart';

class HomepageItem {
  LocaleKey localeKey;
  HomepageType homepageType;
  String routeToNamed;
  HomepageItem(this.localeKey, this.homepageType, this.routeToNamed);

  static HomepageItem defaultHomepageItem() => HomepageItem(
        LocaleKey.defaultHomepage,
        HomepageType.allItemsList,
        Routes.home,
      );

  static HomepageItem getByType(HomepageType homepageType) {
    try {
      for (HomepageItem item in homepageItems) {
        if (item.homepageType == homepageType) {
          return item;
        }
      }
      return HomepageItem.defaultHomepageItem();
    } catch (ex) {}
    return HomepageItem.defaultHomepageItem();
  }
}

List<HomepageItem> homepageItems = [
  HomepageItem.defaultHomepageItem(),
  HomepageItem(
    LocaleKey.customHomepage,
    HomepageType.custom,
    Routes.customHome,
  ),
  HomepageItem(
    LocaleKey.catalogue,
    HomepageType.catalogue,
    Routes.catalogueHome,
  ),
];
