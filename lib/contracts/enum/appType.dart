import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

enum AppType {
  Unknown,
  Android,
  Ios,
  Discord,
  WebApp,
  Web,
}

final appTypeValues = EnumValues({
  "0": AppType.Unknown,
  "1": AppType.Android,
  "2": AppType.Ios,
  "3": AppType.Discord,
  "4": AppType.WebApp,
  "5": AppType.Web,
});
