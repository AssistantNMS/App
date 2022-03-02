import 'package:after_layout/after_layout.dart';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/adaptive/homePageAppBar.dart';
import '../../components/drawer.dart';
import '../../components/responsiveGridView.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/menuItemTilePresenter.dart';
import '../../helpers/catalogueHelper.dart';
import '../../helpers/updateHelper.dart';

class CatalogueHomepage extends StatefulWidget {
  @override
  _CatalogueHomeWidget createState() => _CatalogueHomeWidget();
}

class _CatalogueHomeWidget extends State<CatalogueHomepage>
    with AfterLayoutMixin<CatalogueHomepage> {
  @override
  void afterFirstLayout(BuildContext context) => checkForUpdate(context);

  bool isEdit = false;
  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      drawer: AppDrawer(),
      appBar: homePageAppBar(getTranslations().fromKey(LocaleKey.catalogue)),
      body: responsiveGrid(
        context,
        getCatalogueItemData(context),
        menuItemTilePresenter,
      ),
    );
  }
}
