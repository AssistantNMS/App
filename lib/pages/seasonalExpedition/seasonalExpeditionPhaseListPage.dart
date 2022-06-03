import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/modalBottomSheet/expeditionRewardsListModalBottomSheet.dart';
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
  final DateTime startDate;
  final DateTime endDate;
  const SeasonalExpeditionPhaseListPage(
    this.seasonId, {
    Key key,
    this.startDate,
    this.endDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSeasonalExpeditionRepo().getById(context, seasonId),
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
      ExpeditionViewModel viewModel) {
    Widget errorWidget = asyncSnapshotHandler(storeContext, snapshot);
    if (errorWidget != null) {
      return simpleGenericPageScaffold(
        storeContext,
        title: getTranslations().fromKey(LocaleKey.loading),
        body: errorWidget,
      );
    }

    SeasonalExpeditionSeason season = snapshot.data.value;
    if (startDate != null) season.startDate = startDate;
    if (endDate != null) season.endDate = endDate;

    List<Widget> widgets = List.empty(growable: true);

    bool infoNotComplete = (season?.rewards?.length ?? 0) < 1;
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

    if (season.rewards.isNotEmpty) {
      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: positiveButton(
          storeContext,
          title: getTranslations().fromKey(LocaleKey.rewards),
          onPress: () => adaptiveBottomModalSheet(
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
      widgets.add(emptySpace1x());
      widgets.add(customDivider());
    }
    if (season.captainSteveYoutubePlaylist != null &&
        season.captainSteveYoutubePlaylist.length > 5) {
      String seasNum =
          seasonId.replaceAll('seas-', '').replaceAll('-redux', '');
      widgets.add(Card(
        child: captainSteveYoutubeVideoTile(
          storeContext,
          season.captainSteveYoutubePlaylist,
          subtitle: getTranslations()
              .fromKey(LocaleKey.walkthroughPlaylistExpeditionsSeasonNum)
              .replaceAll('{0}', seasNum),
        ),
      ));
      widgets.add(emptySpace1x());
    }

    List<SeasonalExpeditionPhase> phases = snapshot.data.value.phases;
    for (SeasonalExpeditionPhase phase in phases) {
      widgets.add(seasonalExpeditionPhaseTilePresenter(
        storeContext,
        phase,
        viewModel,
      ));
    }

    widgets.add(emptySpace8x());

    return simpleGenericPageScaffold(
      storeContext,
      title: season.title,
      body: listWithScrollbar(
        itemCount: widgets.length,
        itemBuilder: (context, index) => widgets[index],
      ),
    );
  }
}
