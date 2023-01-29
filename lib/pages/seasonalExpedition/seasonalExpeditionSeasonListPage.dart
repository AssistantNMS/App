import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/redux/appState.dart';
import '../../redux/modules/setting/isPatreonViewModel.dart';
import 'commonSeasonalExpeditionSeasonList.dart';
import 'seasonExpeditionConstants.dart';

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
