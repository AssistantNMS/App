import 'package:flutter/material.dart';

import '../../components/responsiveGridView.dart';
import '../../contracts/misc/customMenu.dart';
import 'customHomepageComponents.dart';

class ViewCustomHomepage extends StatelessWidget {
  final List<CustomMenu> _menuItems;
  final int _numberOfColumns;
  const ViewCustomHomepage(this._menuItems, this._numberOfColumns, {Key key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return responsiveGrid(
      context,
      _menuItems,
      customMenuItemGridPresenter,
      numberOfColumns: _numberOfColumns,
    );
  }
}
