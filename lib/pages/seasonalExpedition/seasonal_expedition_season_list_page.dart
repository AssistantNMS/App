import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../constants/analytics_event.dart';
import '../../contracts/seasonalExpedition/seasonal_expedition_season.dart';
import '../../integration/dependency_injection.dart';
import 'seasonal_expedition_season_list_filtered_page.dart';

class SeasonalExpeditionSeasonListPage extends StatelessWidget {
  final isCustom = false;
  SeasonalExpeditionSeasonListPage({Key? key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.seasonalExpeditionListPage);
  }

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.seasonalExpeditionSeasons),
      body: CachedFutureBuilder(
        future: getSeasonalExpeditionRepo().getAll(context, isCustom),
        whileLoading: () => getLoading().fullPageLoading(context),
        whenDoneLoading: (
          ResultWithValue<List<SeasonalExpeditionSeason>> result,
        ) {
          return SeasonalExpeditionSeasonFilteredListPage(
            pastSeasonsResult: result,
            showCurrentExpeditionProgress: true,
            showUnusedPatches: true,
            isCustom: isCustom,
          );
        },
      ),
    );
  }
}
