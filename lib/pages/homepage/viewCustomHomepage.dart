import 'package:flutter/material.dart';

import '../../components/responsiveGridView.dart';
import '../../contracts/misc/customMenu.dart';
import 'customHomepageComponents.dart';

class ViewCustomHomepage extends StatelessWidget {
  final List<CustomMenu> _menuItems;
  const ViewCustomHomepage(this._menuItems, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return responsiveGrid(
      context,
      _menuItems,
      customMenuItemGridPresenter,
    );
  }
}
