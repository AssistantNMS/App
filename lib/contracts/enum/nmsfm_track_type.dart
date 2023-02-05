// ignore_for_file: constant_identifier_names

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

enum NmsfmTrackType {
  Unknown,
  Track,
  Jingle,
  Advert,
  RadioShow,
}

final nmsfmTrackTypeValues = EnumValues({
  '0': NmsfmTrackType.Unknown,
  '1': NmsfmTrackType.Track,
  '2': NmsfmTrackType.Jingle,
  '3': NmsfmTrackType.Advert,
  '4': NmsfmTrackType.RadioShow,
});
