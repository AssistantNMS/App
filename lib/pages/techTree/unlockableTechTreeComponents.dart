import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';

import '../../components/tilePresenters/techTreeTilePresenter.dart';
import '../../contracts/enum/currencyType.dart';
import '../../contracts/techTree/techTree.dart';
import '../../contracts/techTree/techTreeNode.dart';
import '../../contracts/techTree/unlockableTechTree.dart';
import '../../helpers/sortHelper.dart';

TreeView getTree(context, List<UnlockableTechTree> utt) {
  TreeController controller = TreeController(allNodesExpanded: false);
  List<TreeNode> unlTechTrees = List.empty(growable: true);
  for (UnlockableTechTree unTechTree in utt) {
    List<TreeNode> techTrees = List.empty(growable: true);
    for (TechTree techTree in unTechTree.trees) {
      List<TreeNode> trees = List.empty(growable: true);
      for (var treeNode in techTree.children) {
        trees.add(mapChildren(context, treeNode, techTree.costType));
      }
      techTrees.add(TreeNode(
        content: techTreeTilePresenter(context, techTree.name),
        children: trees,
      ));
    }

    unlTechTrees.add(TreeNode(
      content: techTreeTilePresenter(context, unTechTree.name),
      children: techTrees,
    ));
  }
  return TreeView(nodes: unlTechTrees, indent: 15, treeController: controller);
}

TreeView getTreeWithoutSecondLevel(context, List<UnlockableTechTree> utt) {
  TreeController controller = TreeController(allNodesExpanded: false);
  List<TreeNode> parents = List.empty(growable: true);
  for (UnlockableTechTree unTechTree in utt) {
    List<TreeNode> children = List.empty(growable: true);
    for (TechTree techTree in unTechTree.trees) {
      children.add(TreeNode(
          content: techTreeNodeTilePresenter(
              context, techTree.children[0], techTree.costType),
          children: techTree.children[0].children
              .map((ttn) => mapChildren(context, ttn, techTree.costType))
              .toList()));
    }
    parents.add(
      TreeNode(
        content: techTreeTilePresenter(context, unTechTree.name),
        children: children,
      ),
    );
  }
  return TreeView(nodes: parents, indent: 25, treeController: controller);
}

TreeView getSubTree(context, TechTree techTree, String heading) {
  TreeController controller = TreeController(allNodesExpanded: true);
  List<TreeNode> parents = List.empty(growable: true);
  parents.add(
    TreeNode(content: techTreeTilePresenter(context, heading), children: [
      TreeNode(
          content: techTreeNodeTilePresenter(
              context, techTree.children[0], techTree.costType),
          children: techTree.children[0].children
              .map((ttn) => mapChildren(context, ttn, techTree.costType))
              .toList())
    ]),
  );
  return TreeView(nodes: parents, indent: 25, treeController: controller);
}

TreeNode mapChildren(
    BuildContext context, TechTreeNode node, CurrencyType costType) {
  List<TreeNode> children = List.empty(growable: true);

  for (TechTreeNode child in node.children) {
    var childList = child.children;
    // childList.sort((a, b) => a.children.length.compareTo(b.children.length));
    childList.sort((ttna, ttnb) => boolToInt(ttna.children.isNotEmpty)
        .compareTo(boolToInt(ttnb.children.isNotEmpty)));
    children.add(TreeNode(
      content: techTreeNodeTilePresenter(context, child, costType),
      children:
          childList.map((ttn) => mapChildren(context, ttn, costType)).toList(),
    ));
  }
  return TreeNode(
    content: techTreeNodeTilePresenter(context, node, costType),
    children: children,
  );
}
