import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/integration/dependencyInjection.dart';
import 'package:assistantnms_app/pages/helloGames/misc/starshipScrapDisplay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../../constants/AnalyticsEvent.dart';
import '../../../contracts/data/starshipScrap.dart';
import '../../../contracts/redux/appState.dart';
import '../../../redux/modules/generic/genericItemViewModel.dart';

class StarshipScrapPage extends StatelessWidget {
  StarshipScrapPage({Key key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.starshipScrapPagePage);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GenericItemViewModel>(
      converter: (store) => GenericItemViewModel.fromStore(store),
      builder: (_, viewModel) {
        return simpleGenericPageScaffold(
          context,
          title: getTranslations().fromKey(LocaleKey.starshipScrap),
          body: FutureBuilder(
            future: getDataRepo().getStarshipScrapData(context),
            builder: (bodyCtx, asyncSnapshot) =>
                getBodyFromFuture(bodyCtx, asyncSnapshot, viewModel),
          ),
        );
      },
    );
  }

  Widget getBodyFromFuture(
    BuildContext bodyCtx,
    AsyncSnapshot<ResultWithValue<List<StarshipScrap>>> snapshot,
    GenericItemViewModel reduxViewModel,
  ) {
    Widget errorWidget = asyncSnapshotHandler(
      bodyCtx,
      snapshot,
      loader: () => getLoading().fullPageLoading(bodyCtx),
      isValidFunction: (ResultWithValue<List<StarshipScrap>> expResult) {
        if (expResult.hasFailed) return false;
        if (expResult.value == null) return false;
        return true;
      },
    );
    if (errorWidget != null) return errorWidget;

    return StarshipScrapDisplay(
      starScraps: snapshot.data.value,
      displayGenericItemColour: reduxViewModel.displayGenericItemColour,
    );
  }
}
