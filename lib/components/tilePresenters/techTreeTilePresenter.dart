import 'package:flutter/material.dart';
import '../../contracts/enum/currencyType.dart';

import '../../contracts/requiredItemDetails.dart';
import '../../contracts/techTree/techTreeNode.dart';
import 'requiredItemDetailsTilePresenter.dart';

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
  return Row(
    children: [
      const SizedBox(
        child: null,
        height: 50,
        width: 50,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, maxLines: 2),
            Container(height: 4),
          ],
        ),
      ),
    ],
  );
}
