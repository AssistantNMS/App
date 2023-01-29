import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../contracts/alienPuzzle/alienPuzzleType.dart';

import '../../components/tilePresenters/alien_puzzle_tile_presenter.dart';
import '../../constants/analytics_event.dart';
import '../../contracts/alienPuzzle/alienPuzzle.dart';
import '../../helpers/searchHelpers.dart';
import '../../integration/dependencyInjection.dart';

const defaultParamValue = [AlienPuzzleType.Harvester, AlienPuzzleType.Factory];

class AlienPuzzlesListPage extends StatelessWidget {
  final LocaleKey title;
  final List<AlienPuzzleType> puzzleTypes;
  AlienPuzzlesListPage({
    Key? key,
    required this.title,
    this.puzzleTypes = defaultParamValue,
  }) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.alienPuzzlesDetailPage);
  }

  Future<ResultWithValue<List<AlienPuzzle>>> getFilteredPuzzles(context) async {
    ResultWithValue<List<AlienPuzzle>> alienPuzzlesResult =
        await getAlienPuzzleRepo().getAll(context, puzzleTypes);
    if (alienPuzzlesResult.hasFailed) return alienPuzzlesResult;

    List<AlienPuzzle> filtered =
        alienPuzzlesResult.value.where((al) => !al.id.contains('?')).toList();
    return ResultWithValue<List<AlienPuzzle>>(true, filtered, '');
  }

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(title),
      body: SearchableList<AlienPuzzle>(
        () => getFilteredPuzzles(context),
        listItemDisplayer: alienPuzzleTilePresenter,
        listItemSearch: searchAlienPuzzleIncomingMessages,
      ),
    );
  }
}
