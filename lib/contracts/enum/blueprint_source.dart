import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

enum BlueprintSource {
  unknown,
  manufacturingFacility,
  manufacturingFacilityOrPolo
}

// final blueprintSourceTypeValues = EnumValues({
//   "unknown": BlueprintSource.unknown,
//   "manufacturingFacility": BlueprintSource.manufacturingFacility,
//   "manufacturingFacilityOrPolo": BlueprintSource.manufacturingFacilityOrPolo,
// });

LocaleKey blueprintToLocalKey(BlueprintSource source) {
  if (source == BlueprintSource.manufacturingFacility) {
    return LocaleKey.manufacturingFacility;
  }
  if (source == BlueprintSource.manufacturingFacilityOrPolo) {
    return LocaleKey.manufacturingFacilityOrPolo;
  }

  return LocaleKey.unknown;
}
