// ignore_for_file: no_logic_in_create_state

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../../components/common/prevAndNextPagination.dart';
import '../../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../../contracts/enum/community_mission_status.dart';
import 'communityMissionRewards.dart';

class CommunityMissionRewardDetailsPage extends StatefulWidget {
  final int missionId;
  final int liveMissionId;
  final int missionMin;
  final int missionMax;

  const CommunityMissionRewardDetailsPage(
    this.missionId,
    this.liveMissionId,
    this.missionMin,
    this.missionMax, {
    Key? key,
  }) : super(key: key);

  @override
  _CommunityMissionRewardDetailsWidget createState() =>
      _CommunityMissionRewardDetailsWidget(
        missionId,
        liveMissionId,
        missionMin,
        missionMax,
      );
}

class _CommunityMissionRewardDetailsWidget extends State<StatefulWidget> {
  int missionId;
  int liveMissionId;
  final int missionMin;
  final int missionMax;

  _CommunityMissionRewardDetailsWidget(
    this.missionId,
    this.liveMissionId,
    this.missionMin,
    this.missionMax,
  );

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.communityMission),
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    int diff = missionId - liveMissionId;
    CommunityMissionStatus status = CommunityMissionStatus.current;
    if (diff >= 1) status = CommunityMissionStatus.future;
    if (diff <= -1) status = CommunityMissionStatus.past;

    return prevAndNextPagination(
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
          customDivider(),
          CommunityMissionRewards(missionId, status),
          emptySpace(16),
        ],
      ),
      currentPosition: (missionId - missionMin),
      maxPositionIndex: (missionMax - missionMin) + 1,
      nextLocaleKey: LocaleKey.nextCommunityMission,
      prevLocaleKey: LocaleKey.prevCommunityMission,
      onPreviousTap: () => setState(() {
        missionId = missionId - 1;
      }),
      onNextTap: () => setState(() {
        missionId = missionId + 1;
      }),
    );
  }
}
