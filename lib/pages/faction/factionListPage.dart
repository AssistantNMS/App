import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/factionTilePresenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/faction/faction.dart';
import '../../integration/dependencyInjection.dart';

class FactionPage extends StatelessWidget {
  FactionPage({Key key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.factionPage);
  }

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.factionPage),
      body: SearchableList<Faction>(
        () => getFactionRepo().getAll(context),
        listItemDisplayer: factionTilePresenter,
        listItemSearch: (Faction _, String __) => false,
        minListForSearch: 1000,
        addFabPadding: true,
      ),
    );
  }
}
