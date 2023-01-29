import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../constants/analytics_event.dart';
import '../../contracts/redux/app_state.dart';
import '../../redux/modules/setting/isPatreonViewModel.dart';
import 'common_seasonal_expedition_season_list.dart';
import 'season_expedition_constants.dart';

class SeasonalExpeditionSeasonListPage extends StatelessWidget {
  SeasonalExpeditionSeasonListPage({Key? key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.seasonalExpeditionListPage);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, IsPatreonViewModel>(
      converter: (store) => IsPatreonViewModel.fromStore(store),
      builder: (_, viewModel) {
        return FutureBuilder(
          future: currentAndPastExpeditions(context),
          builder: (BuildContext futureContext,
              AsyncSnapshot<ResultWithValue<CurrentAndPastExpeditions>>
                  snapshot) {
            return simpleGenericPageScaffold(
              futureContext,
              title: getTranslations().fromKey(
                LocaleKey.seasonalExpeditionSeasons,
              ),
              body: getExpeditionBodyFromFuture(
                futureContext,
                viewModel,
                snapshot,
              ),
            );
          },
        );
      },
    );
  }
}
