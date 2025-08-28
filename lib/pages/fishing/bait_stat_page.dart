import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/bait_tile_presenter.dart';
import '../../contracts/required_item.dart';
import '../../helpers/items_helper.dart';
import '../../integration/dependency_injection.dart';

class BaitStatPage extends StatelessWidget {
  const BaitStatPage({super.key});

  Future<ResultWithValue<List<BaitDataWithItemDetails>>> getBaitData(
      BuildContext context) async {
    var allGameBait = await getDataRepo().getBaitData(context);
    if (allGameBait.hasFailed) {
      return ResultWithValue(false, List.empty(), allGameBait.errorMessage);
    }

    var requiredItems =
        allGameBait.value.map((bait) => RequiredItem(id: bait.appId)).toList();
    var detailTasks =
        requiredItems.map((req) => requiredItemDetails(context, req));
    var detailResults = await Future.wait(detailTasks);
    var details = detailResults.where((dr) => dr.isSuccess).map((d) => d.value);

    List<BaitDataWithItemDetails> result = List.empty(growable: true);
    for (var gameBait in allGameBait.value) {
      var detail = details.where((d) => d.id == gameBait.appId).firstOrNull;
      if (detail == null) continue;

      result.add(BaitDataWithItemDetails(bait: gameBait, itemDetails: detail));
    }

    return ResultWithValue(result.isNotEmpty, result, '');
  }

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.fishingBait),
      body: SearchableList<BaitDataWithItemDetails>(
        () => getBaitData(context),
        listItemDisplayer: baitTilePresenter,
        hintText: getTranslations().fromKey(LocaleKey.searchItems),
        minListForSearch: 1000,
      ),
    );
  }
}
