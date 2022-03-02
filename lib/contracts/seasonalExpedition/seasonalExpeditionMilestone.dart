import 'package:assistantapps_flutter_common/helpers/jsonHelper.dart';

import './seasonalExpeditionReward.dart';

class SeasonalExpeditionMilestone {
  SeasonalExpeditionMilestone({
    this.id,
    this.title,
    this.description,
    this.descriptionDone,
    this.icon,
    this.rewards,
  });

  String id;
  String title;
  String description;
  String descriptionDone;
  String icon;
  List<SeasonalExpeditionReward> rewards;

  factory SeasonalExpeditionMilestone.fromJson(Map<String, dynamic> json) =>
      SeasonalExpeditionMilestone(
        id: readStringSafe(json, 'Id'),
        title: readStringSafe(json, 'Title'),
        description: readStringSafe(json, 'Description'),
        descriptionDone: readStringSafe(json, 'DescriptionDone'),
        icon: readStringSafe(json, 'Icon'),
        rewards: readListSafe<SeasonalExpeditionReward>(
          json,
          'Rewards',
          (dynamic innerJson) => SeasonalExpeditionReward.fromJson(innerJson),
        ),
      );
}
