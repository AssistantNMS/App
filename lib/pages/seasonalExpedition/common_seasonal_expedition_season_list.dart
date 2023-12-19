import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/tilePresenters/seasonal_expedition_tile_presenter.dart';
import '../../constants/app_image.dart';
import '../../contracts/generated/expedition_view_model.dart';
import '../../contracts/seasonalExpedition/seasonal_expedition_season.dart';
import '../../helpers/column_helper.dart';
import '../../integration/dependency_injection.dart';
import '../../redux/modules/setting/is_patreon_view_model.dart';
import 'season_expedition_constants.dart';
import 'seasonal_expedition_phase_list_page.dart';
import 'unused_patch_images.dart';

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
  List<Widget Function(BuildContext)> listItems = List.empty(growable: true);
  Widget? headingExpWidget;

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

    headingExpWidget = Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12, left: 0),
      child: innerChild,
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
      (liCtx) => expeditionSeasonTile(
        liCtx,
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
      (liCtx) => expeditionSeasonTile(
        liCtx,
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
    (_) => Padding(
      padding: const EdgeInsets.all(16),
      child: Container(),
    ),
  );

  // return listWithScrollbar(
  //   shrinkWrap: true,
  //   itemCount: listItems.length,
  //   itemBuilder: (BuildContext context, int index) => listItems[index],
  //   scrollController: ScrollController(),
  // );

  List<Widget> children = List.empty(growable: true);
  if (headingExpWidget != null) {
    children.add(
      Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: headingExpWidget,
          ),
        ),
      ),
    );
  }
  children.add(
    ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        gridWithScrollbar(
          shrinkWrap: true,
          itemCount: listItems.length,
          itemBuilder: (BuildContext liCtx, int index) =>
              listItems[index](liCtx),
          gridViewColumnCalculator: getCommunityLinkColumnCount,
          scrollController: ScrollController(),
        ),
      ],
    ),
  );

  return ListView(
    children: children,
  );
}
