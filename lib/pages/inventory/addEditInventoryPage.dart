import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/responsiveGridView.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/inventoryTilePresenter.dart';
import '../../constants/UserSelectionIcons.dart';
import '../../contracts/inventory/inventory.dart';
import '../../helpers/actionHelper.dart';

class AddEditInventoryPage extends StatefulWidget {
  final bool isEdit;
  final Inventory inventory;
  AddEditInventoryPage(this.inventory, this.isEdit);

  @override
  _AddEditInventoryState createState() =>
      _AddEditInventoryState(inventory, isEdit);
}

class _AddEditInventoryState extends State<AddEditInventoryPage> {
  String validationMessage;
  int selectedImageIndex = 0;
  bool isEdit;
  Inventory inventory;

  _AddEditInventoryState(this.inventory, this.isEdit) {
    var selectedIndex = UserSelectionIcons.inventory.indexOf(inventory.icon);
    this.selectedImageIndex = selectedIndex >= 0 ? selectedIndex : 0;
    this.inventory.icon = UserSelectionIcons.inventory[this.selectedImageIndex];
  }

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      title: inventory.name ?? getTranslations().fromKey(LocaleKey.newItem),
      actions: [
        editNameInAppBarAction(
          context,
          LocaleKey.name,
          nameIfEmpty: LocaleKey.newItem,
          currentName: this.inventory.name ??
              getTranslations().fromKey(LocaleKey.newItem),
          onEdit: (String newName) => setState(() {
            this.inventory.name = newName;
          }),
        )
      ],
      body: getBody(context),
      fab: FloatingActionButton(
        onPressed: () {
          Navigator.pop(
            context,
            Inventory(
                name: this.inventory.name ??
                    getTranslations().fromKey(LocaleKey.newItem),
                uuid: this.inventory.uuid,
                icon: this.inventory.icon,
                slots: this.inventory.slots ?? List.empty(growable: true)),
          );
        },
        heroTag: 'AddEditInventoryPage',
        child: Icon(Icons.check),
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
        this.setState(() {
          inventory.icon = icon;
          selectedImageIndex = selectedIndex;
        });
      }),
    ));

    return listWithScrollbar(
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
    );
  }
}
