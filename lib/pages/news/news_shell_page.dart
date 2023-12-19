import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/youtubers_tile_presenter.dart';
import '../../constants/app_image.dart';
import '../../contracts/redux/app_state.dart';
import '../../helpers/column_helper.dart';
import '../../redux/modules/setting/news_page_view_model.dart';

import '../../components/tilePresenters/hello_games_tile_presenter.dart';
import '../../contracts/helloGames/news_item.dart';
import '../../contracts/helloGames/release_note.dart';
import '../../helpers/search_helpers.dart';
import '../../integration/dependency_injection.dart';
import './steam_branches.dart';

class NewsShellPage extends StatelessWidget {
  final List<String> options = [
    AppImage.nmsWebsiteFavicon,
    AppImage.nmsWebsiteAtlas,
    AppImage.steamdbIcon,
    AppImage.steamNewsIcon,
  ];

  NewsShellPage({Key? key}) : super(key: key);

  getAppBarTitle(int selectionIndex) {
    switch (selectionIndex) {
      case 0:
        return getTranslations().fromKey(LocaleKey.news);
      case 1:
        return getTranslations().fromKey(LocaleKey.releaseNotes);
      case 2:
        return getTranslations().fromKey(LocaleKey.steamBranches);
      case 3:
        return getTranslations().fromKey(LocaleKey.steamNews);
      default:
        return getTranslations().fromKey(LocaleKey.news);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewsPageViewModel>(
      converter: (store) => NewsPageViewModel.fromStore(store),
      builder: (_, viewModel) => basicGenericPageScaffold(
        context,
        title: getAppBarTitle(viewModel.selectedNewsPage),
        actions: [
          ActionItem(
            icon: Icons.help_outline,
            onPressed: () => getDialog().showSimpleHelpDialog(
              context,
              getTranslations().fromKey(LocaleKey.nmsNews),
              getTranslations().fromKey(LocaleKey.nmsNewsExplanation),
            ),
          )
        ],
        body: getBody(context, viewModel),
      ),
    );
  }

  Widget getBody(BuildContext context, NewsPageViewModel viewModel) {
    Widget? initialColumnWidget;
    Widget columnWidget = Container();

    switch (viewModel.selectedNewsPage) {
      case 0:
        initialColumnWidget = nmsHomeTile(context);
        columnWidget = SearchableGrid<NewsItem>(
          () => getHelloGamesApiService().getNews(),
          gridItemDisplayer: newsItemTilePresenter,
          gridItemSearch: searchNews,
          gridViewColumnCalculator: getCommunityLinkColumnCount,
          addFabPadding: true,
        );
        break;
      case 1:
        initialColumnWidget = nmsHomeTile(context);
        columnWidget = SearchableGrid<ReleaseNote>(
          () => getHelloGamesApiService().getReleases(),
          gridItemDisplayer: releaseNoteTilePresenter,
          gridItemSearch: searchReleaseNotes,
          gridViewColumnCalculator: getCommunityLinkColumnCount,
          minListForSearch: 10000,
          addFabPadding: true,
        );
        break;
      case 2:
        columnWidget = const SteamBranchesPage();
        break;
      case 3:
        columnWidget = SearchableGrid<SteamNewsItemViewModel>(
          () => getAssistantAppsSteam().getSteamNews(AssistantAppType.nms),
          gridItemDisplayer:
              (BuildContext localContext, SteamNewsItemViewModel newsItem,
                      {void Function()? onTap}) =>
                  steamNewsItemTilePresenter(localContext, newsItem, 0),
          gridItemSearch: (_, __) => true,
          gridViewColumnCalculator: getCommunityLinkColumnCount,
          addFabPadding: true,
        );
        break;
    }
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: AdaptiveSegmentedControl(
            controlItems: options
                .map((item) => ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: ImageSegmentedControlOption(item),
                    ))
                .toList(),
            borderRadius: 0,
            padding: const EdgeInsets.only(bottom: 4),
            currentSelection: viewModel.selectedNewsPage,
            onSegmentChosen: viewModel.setSelectedNewsPage,
          ),
        ),
        if (initialColumnWidget != null) initialColumnWidget,
        Expanded(
          child: columnWidget,
        ),
      ],
    );
  }
}
