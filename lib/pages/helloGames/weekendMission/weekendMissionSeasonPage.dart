import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../../constants/AppImage.dart';
import '../../../contracts/weekendStagePageItem.dart';
import '../../../helpers/futureHelper.dart';
import 'weekendMissionDetail.dart';

class WeekendMissionSeasonPage extends StatelessWidget {
  final LocaleKey weekendMissionJson;
  final String season;
  final int level;
  final int maxLevel;
  final int minLevel;
  final void Function() navigateToWeekendMissionMenu;
  const WeekendMissionSeasonPage({
    Key? key,
    required this.weekendMissionJson,
    required this.season,
    required this.level,
    required this.minLevel,
    required this.maxLevel,
    required this.navigateToWeekendMissionMenu,
  }) : super(key: key);

  Future<ResultWithValue<WeekendStagePageItem>> getCurrentWeekendMissionData(
      BuildContext context) async {
    var weekendMissionResult = await getWeekendMissionSeasonData(
      context,
      weekendMissionJson,
      season,
      level,
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
          onPressed: navigateToWeekendMissionMenu,
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
                  ctx, weekendMissionJson, season, level),
          minLevel,
          maxLevel,
        ),
      ),
    );
  }
}
