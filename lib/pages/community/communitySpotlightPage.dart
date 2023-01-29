import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/community_spotlight_tile_presenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/generated/communitySpotlightViewModel.dart';
import '../../integration/dependencyInjection.dart';

class CommunitySpotlightPage extends StatelessWidget {
  CommunitySpotlightPage({Key? key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.communitySpotlightPage);
  }

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.communitySpotlight),
      body: SearchableList<CommuntySpotlightViewModel>(
        () => getCommunityApiService().getAllCommunitySpotlights(),
        listItemDisplayer: communitySpotlightTilePresenter,
        listItemSearch: (_, __) => false,
        addFabPadding: true,
        minListForSearch: 10000,
      ),
    );
  }
}
