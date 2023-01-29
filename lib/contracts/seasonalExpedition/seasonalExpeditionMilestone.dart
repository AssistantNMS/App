import 'package:assistantapps_flutter_common/helpers/jsonHelper.dart';

import './seasonalExpeditionReward.dart';
import 'expeditionMilestoneType.dart';

class SeasonalExpeditionMilestone {
  SeasonalExpeditionMilestone({
    required this.id,
    required this.title,
    required this.description,
    required this.descriptionDone,
    required this.icon,
    required this.type,
    required this.encryption,
    required this.rewards,
  });

  String id;
  String title;
  String? description;
  String? descriptionDone;
  String icon;
  SeasonalExpeditionMilestoneType type;
  SeasonalExpeditionMilestoneEncryption encryption;
  List<SeasonalExpeditionReward> rewards;

  factory SeasonalExpeditionMilestone.fromJson(Map<String, dynamic>? json) =>
      SeasonalExpeditionMilestone(
        id: readStringSafe(json, 'Id'),
        title: readStringSafe(json, 'Title'),
        description: readStringSafe(json, 'Description'),
        descriptionDone: readStringSafe(json, 'DescriptionDone'),
        icon: readStringSafe(json, 'Icon'),
        type: seasonalExpeditionMilestoneTypeValues
            .map[readStringSafe(json, 'Type')]!,
        encryption: SeasonalExpeditionMilestoneEncryption.fromJson(
          json?['Encryption'],
        ),
        rewards: readListSafe<SeasonalExpeditionReward>(
          json,
          'Rewards',
          (dynamic innerJson) => SeasonalExpeditionReward.fromJson(innerJson),
        ),
      );
}

class SeasonalExpeditionMilestoneEncryption {
  SeasonalExpeditionMilestoneEncryption({
    required this.title,
    required this.description,
    required this.icon,
  });

  String title;
  String description;
  String icon;

  factory SeasonalExpeditionMilestoneEncryption.fromJson(
          Map<String, dynamic>? json) =>
      SeasonalExpeditionMilestoneEncryption(
        title: readStringSafe(json, 'Title'),
        description: readStringSafe(json, 'Description'),
        icon: readStringSafe(json, 'Icon'),
      );
}
