import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

enum HomepageType { allItemsList, custom, catalogue }

HomepageType getHomepageTypeFomrInt(int value) {
  if (value == null) return HomepageType.allItemsList;

  switch (value) {
    case 0:
      return HomepageType.allItemsList;
    case 1:
      return HomepageType.custom;
    case 2:
      return HomepageType.catalogue;
    default:
      return HomepageType.allItemsList;
  }
}

LocaleKey getLocaleFromHomepageType(HomepageType type) {
  if (type == null) return LocaleKey.unknown;

  switch (type) {
    case HomepageType.allItemsList:
      return LocaleKey.defaultHomepage;
    case HomepageType.custom:
      return LocaleKey.customHomepage;
    case HomepageType.catalogue:
      return LocaleKey.catalogue;
    default:
      return LocaleKey.unknown;
  }
}

int homepageTypeToInt(HomepageType type) {
  switch (type) {
    case HomepageType.allItemsList:
      return 0;
    case HomepageType.custom:
      return 1;
    case HomepageType.catalogue:
      return 2;
    default:
      return 0;
  }
}
