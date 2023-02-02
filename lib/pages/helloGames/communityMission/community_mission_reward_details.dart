// ignore_for_file: no_logic_in_create_state

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../../components/common/prev_and_next_pagination.dart';
import '../../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../../contracts/enum/community_mission_status.dart';
import 'community_mission_rewards.dart';

class CommunityMissionRewardDetailsPage extends StatefulWidget {
  final int missionId;
  final int liveMissionId;
  final int missionMin;
  final int missionMax;
  final bool hideProgressTrackerBanner;

  const CommunityMissionRewardDetailsPage(
    this.missionId,
    this.liveMissionId,
    this.missionMin,
    this.missionMax, {
    Key? key,
    this.hideProgressTrackerBanner = false,
  }) : super(key: key);

  @override
  createState() => _CommunityMissionRewardDetailsWidget(missionId);
}

class _CommunityMissionRewardDetailsWidget
    extends State<CommunityMissionRewardDetailsPage> {
  int missionId;

  _CommunityMissionRewardDetailsWidget(
    this.missionId,
  );

  @override
  Widget build(BuildContext context) {
    int diff = missionId - widget.liveMissionId;
    CommunityMissionStatus status = CommunityMissionStatus.current;
    if (diff >= 1) status = CommunityMissionStatus.future;
    if (diff <= -1) status = CommunityMissionStatus.past;

    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.communityMission),
      body: prevAndNextPagination(
        context,
        content: ListView(
          children: [
            Padding(
              child: Text(
                missionId.toString(),
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              padding: const EdgeInsets.only(top: 12),
            ),
            getBaseWidget().customDivider(),
            CommunityMissionRewards(missionId, status),
            const EmptySpace(16),
          ],
        ),
        currentPosition: (missionId - widget.missionMin),
        maxPositionIndex: (widget.missionMax - widget.missionMin) + 1,
        nextLocaleKey: LocaleKey.nextCommunityMission,
        prevLocaleKey: LocaleKey.prevCommunityMission,
        onPreviousTap: () => setState(() {
          missionId = missionId - 1;
        }),
        onNextTap: () => setState(() {
          missionId = missionId + 1;
        }),
      ),
    );
  }
}
