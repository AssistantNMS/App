import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/integration/dependencyInjection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../../components/tilePresenters/twitchTilePresenter.dart';
import '../../../constants/AnalyticsEvent.dart';
import '../../../contracts/redux/appState.dart';
import '../../../contracts/twitch/twitchCampaignData.dart';
import '../../../redux/modules/generic/genericItemViewModel.dart';

class TwitchCampaignPage extends StatelessWidget {
  TwitchCampaignPage({Key? key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.twitchCampaignPage);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GenericItemViewModel>(
      converter: (store) => GenericItemViewModel.fromStore(store),
      builder: (_, viewModel) {
        Widget Function(BuildContext, TwitchCampaignData,
                {void Function()? onTap}) listTilePresenter =
            twitchCampaignListTilePresenter(viewModel.displayGenericItemColour);
        return simpleGenericPageScaffold(
          context,
          title: getTranslations().fromKey(LocaleKey.twitchDrop),
          body: SearchableList<TwitchCampaignData>(
            () => getDataRepo().getTwitchDrops(context),
            listItemDisplayer: listTilePresenter,
            minListForSearch: 100,
            key: const Key('TwitchCampaignPage'),
          ),
        );
      },
    );
  }
}
