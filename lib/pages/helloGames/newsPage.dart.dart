import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/hello_games_tile_presenter.dart';
import '../../constants/analytics_event.dart';
import '../../contracts/helloGames/news_item.dart';
import '../../helpers/searchHelpers.dart';
import '../../integration/dependencyInjection.dart';

class NewsPage extends StatelessWidget {
  NewsPage({Key? key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.newsPage);
  }
  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.news),
      body: SearchableList<NewsItem>(
        () => getHelloGamesApiService().getNews(),
        listItemDisplayer: newsItemTilePresenter,
        listItemSearch: searchNews,
      ),
    );
  }
}
