import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class StoredJourneyMilestone {
  StoredJourneyMilestone({
    this.journeyId,
    this.journeyStatIndex,
  });

  String journeyId;
  int journeyStatIndex;

  factory StoredJourneyMilestone.fromJson(Map<String, dynamic> json) =>
      StoredJourneyMilestone(
        journeyId: readStringSafe(json, 'journeyId'),
        journeyStatIndex: readIntSafe(json, 'journeyStatIndex'),
      );

  Map<String, dynamic> toJson() => {
        'journeyId': journeyId,
        'journeyStatIndex': journeyStatIndex,
      };
}
