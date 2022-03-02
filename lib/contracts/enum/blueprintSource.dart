import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

enum BlueprintSource {
  unknown,
  manufacturingFacility,
  manufacturingFacilityOrPolo
}

LocaleKey blueprintToLocalKey(BlueprintSource source) {
  if (source == BlueprintSource.manufacturingFacility) {
    return LocaleKey.manufacturingFacility;
  }
  if (source == BlueprintSource.manufacturingFacilityOrPolo) {
    return LocaleKey.manufacturingFacilityOrPolo;
  }

  return LocaleKey.unknown;
}
