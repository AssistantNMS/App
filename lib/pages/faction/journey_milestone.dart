import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/journey_tile_presenter.dart';
import '../../constants/analytics_event.dart';
import '../../contracts/journey/journey_milestone.dart';
import '../../contracts/redux/app_state.dart';
import '../../redux/modules/journeyMilestone/journey_milestone_view_model.dart';
import '../../services/json/JourneyJsonRepository.dart';

class JourneyMilestonePage extends StatelessWidget {
  JourneyMilestonePage({Key? key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.journeyMilestonesPage);
  }

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.journeyMilestone),
      body: StoreConnector<AppState, JourneyMilestoneViewModel>(
        converter: (store) => JourneyMilestoneViewModel.fromStore(store),
        builder: (_, viewModel) {
          ListItemDisplayerType<JourneyMilestone>
              localJourneyMilestoneTilePresenter =
              journeyMilestoneCurriedTilePresenter(viewModel);
          //
          return SearchableList<JourneyMilestone>(
            () => (JourneyJsonRepository()).getAllMilestones(context),
            listItemDisplayer: localJourneyMilestoneTilePresenter,
            listItemSearch: (JourneyMilestone _, String __) => false,
            minListForSearch: 100,
            addFabPadding: true,
            key: Key(
              joinStringList(
                [
                  ...viewModel.storedMilestones
                      .map((m) =>
                          (m.journeyId) + (m.journeyStatIndex.toString()))
                      .toList(),
                  'handle empty array', // Don't know why I need dis here
                ],
                ',',
              ),
            ),
          );
        },
      ),
    );
  }
}
