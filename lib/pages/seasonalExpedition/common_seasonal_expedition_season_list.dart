import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/tilePresenters/seasonal_expedition_tile_presenter.dart';
import '../../contracts/generated/expedition_view_model.dart';
import '../../contracts/seasonalExpedition/seasonal_expedition_season.dart';
import '../../integration/dependency_injection.dart';
import 'season_expedition_constants.dart';

const double tileHeight = 175;
const double smallTileHeight = 150;

Future<ResultWithValue<CurrentAndPastExpeditions>> currentAndPastExpeditions(
  BuildContext futureContext, {
  bool isCustom = false,
}) async {
  Future<ResultWithValue<ExpeditionViewModel>> apiTask = isCustom
      ? Future.value(ResultWithValue<ExpeditionViewModel>(
          false,
          ExpeditionViewModel.fromRawJson('{}'),
          '',
        ))
      : getHelloGamesApiService().getExpeditionStatus();
  ResultWithValue<List<SeasonalExpeditionSeason>> allExpeditionsResult =
      await getSeasonalExpeditionRepo().getAll(futureContext, isCustom);

  if (allExpeditionsResult.hasFailed) {
    return ResultWithValue<CurrentAndPastExpeditions>(
      false,
      CurrentAndPastExpeditions(),
      allExpeditionsResult.errorMessage,
    );
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

class CurrentExpeditionHeader extends StatelessWidget {
  const CurrentExpeditionHeader({Key? key}) : super(key: key);

  Widget wrapper(Widget innerChild) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 12, left: 0),
            child: innerChild,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return wrapper(
      CachedFutureBuilder(
        future: getHelloGamesApiService().getExpeditionStatus(),
        whileLoading: () => getLoading().smallLoadingTile(context),
        whenDoneLoading: (ResultWithValue<ExpeditionViewModel> futureResult) {
          if (futureResult.hasFailed) return const EmptySpace(0);

          Widget innerChild = expeditionInProgressPresenter(
            context,
            futureResult.value,
          );

          return innerChild;
        },
      ),
    );
  }
}
