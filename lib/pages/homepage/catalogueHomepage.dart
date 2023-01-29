import 'package:after_layout/after_layout.dart';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/adaptive/home_page_app_bar.dart';
import '../../components/drawer.dart';
import '../../components/responsive_grid_view.dart';
import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/menuItemTilePresenter.dart';
import '../../helpers/catalogueHelper.dart';
import '../../helpers/updateHelper.dart';

class CatalogueHomepage extends StatefulWidget {
  const CatalogueHomepage({Key? key}) : super(key: key);

  @override
  createState() => _CatalogueHomeWidget();
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
      drawer: const AppDrawer(),
      appBar: HomePageAppBar(
        getTranslations().fromKey(LocaleKey.catalogue),
      ),
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext bodyContext) {
    Widget Function(BuildContext gridCtx) renderBody;
    renderBody = (BuildContext gridCtx) => responsiveGrid(
          gridCtx,
          getCatalogueItemData(gridCtx),
          menuItemTilePresenter,
        );

    return AppNoticesWrapper(
      child: renderBody(bodyContext),
    );
  }
}
