import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/integration/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../../components/tilePresenters/twitch_tile_presenter.dart';
import '../../../constants/analytics_event.dart';
import '../../../contracts/redux/app_state.dart';
import '../../../contracts/twitch/twitch_campaign_data.dart';
import '../../../redux/modules/generic/generic_item_view_model.dart';

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
