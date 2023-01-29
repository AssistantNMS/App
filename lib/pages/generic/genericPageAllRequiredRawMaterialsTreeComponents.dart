import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import '../../contracts/enum/currency_type.dart';

import '../../components/tilePresenters/required_item_details_tile_presenter.dart';
import '../../contracts/required_item_details.dart';
import '../../contracts/required_item_tree_details.dart';
import '../../helpers/sortHelper.dart';

TreeView getTree(
    context, List<RequiredItemTreeDetails> node, CurrencyType costType) {
  List<TreeNode> parents = List.empty(growable: true);
  // TreeController controller = TreeController(allNodesExpanded: false);
  for (RequiredItemTreeDetails child in node) {
    parents.add(TreeNode(
        content: Expanded(
          child: requiredItemTreeDetailsRowPresenter(
            context,
            RequiredItemDetails.toRequiredItemDetails(child),
            costType,
            child.cost,
          ),
        ),
        children: child.children
            .map((ttn) => mapChildren(context, ttn, costType))
            .toList()));
  }
  // return TreeView(nodes: parents, indent: 30, treeController: controller);
  return TreeView(nodes: parents, indent: 25);
}

TreeNode mapChildren(
    BuildContext context, RequiredItemTreeDetails node, CurrencyType costType) {
  List<TreeNode> children = List.empty(growable: true);

  for (RequiredItemTreeDetails child in node.children) {
    var childList = child.children;
    // childList.sort((a, b) => a.children.length.compareTo(b.children.length));
    childList.sort((ttna, ttnb) => boolToInt(ttna.children.isNotEmpty)
        .compareTo(boolToInt(ttnb.children.isNotEmpty)));
    children.add(TreeNode(
      content: Expanded(
        child: requiredItemTreeDetailsRowPresenter(
          context,
          RequiredItemDetails.toRequiredItemDetails(child),
          costType,
          child.cost,
        ),
      ),
      children:
          childList.map((ttn) => mapChildren(context, ttn, costType)).toList(),
    ));
  }
  return TreeNode(
    content: Expanded(
      child: requiredItemTreeDetailsRowPresenter(
        context,
        RequiredItemDetails.toRequiredItemDetails(node),
        costType,
        node.cost,
      ),
    ),
    children: children,
  );
}
