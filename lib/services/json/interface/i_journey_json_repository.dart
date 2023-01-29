import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../../contracts/journey/journey_milestone.dart';

class IJourneyJsonRepository {
  Future<ResultWithValue<List<JourneyMilestone>>> getAllMilestones(
      BuildContext context) async {
    return ResultWithValue<List<JourneyMilestone>>(false, List.empty(), '');
  }
}
