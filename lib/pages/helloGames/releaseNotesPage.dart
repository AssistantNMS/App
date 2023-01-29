import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/hello_games_tile_presenter.dart';
import '../../constants/analytics_event.dart';
import '../../contracts/helloGames/release_note.dart';
import '../../helpers/searchHelpers.dart';
import '../../integration/dependencyInjection.dart';

class ReleaseNotesPage extends StatelessWidget {
  ReleaseNotesPage({Key? key}) : super(key: key) {
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
