import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../../constants/AnalyticsEvent.dart';
import '../../../constants/AppImage.dart';
import '../../../constants/Routes.dart';
import '../../../contracts/generated/weekendMissionViewModel.dart';
import '../../../contracts/weekendStagePageItem.dart';
import '../../../helpers/futureHelper.dart';
import '../../../integration/dependencyInjection.dart';
import 'weekendMissionDetail.dart';

class WeekendMissionSeason3Page extends StatelessWidget {
  WeekendMissionSeason3Page({Key? key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.weekendMissionSeason3Page);
  }
  Future<ResultWithValue<WeekendStagePageItem>> getCurrentWeekendMissionData(
      BuildContext context) async {
    ResultWithValue<WeekendMissionViewModel> apiResult =
        await getHelloGamesApiService().getWeekendMission();
    if (!apiResult.isSuccess) {
      return ResultWithValue<WeekendStagePageItem>(
        false,
        WeekendStagePageItem.initial(),
        apiResult.errorMessage,
      );
    }

    ResultWithValue<WeekendStagePageItem> weekendMissionResult =
        await getWeekendMissionSeasonData(
      context,
      LocaleKey.weekendMissionSeason3Json,
      apiResult.value.seasonId,
      apiResult.value.level,
    );

    if (!weekendMissionResult.isSuccess) {
      return ResultWithValue<WeekendStagePageItem>(
        false,
        WeekendStagePageItem.initial(),
        'Something went wrong',
      );
    }

    WeekendStagePageItem weekendMissionValue = weekendMissionResult.value;
    weekendMissionValue.titles = weekendMissionResult.value.titles;
    weekendMissionValue.subtitles = weekendMissionResult.value.subtitles;
    weekendMissionValue.descriptions = weekendMissionResult.value.descriptions;

    weekendMissionValue.isConfirmedByAssistantNms =
        apiResult.value.isConfirmedByAssistantNms;
    weekendMissionValue.isConfirmedByCaptSteve =
        apiResult.value.isConfirmedByCaptSteve;
    weekendMissionValue.captainSteveVideoUrl =
        apiResult.value.captainSteveVideoUrl;

    return ResultWithValue<WeekendStagePageItem>(true, weekendMissionValue, '');
  }

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.weekendMission),
      actions: [
        ActionItem(
          icon: Icons.more,
          image: const ListTileImage(
            partialPath: AppImage.weekendMissionWhite,
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () => getNavigation().navigateAsync(
            context,
            navigateToNamed: Routes.helloGamesWeekendMissionMenu,
          ),
        ),
      ],
      body: CachedFutureBuilder<ResultWithValue<WeekendStagePageItem>>(
        future: getCurrentWeekendMissionData(context),
        whileLoading: () => getLoading().fullPageLoading(
          context,
          loadingText: getTranslations().fromKey(LocaleKey.loading),
        ),
        whenDoneLoading: (ResultWithValue<WeekendStagePageItem> result) =>
            WeekendMissionDetail(
          result.value,
          (BuildContext ctx, String season, int level) =>
              getWeekendMissionSeasonData(
                  ctx, LocaleKey.weekendMissionSeason2Json, season, level),
          46,
          66,
        ),
      ),
    );
  }
}
