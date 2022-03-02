import 'package:after_layout/after_layout.dart';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart'
    hide UIConstants;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/dialogs/asyncInputDialog.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/titleDataPresenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/redux/appState.dart';
import '../../contracts/titleData.dart';
import '../../contracts/titleDataWithOwned.dart';
import '../../helpers/searchHelpers.dart';
import '../../integration/dependencyInjection.dart';
import '../../redux/modules/titles/titleViewModel.dart';

class TitlePage extends StatefulWidget {
  TitlePage() {
    getAnalytics().trackEvent(AnalyticsEvent.titlePage);
  }

  @override
  _TitlePageState createState() => _TitlePageState();
}

class _TitlePageState extends State<TitlePage> {
  List<String> selection;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TitleViewModel>(
        converter: (store) => TitleViewModel.fromStore(store),
        rebuildOnChange: false,
        builder: (_, viewModel) {
          return TitlePageView(
            viewModel,
            this.selection,
            (itemList) => this.setState(() {
              this.selection = itemList;
            }),
            key: Key(
                'Title-View-${viewModel.playerTitle}-${(this.selection ?? []).length}'),
          );
        });
  }
}

Future<void> setPlayerName(
    BuildContext context, TitleViewModel viewModel) async {
  var playerNameResult = await asyncInputDialog(
      context, getTranslations().fromKey(LocaleKey.playerName));
  if ((playerNameResult != null && playerNameResult.length > 0)) {
    Future.delayed(const Duration(milliseconds: 250), () {
      // TODO Really bad - I sorry
      viewModel.setPlayerName(playerNameResult);
      // viewModel.setPlayerName('');
    });
  }
}

class TitlePageView extends StatefulWidget {
  final TitleViewModel viewModel;
  final List<String> selection;
  final void Function(List<String>) setSelection;
  TitlePageView(this.viewModel, this.selection, this.setSelection, {Key key})
      : super(key: key);

  @override
  _TitlePageViewState createState() => _TitlePageViewState(
        this.viewModel,
        this.selection,
        this.setSelection,
      );
}

class _TitlePageViewState extends State<TitlePageView>
    with AfterLayoutMixin<TitlePageView> {
  final TitleViewModel viewModel;
  final List<String> selection;
  final void Function(List<String>) setSelection;

  bool isLoading = true;
  List<TitleDataWithOwned> titleDataWithOwned = List.empty(growable: true);

  _TitlePageViewState(
    this.viewModel,
    this.selection,
    this.setSelection,
  );

  @override
  void afterFirstLayout(BuildContext context) {
    if (this.viewModel == null) return;

    this.getFiltered(
      context,
      (selection ?? List.empty()),
      (viewModel.owned ?? List.empty()),
    );

    if (this.viewModel.playerTitle == null ||
        this.viewModel.playerTitle.length < 1) {
      setPlayerName(context, viewModel);
    }
  }

  void getFiltered(
      BuildContext context, List<String> selection, List<String> owned) async {
    ResultWithValue<List<TitleData>> allItems =
        await getTitleRepo().getAll(context);

    List<TitleDataWithOwned> allItemsWithOwned = List.empty(growable: true);
    if (allItems.hasFailed) {
      this.setState(() {
        this.isLoading = false;
      });
      return;
    }

    allItemsWithOwned = allItems.value
        .map(
          (item) => TitleDataWithOwned.fromTitle(
            item,
            owned.any((o) => o == item.id),
          ),
        )
        .toList();

    if (selection == null || selection.length < 1) {
      this.setState(() {
        this.isLoading = false;
        this.titleDataWithOwned = allItemsWithOwned;
      });
      return;
    }

    bool showOwned =
        selection.any((s) => s == getTranslations().fromKey(LocaleKey.owned));
    bool showNotOwned = selection
        .any((s) => s == getTranslations().fromKey(LocaleKey.notOwned));

    List<TitleDataWithOwned> newValue = List.empty(growable: true);
    for (TitleDataWithOwned item in allItemsWithOwned) {
      bool isOwned = viewModel.owned.any((o) => o == item.id);

      if (isOwned && showOwned)
        newValue.add(item);
      else if (!isOwned && showNotOwned) newValue.add(item);
    }

    this.setState(() {
      this.isLoading = false;
      this.titleDataWithOwned = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = getTranslations().fromKey(LocaleKey.titles);
    int ownedItems = (viewModel?.owned?.length ?? 0);
    String owned = ownedItems > 0 ? ownedItems.toString() : '...';
    String numTiles = this.titleDataWithOwned.length > 0
        ? this.titleDataWithOwned.length.toString()
        : '...';
    return basicGenericPageScaffold(
      context,
      title: '$title - $owned / $numTiles',
      actions: [
        ActionItem(
          icon: Icons.edit,
          onPressed: () => setPlayerName(context, viewModel),
          text: getTranslations().fromKey(LocaleKey.playerName),
        )
      ],
      body: this.isLoading
          ? getLoading().fullPageLoading(context)
          : SearchableList<TitleDataWithOwned>(
              () async => ResultWithValue(true, this.titleDataWithOwned, ''),
              listItemDisplayer: titleDataTilePresenter(viewModel),
              listItemSearch: searchTitle,
              key: Key('title-Search-List-${this.titleDataWithOwned.length}'),
              minListForSearch: 5,
            ),
    );
  }
}
