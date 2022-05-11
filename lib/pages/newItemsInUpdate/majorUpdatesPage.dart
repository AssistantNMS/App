import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/integration/dependencyInjection.dart';
import 'package:flutter/material.dart';

import '../../components/drawer.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/majorUpdateTilePresenter.dart';
import '../../contracts/data/majorUpdateItem.dart';

class MajorUpdatesPage extends StatelessWidget {
  const MajorUpdatesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.newItemsAdded),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: getDataRepo().getMajorUpdates(context),
        builder: getBodyFromFuture,
      ),
    );
  }

  Widget getBodyFromFuture(BuildContext bodyCtx,
      AsyncSnapshot<ResultWithValue<List<MajorUpdateItem>>> snapshot) {
    List<Widget> listItems = List.empty(growable: true);

    Widget errorWidget = asyncSnapshotHandler(
      bodyCtx,
      snapshot,
      loader: () => getLoading().fullPageLoading(bodyCtx),
      isValidFunction: (ResultWithValue<List<MajorUpdateItem>> expResult) {
        if (expResult.hasFailed) return false;
        if (expResult.value == null) return false;
        return true;
      },
    );
    if (errorWidget != null) return errorWidget;

    for (MajorUpdateItem update in snapshot.data.value) {
      listItems.add(majorUpdateTilePresenter(bodyCtx, update));
    }

    return listWithScrollbar(
      shrinkWrap: true,
      itemCount: listItems.length,
      itemBuilder: (BuildContext context, int index) => listItems[index],
    );
  }
}
