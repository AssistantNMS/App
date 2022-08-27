// ignore_for_file: constant_identifier_names

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

enum PortalAddressType {
  Code,
  Glyphs,
  GalacticCoords,
}

final portalAddressTypeValues = EnumValues({
  '0': PortalAddressType.Code,
  '1': PortalAddressType.Glyphs,
  '2': PortalAddressType.GalacticCoords,
});
