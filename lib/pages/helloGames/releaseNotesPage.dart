import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/helloGamesTilePresenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/helloGames/releaseNote.dart';
import '../../helpers/searchHelpers.dart';
import '../../integration/dependencyInjection.dart';

class ReleaseNotesPage extends StatelessWidget {
  ReleaseNotesPage() {
    getAnalytics().trackEvent(AnalyticsEvent.releasesPage);
  }

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.releaseNotes),
      body: SearchableList<ReleaseNote>(
        () => getHelloGamesApiService().getReleases(),
        listItemDisplayer: releaseNoteTilePresenter,
        listItemSearch: searchReleaseNotes,
      ),
    );
  }
}
