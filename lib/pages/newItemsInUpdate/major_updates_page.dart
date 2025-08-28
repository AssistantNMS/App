import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/major_update_tile_presenter.dart';
import '../../contracts/data/major_update_item.dart';
import '../../helpers/column_helper.dart';
import '../../integration/dependency_injection.dart';
import 'major_updates_speculation_page.dart';

class MajorUpdatesPage extends StatelessWidget {
  const MajorUpdatesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.newItemsAdded),
      body: FutureBuilder<ResultWithValue<List<MajorUpdateItem>>>(
        future: getDataRepo().getMajorUpdates(context),
        builder: getBodyFromFuture,
      ),
    );
  }

  Widget getBodyFromFuture(
    BuildContext bodyCtx,
    AsyncSnapshot<ResultWithValue<List<MajorUpdateItem>>> snapshot,
  ) {
    List<Widget> listItems = List.empty(growable: true);

    Widget? errorWidget = asyncSnapshotHandler(
      bodyCtx,
      snapshot,
      loader: () => getLoading().fullPageLoading(bodyCtx),
      isValidFunction: (ResultWithValue<List<MajorUpdateItem>>? expResult) {
        if (expResult?.hasFailed ?? true) return false;
        if (expResult?.value == null) return false;
        return true;
      },
    );
    if (errorWidget != null) return errorWidget;

    listItems.add(majorUpdateTilePresenter(
      bodyCtx,
      MajorUpdateItem(
        guid: getNewGuid(),
        gameVersion: getTranslations().fromKey(LocaleKey.speculation),
        title: getTranslations().fromKey(LocaleKey.speculation),
        icon: 'update/speculation.png',
        itemIds: [],
        updateType: UpdateType.minor,
        releaseDate: DateTime.now(),
      ),
      onTap: () => getNavigation().navigateAwayFromHomeAsync(
        bodyCtx,
        navigateTo: (_) =>
            MajorUpdatesSpeculationPage(items: snapshot.data!.value),
      ),
    ));
    for (MajorUpdateItem update in snapshot.data!.value) {
      listItems.add(majorUpdateTilePresenter(bodyCtx, update));
    }

    return SearchableGrid<Widget>(
      () => Future.value(ResultWithValue<List<Widget>>(true, listItems, '')),
      gridItemDisplayer:
          (BuildContext ctx, Widget widg, {void Function()? onTap}) => widg,
      gridItemSearch: (Widget item, String searchText) => false,
      gridViewColumnCalculator: getMajorUpdateColumnCount,
      addFabPadding: true,
      minListForSearch: 1000,
    );

    // return listWithScrollbar(
    //   shrinkWrap: true,
    //   itemCount: listItems.length,
    //   itemBuilder: (BuildContext context, int index) => listItems[index],
    //   padding: const EdgeInsets.only(bottom: 64),
    //   scrollController: ScrollController(),
    // );
  }
}
