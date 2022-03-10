import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/common/cachedFutureBuilder.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/factionTilePresenter.dart';
import '../../contracts/faction/faction.dart';
import '../../contracts/faction/storedFactionMission.dart';
import '../../contracts/redux/appState.dart';
import '../../integration/dependencyInjection.dart';
import '../../redux/modules/journeyMilestone/factionsViewModel.dart';

class FactionDetailPage extends StatelessWidget {
  final String factionId;
  const FactionDetailPage(this.factionId, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedFutureBuilder(
      future: getFactionRepo().getById(context, factionId),
      whileLoading: getLoading().fullPageLoading(context),
      whenDoneLoading: (ResultWithValue<Faction> snapshot) =>
          StoreConnector<AppState, FactionsViewModel>(
        converter: (store) => FactionsViewModel.fromStore(store),
        rebuildOnChange: false,
        builder: (BuildContext storeContext, FactionsViewModel viewModel) =>
            getBody(storeContext, snapshot, viewModel),
      ),
    );
  }

  Widget getBody(BuildContext storeContext, ResultWithValue<Faction> snapshot,
      FactionsViewModel viewModel) {
    if (snapshot == null || snapshot.isSuccess == false) {
      return simpleGenericPageScaffold(
        storeContext,
        title: getTranslations().fromKey(LocaleKey.loading),
        body: getLoading().customErrorWidget(storeContext),
      );
    }
    Faction faction = snapshot.value;

    List<Widget> widgets = List.empty(growable: true);
    widgets.add(localImage(
      faction.icon,
      height: 100,
    ));
    widgets.add(genericItemDescription(faction.description));
    widgets.add(customDivider());

    for (FactionMission mission in faction.missions) {
      int storedFacIndex = viewModel.storedFactions
          .indexWhere((fac) => fac.missionId == mission.id);
      bool isValidIndex = storedFacIndex > -1 &&
          storedFacIndex < viewModel.storedFactions.length;
      StoredFactionMission reduxMdl =
          isValidIndex ? viewModel.storedFactions[storedFacIndex] : null;
      widgets.add(factionMissionTilePresenter(
          storeContext, mission, viewModel, reduxMdl));
    }

    widgets.add(emptySpace8x());

    return simpleGenericPageScaffold(
      storeContext,
      title: faction.name,
      body: listWithScrollbar(
        itemCount: widgets.length,
        itemBuilder: (context, index) => widgets[index],
      ),
    );
  }
}
