// ignore_for_file: no_logic_in_create_state

import 'package:after_layout/after_layout.dart';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart'
    hide UIConstants;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/tilePresenters/titleDataPresenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/redux/appState.dart';
import '../../contracts/titleData.dart';
import '../../contracts/titleDataWithOwned.dart';
import '../../helpers/searchHelpers.dart';
import '../../integration/dependencyInjection.dart';
import '../../redux/modules/titles/titleViewModel.dart';

class TitlePage extends StatefulWidget {
  TitlePage({Key? key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.titlePage);
  }

  @override
  _TitlePageState createState() => _TitlePageState();
}

class _TitlePageState extends State<TitlePage> {
  List<String> selection = List.empty();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TitleViewModel>(
      converter: (store) => TitleViewModel.fromStore(store),
      rebuildOnChange: false,
      builder: (_, viewModel) {
        String extraKey = '';
        if (viewModel.hideCompleted) {
          extraKey = viewModel.owned.length.toString();
        }
        return TitlePageView(
          viewModel,
          selection,
          (itemList) => setState(() {
            selection = itemList;
          }),
          key: Key(
              'Title-View-${viewModel.playerTitle}-${selection.length}-$extraKey'),
        );
      },
    );
  }
}

Future<void> setPlayerName(
  BuildContext context,
  TitleViewModel viewModel,
) async {
  String playerNameResult = await getDialog().asyncInputDialog(
    context,
    getTranslations().fromKey(LocaleKey.playerName),
    defaultText: viewModel.playerTitle ?? '',
  );
  if ((playerNameResult.isNotEmpty)) {
    Future.delayed(const Duration(milliseconds: 250), () {
      // Really bad - I sorry
      viewModel.setPlayerName(playerNameResult);
    });
  }
}

class TitlePageView extends StatefulWidget {
  final TitleViewModel viewModel;
  final List<String> selection;
  final void Function(List<String>) setSelection;
  const TitlePageView(this.viewModel, this.selection, this.setSelection,
      {Key? key})
      : super(key: key);

  @override
  _TitlePageViewState createState() => _TitlePageViewState(
        viewModel,
        selection,
        setSelection,
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
    getFiltered(
      context,
      selection,
      viewModel.owned,
      viewModel.hideCompleted,
    );

    if (viewModel.playerTitle == null || viewModel.playerTitle!.isEmpty) {
      setPlayerName(context, viewModel);
    }
  }

  void getFiltered(
    BuildContext context,
    List<String> selection,
    List<String> owned,
    bool hideCompleted,
  ) async {
    ResultWithValue<List<TitleData>> allItems =
        await getTitleRepo().getAll(context);

    List<TitleDataWithOwned> allItemsWithOwned = List.empty(growable: true);
    if (allItems.hasFailed) {
      setState(() {
        isLoading = false;
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

    if (selection.isEmpty) {
      setState(() {
        isLoading = false;
        titleDataWithOwned = allItemsWithOwned;
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

      if (isOwned && showOwned) {
        newValue.add(item);
      } else if (!isOwned && showNotOwned) {
        newValue.add(item);
      }
    }

    setState(() {
      isLoading = false;
      titleDataWithOwned = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = getTranslations().fromKey(LocaleKey.titles);
    int ownedItems = viewModel.owned.length;
    String owned = ownedItems > 0 ? ownedItems.toString() : '...';
    String numTiles = titleDataWithOwned.isNotEmpty
        ? titleDataWithOwned.length.toString()
        : '...';
    List<TitleDataWithOwned> filtered = titleDataWithOwned
        .where(
          (item) => (viewModel.hideCompleted == false || item.isOwned == false),
        )
        .toList();

    return Scaffold(
      appBar: getBaseWidget().appBarForSubPage(
        context,
        title: Text('$title - $owned / $numTiles'),
        actions: [
          ActionItem(
            icon: Icons.edit,
            onPressed: () => setPlayerName(context, viewModel),
            text: getTranslations().fromKey(LocaleKey.playerName),
          ),
          ActionItem(
            icon: viewModel.hideCompleted
                ? Icons.check_box_outline_blank_rounded
                : Icons.check_box_outlined,
            onPressed: () =>
                viewModel.setHideCompleted(!viewModel.hideCompleted),
            text: getTranslations().fromKey(LocaleKey.showOwned),
          ),
          goHomeAction(context),
        ],
      ),
      body: isLoading
          ? getLoading().fullPageLoading(context)
          : SearchableList<TitleDataWithOwned>(
              () async => ResultWithValue(true, filtered, ''),
              listItemDisplayer: titleDataTilePresenter(viewModel),
              listItemSearch: searchTitle,
              key: Key('title-Search-List-${titleDataWithOwned.length}'),
              minListForSearch: 5,
              addFabPadding: true,
            ),
    );
  }
}
