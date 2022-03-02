import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../contracts/alienPuzzle/alienPuzzleType.dart';

import '../../components/tilePresenters/alienPuzzleTilePresenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/alienPuzzle/alienPuzzle.dart';
import '../../helpers/searchHelpers.dart';
import '../../integration/dependencyInjection.dart';

const defaultParamValue = [AlienPuzzleType.Harvester, AlienPuzzleType.Factory];

class AlienPuzzlesListPage extends StatelessWidget {
  final LocaleKey title;
  final List<AlienPuzzleType> puzzleTypes;
  AlienPuzzlesListPage(
      {Key key, this.title, this.puzzleTypes = defaultParamValue})
      : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.alienPuzzlesDetailPage);
  }

  Future<ResultWithValue<List<AlienPuzzle>>> getFilteredPuzzles(context) async {
    var alienPuzzlesResult =
        await getAlienPuzzleRepo().getAll(context, puzzleTypes);
    if (alienPuzzlesResult.hasFailed) return alienPuzzlesResult;

    var filtered =
        alienPuzzlesResult.value.where((al) => !al.id.contains('?')).toList();
    return ResultWithValue<List<AlienPuzzle>>(true, filtered, '');
  }

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(this.title),
      body: SearchableList<AlienPuzzle>(
        () => getFilteredPuzzles(context),
        listItemDisplayer: alienPuzzleTilePresenter,
        listItemSearch: searchAlienPuzzleIncomingMessages,
      ),
    );
  }
}
