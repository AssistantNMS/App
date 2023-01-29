import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/responsive_grid_view.dart';
import '../../contracts/misc/custom_menu.dart';
import 'customHomepageComponents.dart';

class ViewCustomHomepage extends StatelessWidget {
  final List<CustomMenu> _menuItems;
  final int _numberOfColumns;

  const ViewCustomHomepage(this._menuItems, this._numberOfColumns, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget Function(BuildContext gridCtx) renderGrid;
    renderGrid = (BuildContext gridCtx) => responsiveGrid(
          gridCtx,
          _menuItems,
          customMenuItemGridPresenter,
          numberOfColumns: _numberOfColumns,
        );

    return AppNoticesWrapper(
      child: renderGrid(context),
    );
  }
}
