import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/modalBottomSheet/expeditionRewardsListModalBottomSheet.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/seasonalExpeditionTilePresenter.dart';
import '../../contracts/redux/appState.dart';
import '../../contracts/seasonalExpedition/seasonalExpeditionMilestone.dart';
import '../../contracts/seasonalExpedition/seasonalExpeditionPhase.dart';
import '../../redux/modules/expedition/expeditionViewModel.dart';

class SeasonalExpeditionDetailPage extends StatelessWidget {
  final SeasonalExpeditionPhase seasonalExpeditionPhase;
  const SeasonalExpeditionDetailPage(this.seasonalExpeditionPhase, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: seasonalExpeditionPhase.title,
      body: StoreConnector<AppState, ExpeditionViewModel>(
        converter: (store) => ExpeditionViewModel.fromStore(store),
        builder: (BuildContext storeContext, ExpeditionViewModel viewModel) =>
            getBody(context, seasonalExpeditionPhase, viewModel),
      ),
    );
  }

  Widget getBody(
      BuildContext scaffoldContext,
      SeasonalExpeditionPhase seasonalExpeditionPhase,
      ExpeditionViewModel viewModel) {
    List<Widget> widgets = List.empty(growable: true);

    for (SeasonalExpeditionMilestone milestone
        in seasonalExpeditionPhase.milestones) {
      widgets.add(seasonalExpeditionPhaseMilestoneTilePresenter(
        scaffoldContext,
        milestone,
        viewModel,
      ));
    }
    widgets.add(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: positiveButton(
        scaffoldContext,
        title: getTranslations().fromKey(LocaleKey.rewards),
        onPress: () => adaptiveBottomModalSheet(
          scaffoldContext,
          hasRoundedCorners: true,
          builder: (_) => ExpeditionRewardsListModalBottomSheet(
            '',
            seasonalExpeditionPhase.rewards,
          ),
        ),
      ),
    ));
    widgets.add(emptySpace8x());

    return Column(
      children: [
        Expanded(
          child: listWithScrollbar(
            itemCount: widgets.length,
            itemBuilder: (context, index) => widgets[index],
          ),
        ),
      ],
    );
  }
}
