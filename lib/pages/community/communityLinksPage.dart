import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/communityLinkTilePresenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/generated/communityLinkViewModel.dart';
import '../../helpers/searchHelpers.dart';
import '../../integration/dependencyInjection.dart';

class CommunityLinksPage extends StatelessWidget {
  CommunityLinksPage({Key key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.communityLinkPage);
  }

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.communityLinks),
      body: SearchableList<CommunityLinkViewModel>(
        () => getCommunityApiService().getAllCommunityLinks(),
        listItemDisplayer: communityLinkTilePresenter,
        listItemSearch: searchCommunityLinks,
        minListForSearch: 20,
      ),
    );
  }
}
