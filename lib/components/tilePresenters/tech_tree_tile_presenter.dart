import 'package:flutter/material.dart';
import '../../contracts/enum/currency_type.dart';

import '../../contracts/required_item_details.dart';
import '../../contracts/techTree/tech_tree_node.dart';
import 'required_item_details_tile_presenter.dart';

const double itemPadding = 16.0;
const Widget itemIcon = Icon(Icons.add_circle, size: 20);

Widget techTreeNodeTilePresenter(
    BuildContext context, TechTreeNode item, CurrencyType costType) {
  return Expanded(
    child: requiredItemTreeDetailsRowPresenter(
      context,
      RequiredItemDetails(id: item.id, name: item.title, icon: item.icon),
      costType,
      item.cost,
    ),
  );
}

Widget techTreeTilePresenter(BuildContext context, String name) {
  return Padding(
    padding: const EdgeInsets.only(left: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, maxLines: 2),
        Container(height: 4),
      ],
    ),
  );
}
