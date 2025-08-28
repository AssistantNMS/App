import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/required_item.dart';
import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/required_item_details_tile_presenter.dart';
import '../../constants/analytics_event.dart';
import '../../constants/nms_ui_constants.dart';
import '../../contracts/enum/currency_type.dart';
import '../../contracts/generic_page_all_required.dart';
import '../../contracts/required_item_details.dart';
import '../../contracts/required_item_tree_details.dart';
import '../../helpers/items_helper.dart';
import 'generic_page_all_required_raw_materials_tree_components.dart';

class GenericPageAllRequiredRawMaterials extends StatefulWidget {
  final GenericPageAllRequired item;
  final bool showBackgroundColours;
  const GenericPageAllRequiredRawMaterials(
    this.item,
    this.showBackgroundColours, {
    Key? key,
  }) : super(key: key);

  @override
  createState() => _GenericPageAllRequiredRawMaterialsWidget();
}

class _GenericPageAllRequiredRawMaterialsWidget
    extends State<GenericPageAllRequiredRawMaterials> {
  int currentSelection = 0;

  _GenericPageAllRequiredRawMaterialsWidget() {
    getAnalytics()
        .trackEvent(AnalyticsEvent.genericAllRequiredRawMaterialsPage);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> options = [
      SegmentedControlWithIconOption(
        icon: Icons.list,
        text: getTranslations().fromKey(LocaleKey.flatList),
      ),
      SegmentedControlWithIconOption(
        icon: Icons.call_split,
        text: getTranslations().fromKey(LocaleKey.tree),
      )
    ];
    Container segmentedWidget = Container(
      child: AdaptiveSegmentedControl(
        controlItems: options,
        currentSelection: currentSelection,
        onSegmentChosen: (index) {
          setState(() {
            currentSelection = index;
          });
        },
      ),
      margin: const EdgeInsets.all(8),
    );

    return basicGenericPageScaffold(
      context,
      title: widget.item.typeName,
      body: getBody(context, currentSelection, segmentedWidget),
      // fab: getFloatingActionButton(context, controller, item.genericItem),
    );
  }

  List<Widget> getFlatListBody(
    BuildContext context,
    AsyncSnapshot<List<RequiredItemDetails>> snapshot,
  ) {
    Widget? errorWidget = asyncSnapshotHandler(context, snapshot);
    if (errorWidget != null) return [errorWidget];

    List<Widget> widgets = List.empty(growable: true);

    Widget Function(BuildContext context, RequiredItemDetails itemDetails)
        requiredItemDetailsPresenter =
        requiredItemDetailsBackgroundTilePresenter(
      widget.showBackgroundColours,
    );
    if (snapshot.data!.isNotEmpty) {
      for (RequiredItemDetails item in snapshot.data!) {
        widgets.add(requiredItemDetailsPresenter(context, item));
      }
    } else {
      widgets.add(
        Container(
          child: Text(
            getTranslations().fromKey(LocaleKey.noItems),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 20),
          ),
          margin: const EdgeInsets.only(top: 30),
        ),
      );
    }

    widgets.add(const EmptySpace8x());

    return widgets;
  }

  List<Widget> getTreeBody(
    BuildContext context,
    AsyncSnapshot<List<RequiredItemTreeDetails>> snapshot,
  ) {
    Widget? errorWidget = asyncSnapshotHandler(context, snapshot);
    if (errorWidget != null) return [errorWidget];

    List<Widget> widgets = List.empty(growable: true);

    if (snapshot.data!.isNotEmpty) {
      widgets.add(Expanded(
        child: ListView(
          shrinkWrap: true,
          children: [
            getTree(context, snapshot.data!, CurrencyType.NONE),
          ],
        ),
      ));
    } else {
      widgets.add(
        Container(
          child: Text(
            getTranslations().fromKey(LocaleKey.noItems),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 20),
          ),
          margin: const EdgeInsets.only(top: 30),
        ),
      );
    }

    return widgets;
  }

  Widget getBody(
    BuildContext context,
    int currentSelection,
    Widget segmentedWidget,
  ) {
    List<Widget> widgets = List.empty(growable: true);
    if (widget.item.name.isNotEmpty) {
      widgets.add(const EmptySpace1x());
      widgets.add(GenericItemName(widget.item.name));
      widgets.add(GenericItemText(
        getTranslations().fromKey(LocaleKey.allRawMaterialsRequired),
      ));
    }

    widgets.add(Padding(
      padding: NMSUIConstants.buttonPadding,
      child: segmentedWidget,
    ));

    List<RequiredItem> requiredItems = widget.item.requiredItems;

    if (currentSelection == 0) {
      return FutureBuilder<List<RequiredItemDetails>>(
        future: getAllRequiredItemsForMultiple(context, requiredItems),
        builder: (BuildContext builderContext,
            AsyncSnapshot<List<RequiredItemDetails>> snapshot) {
          List<Widget> listSpecificWidgets = [
            ...widgets,
            ...getFlatListBody(builderContext, snapshot)
          ];
          return listWithScrollbar(
            itemCount: listSpecificWidgets.length,
            itemBuilder: (builderContext, index) => listSpecificWidgets[index],
            scrollController: ScrollController(),
          );
        },
      );
    } else {
      return FutureBuilder<List<RequiredItemTreeDetails>>(
        future: getAllRequiredItemsForTree(context, requiredItems),
        builder: (BuildContext builderContext,
            AsyncSnapshot<List<RequiredItemTreeDetails>> snapshot) {
          var treeSpecificWidgets = [
            ...widgets,
            ...getTreeBody(builderContext, snapshot)
          ];
          return Column(
            children: treeSpecificWidgets,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
          );
        },
      );
    }
  }
}
