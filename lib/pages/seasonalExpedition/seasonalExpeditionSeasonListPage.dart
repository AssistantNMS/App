import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../contracts/seasonalExpedition/seasonalExpeditionSeason.dart';
import 'seasonExpeditionConstants.dart';

import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/seasonalExpeditionTilePresenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../constants/AppImage.dart';
import '../../contracts/generated/expeditionViewModel.dart';
import '../../contracts/redux/appState.dart';
import '../../integration/dependencyInjection.dart';
import '../../redux/modules/setting/isPatreonViewModel.dart';
import 'UnusedPatchImages.dart';
import 'seasonalExpeditionPhaseListPage.dart';

const double tileHeight = 175;
const double smallTileHeight = 150;

class SeasonalExpeditionSeasonListPage extends StatelessWidget {
  SeasonalExpeditionSeasonListPage({Key key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.seasonalExpeditionListPage);
  }

  Future<ResultWithValue<CurrentAndPastExpeditions>> currentAndPastExpeditions(
      BuildContext futureContext) async {
    Future<ResultWithValue<ExpeditionViewModel>> apiTask =
        getHelloGamesApiService().getExpeditionStatus();
    ResultWithValue<List<SeasonalExpeditionSeason>> allExpeditionsResult =
        await getSeasonalExpeditionRepo().getAll(futureContext);
    if (allExpeditionsResult.hasFailed) {
      return ResultWithValue(false, null, allExpeditionsResult.errorMessage);
    }

    CurrentAndPastExpeditions result = CurrentAndPastExpeditions(
      current: null,
      past: allExpeditionsResult.value,
    );

    ResultWithValue<ExpeditionViewModel> apiResult = await apiTask;
    if (apiResult.hasFailed) {
      return ResultWithValue(true, result, apiResult.errorMessage);
    }

    result.current = apiResult.value;
    return ResultWithValue(true, result, '');
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
              title: getTranslations()
                  .fromKey(LocaleKey.seasonalExpeditionSeasons),
              body: getBodyFromFuture(futureContext, viewModel, snapshot),
            );
          },
        );
      },
    );
  }

  Widget getBodyFromFuture(BuildContext context, IsPatreonViewModel vm,
      AsyncSnapshot<ResultWithValue<CurrentAndPastExpeditions>> snapshot) {
    List<Widget> listItems = List.empty(growable: true);

    Widget errorWidget = asyncSnapshotHandler(
      context,
      snapshot,
      loader: () => getLoading().fullPageLoading(context),
      isValidFunction: (ResultWithValue<CurrentAndPastExpeditions> expResult) {
        if (expResult.hasFailed) return false;
        if (expResult.value == null) return false;
        return true;
      },
    );
    if (errorWidget != null) return errorWidget;

    Widget innerChild = getLoading().customErrorWidget(context);
    if (snapshot.data.value.current != null) {
      ExpeditionViewModel current = snapshot.data.value.current;
      innerChild = expeditionInProgressPresenter(context, current);
    }

    listItems.add(
      Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 12, left: 0),
        child: innerChild,
      ),
    );

    int milliSinceEpoch = DateTime.now().millisecondsSinceEpoch;
    List<SeasonalExpeditionSeason> pastSeasons = snapshot.data.value.past
        .where(
          (seas) => seas.startDate.millisecondsSinceEpoch < milliSinceEpoch,
        )
        .toList();
    pastSeasons.sort((a, b) => (a.startDate.millisecondsSinceEpoch >
            b.startDate.millisecondsSinceEpoch)
        ? -1
        : 1);
    for (SeasonalExpeditionSeason jsonExp in pastSeasons) {
      String seasNum = jsonExp.id
          .replaceAll('seas-', '') //
          .replaceAll('-redux', '');
      String suffix = jsonExp.isRedux ? ' (Redux)' : '';
      bool isOld = jsonExp.endDate.millisecondsSinceEpoch < milliSinceEpoch;
      listItems.add(
        expeditionSeasonTile(
          context,
          getBackgroundForExpedition(jsonExp.id),
          tileHeight,
          getPatchForExpedition(jsonExp.id, jsonExp.icon),
          'Season $seasNum$suffix',
          jsonExp.title,
          isOld,
          () {
            getNavigation().navigateAsync(
              context,
              navigateTo: (_) => SeasonalExpeditionPhaseListPage(jsonExp.id),
            );
          },
        ),
      );
    }

    listItems.add(
      expeditionSeasonTile(
        context,
        AppImage.expeditionSeasonBackground1,
        smallTileHeight,
        AppImage.expeditionsUnusedPatches,
        getTranslations().fromKey(LocaleKey.viewUnusedMilestonePatches),
        '',
        false,
        () {
          getNavigation().navigateAsync(
            context,
            navigateTo: (_) => const UnusedPatchImagesPage(),
          );
        },
      ),
    );

    listItems
        .add(Padding(child: Container(), padding: const EdgeInsets.all(16)));

    return listWithScrollbar(
      shrinkWrap: true,
      itemCount: listItems.length,
      itemBuilder: (BuildContext context, int index) => listItems[index],
    );
  }
}
