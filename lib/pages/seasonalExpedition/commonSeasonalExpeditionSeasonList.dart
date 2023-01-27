import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../contracts/seasonalExpedition/seasonalExpeditionSeason.dart';
import 'seasonExpeditionConstants.dart';

import '../../components/tilePresenters/seasonalExpeditionTilePresenter.dart';
import '../../constants/AppImage.dart';
import '../../contracts/generated/expeditionViewModel.dart';
import '../../integration/dependencyInjection.dart';
import '../../redux/modules/setting/isPatreonViewModel.dart';
import 'UnusedPatchImages.dart';
import 'seasonalExpeditionPhaseListPage.dart';

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

Widget getExpeditionBodyFromFuture(
  BuildContext context,
  IsPatreonViewModel vm,
  AsyncSnapshot<ResultWithValue<CurrentAndPastExpeditions>> snapshot, {
  bool isCustom = false,
}) {
  List<Widget> listItems = List.empty(growable: true);

  Widget? errorWidget = asyncSnapshotHandler(
    context,
    snapshot,
    loader: () => getLoading().fullPageLoading(context),
    isValidFunction: (ResultWithValue<CurrentAndPastExpeditions>? expResult) {
      if (expResult?.hasFailed ?? false) return false;
      if (expResult?.value == null) return false;
      return true;
    },
  );
  if (errorWidget != null) return errorWidget;

  if (snapshot.data!.value.current != null) {
    ExpeditionViewModel? current = snapshot.data?.value.current;
    Widget innerChild = expeditionInProgressPresenter(context, current!);

    listItems.add(
      Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 12, left: 0),
        child: innerChild,
      ),
    );
  }

  List<SeasonalExpeditionSeason> pastSeasons =
      snapshot.data!.value.past ?? List.empty();
  pastSeasons.sort((a, b) =>
      (a.startDate.millisecondsSinceEpoch > b.startDate.millisecondsSinceEpoch)
          ? -1
          : 1);
  for (SeasonalExpeditionSeason jsonExp in pastSeasons) {
    String seasNum = jsonExp.id
        .replaceAll('seas-', '') //
        .replaceAll('-redux', '');
    String suffix = jsonExp.isRedux ? ' (Redux)' : '';
    listItems.add(
      expeditionSeasonTile(
        context,
        getBackgroundForExpedition(jsonExp.id),
        tileHeight,
        // getPatchForExpedition(jsonExp.id, jsonExp.icon),
        jsonExp.icon,
        'Season $seasNum$suffix',
        jsonExp.title,
        () {
          getNavigation().navigateAsync(
            context,
            navigateTo: (_) => SeasonalExpeditionPhaseListPage(
              jsonExp.id,
              isCustomExp: isCustom,
            ),
          );
        },
      ),
    );
  }

  if (isCustom == false) {
    listItems.add(
      expeditionSeasonTile(
        context,
        AppImage.expeditionSeasonBackgroundBackup,
        smallTileHeight,
        AppImage.expeditionsUnusedPatches,
        '',
        getTranslations().fromKey(LocaleKey.viewUnusedMilestonePatches),
        () {
          getNavigation().navigateAsync(
            context,
            navigateTo: (_) => const UnusedPatchImagesPage(),
          );
        },
      ),
    );
  }

  listItems.add(
    Padding(
      child: Container(),
      padding: const EdgeInsets.all(16),
    ),
  );

  return listWithScrollbar(
    shrinkWrap: true,
    itemCount: listItems.length,
    itemBuilder: (BuildContext context, int index) => listItems[index],
    scrollController: ScrollController(),
  );
}
