import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/youtubers_tile_presenter.dart';
import '../../constants/app_image.dart';
import '../../contracts/redux/app_state.dart';
import '../../redux/modules/setting/newsPageViewModel.dart';

import '../../components/tilePresenters/hello_games_tile_presenter.dart';
import '../../contracts/helloGames/news_item.dart';
import '../../contracts/helloGames/release_note.dart';
import '../../helpers/searchHelpers.dart';
import '../../integration/dependencyInjection.dart';
import './steamBranches.dart';

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
    Widget columnWidget = Container();

    switch (viewModel.selectedNewsPage) {
      case 0:
        columnWidget = SearchableList<NewsItem>(
          () => getHelloGamesApiService().getNews(),
          listItemDisplayer: newsItemTilePresenter,
          listItemSearch: searchNews,
          firstListItemWidget: nmsHomeTile(context),
          addFabPadding: true,
        );
        break;
      case 1:
        columnWidget = SearchableList<ReleaseNote>(
          () => getHelloGamesApiService().getReleases(),
          listItemDisplayer: releaseNoteTilePresenter,
          listItemSearch: searchReleaseNotes,
          firstListItemWidget: nmsHomeTile(context),
          minListForSearch: 10000,
          addFabPadding: true,
        );
        break;
      case 2:
        columnWidget = const SteamBranchesPage();
        break;
      case 3:
        columnWidget = SearchableList<SteamNewsItemViewModel>(
          () => getAssistantAppsSteam().getSteamNews(AssistantAppType.nms),
          listItemDisplayer:
              (BuildContext localContext, SteamNewsItemViewModel newsItem,
                      {void Function()? onTap}) =>
                  steamNewsItemTilePresenter(localContext, newsItem, 0),
          listItemSearch: (_, __) => true,
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
        Expanded(child: columnWidget),
      ],
    );
  }
}
