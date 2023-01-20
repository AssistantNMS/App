import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../../constants/AppImage.dart';
import '../../../constants/NmsExternalUrls.dart';
import '../../../contracts/enum/community_mission_status.dart';
import '../../../contracts/helloGames/community_mission_tracked.dart';
import '../../../integration/dependencyInjection.dart';

class CommunityMissionExtraData extends StatelessWidget {
  final int missionId;
  final CommunityMissionStatus status;

  const CommunityMissionExtraData(
    this.missionId,
    this.status, {
    Key key,
  }) : super(key: key);

  Future<ResultWithValue<CommunityMissionExtraDataPageData>>
      getExtraCommunityMissionData(int localMissionId) async {
    ResultWithValue<List<CommunityMissionTracked>> apiResult =
        await getCommunityMissionProgressApiService()
            .getProgressByMission(localMissionId);
    if (apiResult.isSuccess == false ||
        apiResult.value == null ||
        apiResult.value.isEmpty) {
      return ResultWithValue<CommunityMissionExtraDataPageData>(
          false, null, '');
    }

    CommunityMissionExtraDataPageData data = CommunityMissionExtraDataPageData(
      startDateRecorded: apiResult.value.first.dateRecorded,
      endDateRecorded: apiResult.value.last.dateRecorded,
    );
    return ResultWithValue<CommunityMissionExtraDataPageData>(true, data, '');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getExtraCommunityMissionData(missionId),
      builder: (_ctx, _snap) => getBody(_ctx, status, _snap),
    );
  }
}

Widget getBody(
  BuildContext bodyContext,
  CommunityMissionStatus status,
  AsyncSnapshot<ResultWithValue<CommunityMissionExtraDataPageData>> snapshot,
) {
  bool showLoader = false;

  Widget Function() errorWidgetFunc;
  errorWidgetFunc = () => emptySpace1x();

  switch (snapshot.connectionState) {
    case ConnectionState.none:
      showLoader = true;
      break;
    case ConnectionState.done:
      if (snapshot.hasError) {
        return errorWidgetFunc();
      }
      break;
    default:
      showLoader = true;
      break;
  }

  List<Widget> widgets = List.empty(growable: true);

  if (status == CommunityMissionStatus.past) {
    widgets.add(emptySpace2x());
    widgets.add(flatCard(
      child: genericListTileWithSubtitle(
        bodyContext,
        leadingImage: AppImage.communityMissionProgress,
        name: 'Community Mission Progress Tracker', //TODO translate
        subtitle: const Text('Data below supplied by the NMSCD'),
        trailing: const Padding(
          padding: EdgeInsets.only(right: 8),
          child: Icon(Icons.open_in_new_rounded),
        ),
        onTap: () =>
            launchExternalURL(NmsExternalUrls.communityMissionProgress),
      ),
    ));
  }

  if (showLoader == false) {
    if (snapshot.data.value == null ||
        snapshot.data.value.startDateRecorded == null ||
        snapshot.data.value.endDateRecorded == null) {
      return errorWidgetFunc();
    }

    CommunityMissionExtraDataPageData pageData = snapshot.data.value;

    widgets.add(ListTile(
      title: Text(getTranslations().fromKey(LocaleKey.startDate)),
      subtitle: Text(_getDateTimeString(pageData.startDateRecorded)),
      onTap: () => launchExternalURL(NmsExternalUrls.communityMissionProgress),
    ));

    if (status == CommunityMissionStatus.past) {
      widgets.add(ListTile(
        title: Text(getTranslations().fromKey(LocaleKey.endDate)),
        subtitle: Text(_getDateTimeString(pageData.endDateRecorded)),
        onTap: () =>
            launchExternalURL(NmsExternalUrls.communityMissionProgress),
      ));
    }
  } else {
    widgets.add(getLoading().smallLoadingTile(bodyContext));
  }

  if (snapshot.data == null || snapshot.data.hasFailed) {
    return errorWidgetFunc();
  }

  return animateWidgetIn(
    child: Column(children: widgets),
  );
}

String _getDateTimeString(DateTime dateTimeObj) {
  DateTime utcDate = DateTime.utc(
    dateTimeObj.year,
    dateTimeObj.month,
    dateTimeObj.day,
    dateTimeObj.hour,
    dateTimeObj.minute,
    dateTimeObj.second,
  );
  final convertedDate = utcDate.toLocal();

  String result = '${convertedDate.year}-';
  result += padString(convertedDate.month.toString(), 2);
  result += '-';
  result += padString(convertedDate.day.toString(), 2);
  result += ' ';
  result += padString(convertedDate.hour.toString(), 2);
  result += ':';
  result += padString(convertedDate.minute.toString(), 2);

  // int utcOffsetMinutes = convertedDate.timeZoneOffset.inMinutes;
  // int utcOffsetHours = utcOffsetMinutes ~/ 60;
  // int utcOffsetMinutesLeft = utcOffsetMinutes - (utcOffsetHours * 60);
  // result += ' (';
  // result += padString(utcOffsetHours.toString(), 2);
  // result += ':';
  // result += padString(utcOffsetMinutesLeft.toString(), 2);
  // result += ')';

  result += ' (${convertedDate.timeZoneName})';
  return result;
}
