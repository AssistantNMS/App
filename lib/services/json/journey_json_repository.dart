import 'package:flutter/material.dart';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../contracts/journey/journey_milestone.dart';
import 'interface/i_journey_json_repository.dart';

class JourneyJsonRepository extends BaseJsonService
    implements IJourneyJsonRepository {
  @override
  Future<ResultWithValue<List<JourneyMilestone>>> getAllMilestones(
      BuildContext context) async {
    try {
      List responseJson = await getListFromJson(context,
          getTranslations().fromKey(LocaleKey.journeyMilestoneJson) + '.json');
      List<JourneyMilestone> dataItems =
          responseJson.map((m) => JourneyMilestone.fromJson(m)).toList();
      return ResultWithValue<List<JourneyMilestone>>(true, dataItems, '');
    } catch (exception) {
      getLog().e('JourneyJsonRepository getAllMilestones Exception');
      return ResultWithValue<List<JourneyMilestone>>(
          false, List.empty(), exception.toString());
    }
  }
}
