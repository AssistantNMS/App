import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/bait_tile_presenter.dart';
import '../../constants/analytics_event.dart';
import '../../contracts/fishing/good_guy_free_bait_view_model.dart';
import '../../integration/dependency_injection.dart';

class GoodGuysFreeBaitStatPage extends StatelessWidget {
  GoodGuysFreeBaitStatPage({super.key}) {
    getAnalytics().trackEvent(AnalyticsEvent.fishingGgfBaitPage);
  }

  @override
  Widget build(BuildContext context) {
    var currentLanguage = getTranslations().currentLanguage;
    return basicGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.fishingBait),
      body: SearchableList<GoodGuyFreeBaitViewModel>(
        () => getApiRepo().getGoodGuyFreeBait(currentLanguage),
        firstListItemWidget: ggfBaitAlertTilePresenter(context),
        keepFirstListItemWidgetVisible: true,
        listItemSearch: (GoodGuyFreeBaitViewModel bait, String searchText) =>
            (bait.name.toLowerCase().contains(searchText.toLowerCase())),
        listItemDisplayer: ggfBaitTilePresenter,
        hintText: getTranslations().fromKey(LocaleKey.searchItems),
      ),
    );
  }
}
