import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/components/tilePresenters/setting_tile_presenter.dart';
import 'package:assistantnms_app/contracts/seasonalExpedition/seasonal_expedition_title.dart';
import 'package:flutter/material.dart';

import '../../constants/app_image.dart';
import '../../contracts/seasonalExpedition/seasonal_expedition_season.dart';
import '../../helpers/column_helper.dart';
import 'common_seasonal_expedition_season_list.dart';
import 'season_expedition_constants.dart';
import 'seasonal_expedition_helpers.dart';
import 'seasonal_expedition_phase_list_page.dart';
import 'unused_patch_images.dart';

class SeasonalExpeditionSeasonFilteredListPage extends StatefulWidget {
  final ResultWithValue<List<SeasonalExpeditionSeason>> pastSeasonsResult;
  final bool showUnusedPatches;
  final bool showCurrentExpeditionProgress;
  final bool isCustom;
  const SeasonalExpeditionSeasonFilteredListPage({
    Key? key,
    required this.pastSeasonsResult,
    this.showCurrentExpeditionProgress = false,
    this.showUnusedPatches = false,
    this.isCustom = false,
  }) : super(key: key);

  @override
  createState() => _SeasonalExpeditionSeasonFilteredListPageState();
}

class _SeasonalExpeditionSeasonFilteredListPageState
    extends State<SeasonalExpeditionSeasonFilteredListPage> {
  bool showRedux = true;

  @override
  Widget build(BuildContext context) {
    if (widget.pastSeasonsResult.hasFailed) {
      return ListView(
        children: [getLoading().customErrorWidget(context)],
      );
    }
    List<Widget Function(BuildContext)> listItems = List.empty(growable: true);

    listItems.add(
      (p0) => boolSettingTilePresenter(
        context,
        getTranslations().fromKey(LocaleKey.showReduxExpeditions),
        showRedux,
        onChange: () => setState(() {
          showRedux = !showRedux;
        }),
      ),
    );

    List<SeasonalExpeditionSeason> pastSeasons =
        widget.pastSeasonsResult.value.toList();
    pastSeasons.sort((a, b) => (a.startDate.millisecondsSinceEpoch >
            b.startDate.millisecondsSinceEpoch)
        ? -1
        : 1);
    for (SeasonalExpeditionSeason jsonExp in pastSeasons) {
      if (jsonExp.isRedux && showRedux == false) continue;

      SeasonalExpeditionSeasonTitle detailsFromId =
          detailsFromExpeditionId(jsonExp);
      listItems.add(
        (liCtx) => expeditionSeasonTile(
          liCtx,
          detailsFromId.icon,
          tileHeight,
          // getPatchForExpedition(jsonExp.id, jsonExp.icon),
          jsonExp.icon,
          'Season ${detailsFromId.id}${detailsFromId.reduxSuffix}',
          jsonExp.title,
          () {
            getNavigation().navigateAsync(
              context,
              navigateTo: (_) => SeasonalExpeditionPhaseListPage(
                jsonExp.id,
                isCustomExp: widget.isCustom,
              ),
            );
          },
        ),
      );
    }

    if (widget.showUnusedPatches == true) {
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

    List<Widget> children = List.empty(growable: true);

    if (widget.showCurrentExpeditionProgress == true) {
      children.add(const CurrentExpeditionHeader());
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
}
