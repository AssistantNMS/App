import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/responsive_grid_view.dart';
import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/menu_item_tile_presenter.dart';
import '../../helpers/catalogueHelper.dart';

class CataloguePage extends StatelessWidget {
  const CataloguePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.catalogue),
      body: responsiveGrid(
        context,
        getCatalogueItemData(context),
        menuItemTilePresenter,
      ),
    );
  }
}
