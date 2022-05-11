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
      body: SearchableList<MajorUpdateItem>(
        () => getDataRepo().getMajorUpdates(context),
        listItemDisplayer: majorUpdateTilePresenter,
        listItemSearch: (MajorUpdateItem item, String searchText) => false,
        key: Key(getTranslations().currentLanguage),
        addFabPadding: true,
        minListForSearch: 1000,
      ),
    );
  }
}
