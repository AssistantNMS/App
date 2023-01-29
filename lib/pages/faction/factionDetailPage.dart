import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/faction_tile_presenter.dart';
import '../../constants/nms_ui_constants.dart';
import '../../contracts/faction/faction.dart';
import '../../contracts/faction/stored_faction_mission.dart';
import '../../contracts/redux/app_state.dart';
import '../../redux/modules/journeyMilestone/factionsViewModel.dart';
import 'guildMissionsPage.dart';

class FactionDetailPage extends StatelessWidget {
  final FactionDetail factionDetail;
  const FactionDetailPage(this.factionDetail, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, FactionsViewModel>(
      converter: (store) => FactionsViewModel.fromStore(store),
      rebuildOnChange: false,
      builder: (BuildContext storeContext, FactionsViewModel viewModel) =>
          getBody(storeContext, viewModel),
    );
  }

  Widget getBody(BuildContext storeContext, FactionsViewModel viewModel) {
    List<Widget> widgets = List.empty(growable: true);
    widgets.add(LocalImage(
      imagePath: factionDetail.icon,
      imageHero: factionDetail.icon + factionDetail.id,
      height: 100,
    ));
    widgets.add(Padding(
      padding: NMSUIConstants.buttonPadding,
      child: GenericItemDescription(
        factionDetail.description,
        maxLines: 20,
      ),
    ));
    widgets.add(customDivider());

    for (FactionMission mission in factionDetail.missions) {
      int storedFacIndex = viewModel.storedFactions
          .indexWhere((fac) => fac.missionId == mission.id);
      bool isValidIndex = storedFacIndex > -1 &&
          storedFacIndex < viewModel.storedFactions.length;
      StoredFactionMission? reduxMdl =
          isValidIndex ? viewModel.storedFactions[storedFacIndex] : null;
      widgets.add(
        factionMissionTilePresenter(storeContext, mission, viewModel, reduxMdl),
      );
    }

    if (factionDetail.additional.contains('ShowGuildMissions')) {
      widgets.add(const EmptySpace1x());
      widgets.add(Padding(
        padding: NMSUIConstants.buttonPadding,
        child: PositiveButton(
          title: getTranslations().fromKey(LocaleKey.viewGuildMissions),
          onTap: () {
            getNavigation().navigateAwayFromHomeAsync(
              storeContext,
              navigateTo: (_) => GuildMissionsPage(),
            );
          },
        ),
      ));
    }

    widgets.add(const EmptySpace8x());

    return simpleGenericPageScaffold(
      storeContext,
      title: factionDetail.name,
      body: listWithScrollbar(
        itemCount: widgets.length,
        itemBuilder: (context, index) => widgets[index],
        scrollController: ScrollController(),
      ),
    );
  }
}
