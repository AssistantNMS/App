import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/constants/AppImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/modalBottomSheet/expedition_rewards_list_modal_bottom_sheet.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/seasonalExpeditionTilePresenter.dart';
import '../../components/tilePresenters/youtubersTilePresenter.dart';
import '../../contracts/redux/appState.dart';
import '../../contracts/seasonalExpedition/seasonalExpeditionPhase.dart';
import '../../contracts/seasonalExpedition/seasonalExpeditionSeason.dart';
import '../../integration/dependencyInjection.dart';
import '../../redux/modules/expedition/expeditionViewModel.dart';

class SeasonalExpeditionPhaseListPage extends StatelessWidget {
  final String seasonId;
  final bool isCustomExp;

  const SeasonalExpeditionPhaseListPage(
    this.seasonId, {
    Key? key,
    this.isCustomExp = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ResultWithValue<SeasonalExpeditionSeason>>(
      future: getSeasonalExpeditionRepo().getById(
        context,
        seasonId,
        isCustomExp,
      ),
      builder: (BuildContext futureContext, snapshot) =>
          StoreConnector<AppState, ExpeditionViewModel>(
        converter: (store) => ExpeditionViewModel.fromStore(store),
        rebuildOnChange: false,
        builder: (BuildContext storeContext, ExpeditionViewModel viewModel) =>
            getBody(storeContext, snapshot, viewModel),
      ),
    );
  }

  Widget getBody(
    BuildContext storeContext,
    AsyncSnapshot<ResultWithValue<SeasonalExpeditionSeason>> snapshot,
    ExpeditionViewModel viewModel,
  ) {
    Widget? errorWidget = asyncSnapshotHandler(
      storeContext,
      snapshot,
      isValidFunction: (ResultWithValue<SeasonalExpeditionSeason>? expResult) {
        if (expResult?.hasFailed ?? false) return false;
        if (expResult?.value == null) return false;
        return true;
      },
    );
    if (errorWidget != null) {
      return simpleGenericPageScaffold(
        storeContext,
        title: getTranslations().fromKey(LocaleKey.loading),
        body: errorWidget,
      );
    }

    List<Widget> widgets = List.empty(growable: true);

    SeasonalExpeditionSeason season = snapshot.data!.value;
    bool infoNotComplete = season.rewards.isEmpty;
    if (infoNotComplete) {
      const mesg =
          'This data is incomplete and we are working on getting accurate information!';

      widgets.add(Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 4, left: 4, right: 4, bottom: 8),
          child: Column(
            children: const [
              Icon(Icons.error, color: Colors.white),
              Text(mesg),
            ],
          ),
        ),
        color: Colors.red,
      ));
    }

    widgets.add(seasonalExpeditionDetailTilePresenter(
      storeContext,
      season,
      viewModel.useAltGlyphs,
    ));

    widgets.add(const EmptySpace1x());

    if (season.rewards.isNotEmpty) {
      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: PositiveButton(
          title: getTranslations().fromKey(LocaleKey.rewards),
          onTap: () => adaptiveBottomModalSheet(
            storeContext,
            hasRoundedCorners: true,
            builder: (_) => ExpeditionRewardsListModalBottomSheet(
              '',
              season.rewards,
            ),
          ),
        ),
      ));
    } else {
      widgets.add(customDivider());
    }

    if (season.gameModeType != 'Normal') {
      widgets.add(const EmptySpace1x());
      widgets.add(Card(
        child: ListTile(
          leading: LocalImage(
            imagePath: AppImage.base + 'special/${season.gameModeType}.png',
          ),
          title: Text(season.gameMode),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16),
      ));
      widgets.add(const EmptySpace1x());
    }

    if (season.captainSteveYoutubePlaylist != null &&
        season.captainSteveYoutubePlaylist!.length > 5) {
      widgets.add(const EmptySpace1x());
      String seasNum = seasonId
          .replaceAll('seas-', '') //
          .replaceAll('-redux', '');
      widgets.add(Card(
        child: captainSteveYoutubeVideoTile(
          storeContext,
          season.captainSteveYoutubePlaylist!,
          subtitle: getTranslations()
              .fromKey(LocaleKey.walkthroughPlaylistExpeditionsSeasonNum)
              .replaceAll('{0}', seasNum),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16),
      ));
      widgets.add(const EmptySpace1x());
    }

    List<SeasonalExpeditionPhase> phases = season.phases;
    for (SeasonalExpeditionPhase phase in phases) {
      widgets.add(seasonalExpeditionPhaseTilePresenter(
        storeContext,
        phase,
        viewModel,
      ));
    }

    widgets.add(const EmptySpace8x());

    return simpleGenericPageScaffold(
      storeContext,
      title: season.title,
      body: listWithScrollbar(
        itemCount: widgets.length,
        itemBuilder: (context, index) => widgets[index],
        scrollController: ScrollController(),
      ),
    );
  }
}
