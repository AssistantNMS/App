import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class StoredFactionMission {
  StoredFactionMission({
    this.missionId,
    this.missionTierIndex,
  });

  String missionId;
  int missionTierIndex;

  factory StoredFactionMission.fromJson(Map<String, dynamic> json) =>
      StoredFactionMission(
        missionId: readStringSafe(json, 'missionId'),
        missionTierIndex: readIntSafe(json, 'missionTierIndex'),
      );

  Map<String, dynamic> toJson() => {
        'missionId': missionId,
        'missionTierIndex': missionTierIndex,
      };
}
