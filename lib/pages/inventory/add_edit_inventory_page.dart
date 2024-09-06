// ignore_for_file: no_logic_in_create_state

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/responsive_grid_view.dart';
import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/inventory_tile_presenter.dart';
import '../../constants/user_selection_icons.dart';
import '../../contracts/inventory/inventory.dart';
import '../../helpers/action_helper.dart';

class AddEditInventoryPage extends StatefulWidget {
  final bool isEdit;
  final Inventory inventory;
  const AddEditInventoryPage(this.inventory, this.isEdit, {Key? key})
      : super(key: key);

  @override
  _AddEditInventoryState createState() =>
      _AddEditInventoryState(inventory, isEdit);
}

class _AddEditInventoryState extends State<AddEditInventoryPage> {
  String? validationMessage;
  int selectedImageIndex = 0;
  bool isEdit;
  Inventory inventory;

  _AddEditInventoryState(this.inventory, this.isEdit) {
    var selectedIndex = UserSelectionIcons.inventory.indexOf(inventory.icon);
    selectedImageIndex = selectedIndex >= 0 ? selectedIndex : 0;
    inventory.icon = UserSelectionIcons.inventory[selectedImageIndex];
  }

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      title: inventory.name,
      actions: [
        editNameInAppBarAction(
          context,
          LocaleKey.name,
          nameIfEmpty: LocaleKey.newItem,
          currentName: inventory.name,
          onEdit: (String newName) => setState(() {
            inventory.name = newName;
          }),
        )
      ],
      body: getBody(context),
      fab: FloatingActionButton(
        onPressed: () {
          Navigator.pop(
            context,
            Inventory(
              name: inventory.name,
              uuid: inventory.uuid,
              icon: inventory.icon,
              slots: inventory.slots,
            ),
          );
        },
        heroTag: 'AddEditInventoryPage',
        child: const Icon(Icons.check),
        foregroundColor: getTheme().fabForegroundColourSelector(context),
        backgroundColor: getTheme().fabColourSelector(context),
      ),
    );
  }

  Widget getBody(BuildContext context) {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(responsiveSelectorGrid(
      context,
      UserSelectionIcons.inventory,
      selectedImageIndex,
      (BuildContext innerContext, String icon) =>
          inventoryIconTilePresenter(innerContext, icon, (String icon) {
        var selectedIndex = UserSelectionIcons.inventory.indexOf(icon);
        setState(() {
          inventory.icon = icon;
          selectedImageIndex = selectedIndex;
        });
      }),
      numberOfColumns: 6,
    ));

    return listWithScrollbar(
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
      scrollController: ScrollController(),
    );
  }
}
