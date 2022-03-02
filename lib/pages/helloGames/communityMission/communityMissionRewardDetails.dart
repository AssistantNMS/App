import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../../components/common/prevAndNextPagination.dart';
import '../../../components/scaffoldTemplates/genericPageScaffold.dart';
import 'communityMissionRewards.dart';

class CommunityMissionRewardDetailsPage extends StatefulWidget {
  final int missionId;
  final int missionMin;
  final int missionMax;
  CommunityMissionRewardDetailsPage(
    this.missionId,
    this.missionMin,
    this.missionMax,
  );

  @override
  _CommunityMissionRewardDetailsWidget createState() =>
      _CommunityMissionRewardDetailsWidget(
        missionId,
        this.missionMin,
        this.missionMax,
      );
}

class _CommunityMissionRewardDetailsWidget extends State<StatefulWidget> {
  int missionId;
  final int missionMin;
  final int missionMax;
  _CommunityMissionRewardDetailsWidget(
    this.missionId,
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
    return prevAndNextPagination(
      context,
      content: ListView(
        children: [
          Padding(
            child: Text(
              this.missionId.toString(),
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            padding: EdgeInsets.only(top: 12),
          ),
          customDivider(),
          CommunityMissionRewards(this.missionId),
          emptySpace(16),
        ],
      ),
      currentPosition: (this.missionId - this.missionMin),
      maxPositionIndex: (this.missionMax - this.missionMin) + 1,
      nextLocaleKey: LocaleKey.nextCommunityMission,
      prevLocaleKey: LocaleKey.prevCommunityMission,
      onPreviousTap: () => this.setState(() {
        this.missionId = this.missionId - 1;
      }),
      onNextTap: () => this.setState(() {
        this.missionId = this.missionId + 1;
      }),
    );
  }
}
