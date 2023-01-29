// ignore_for_file: no_logic_in_create_state

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

import '../../contracts/misc/custom_menu.dart';
import 'custom_homepage_components.dart';

class EditCustomHomepage extends StatefulWidget {
  final List<CustomMenu> _menuOptions;
  final int _numberOfColumns;
  final Function(List<LocaleKey>) _setCustomOrder;
  const EditCustomHomepage(
    this._menuOptions,
    this._numberOfColumns,
    this._setCustomOrder, {
    Key? key,
  }) : super(key: key);

  @override
  _EditCustomHomeWidget createState() =>
      _EditCustomHomeWidget(_menuOptions, _setCustomOrder);
}

class _EditCustomHomeWidget extends State<EditCustomHomepage> {
  final List<CustomMenu> _menuOptions;
  final Function(List<LocaleKey>) _setCustomOrder;
  _EditCustomHomeWidget(this._menuOptions, this._setCustomOrder);

  @override
  Widget build(BuildContext context) {
    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        CustomMenu row = _menuOptions.removeAt(oldIndex);
        _menuOptions.insert(newIndex, row);
        _setCustomOrder(_menuOptions.map((m) => m.title).toList());
      });
    }

    return LayoutBuilder(
      builder: (layoutCtx, BoxConstraints constraints) {
        int numberOfColumns = 6;
        double secretPadding = 4;
        double deviceWidth = constraints.maxWidth;
        if (widget._numberOfColumns < 1) {
          if (deviceWidth < 1000) numberOfColumns = 5;
          if (deviceWidth < 800) numberOfColumns = 4;
          if (deviceWidth < 600) numberOfColumns = 3;
          if (deviceWidth < 400) numberOfColumns = 2;
        } else {
          numberOfColumns = widget._numberOfColumns;
        }

        double tileSize =
            (deviceWidth / numberOfColumns) - (numberOfColumns * 2);

        List<Widget> _localTiles = _menuOptions
            .map((item) => EditingHomepageItem(item, tileSize))
            .toList();

        return ReorderableWrap(
          children: _localTiles,
          runSpacing: secretPadding,
          header: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                GenericItemGroup('Tap and hold item to drag and change order')
              ],
            ),
          ],
          onReorder: _onReorder,
          maxMainAxisCount: numberOfColumns,
          onNoReorder: (int index) {},
          onReorderStarted: (int index) {},
        );
      },
    );
  }
}
