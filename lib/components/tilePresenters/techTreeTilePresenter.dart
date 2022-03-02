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
  return requiredItemTreeDetailsRowPresenter(
    context,
    RequiredItemDetails(name: name),
    CurrencyType.NONE,
    0,
  );
}

// Widget techTreeNodeTilePresenter(
//     BuildContext context, TechTreeNode item, int level) {
//   List<Widget> rowWidgets = List.empty(growable: true);
//   if (item.children.length > 0) {
//     rowWidgets.add(Padding(
//       child: itemIcon,
//       padding: const EdgeInsets.only(right: 8.0),
//     ));
//   } else {
//     rowWidgets.add(Padding(
//       child: Icon(Icons.add_circle, size: 20, color: Colors.transparent),
//       padding: const EdgeInsets.only(right: 8.0),
//     ));
//   }
//   rowWidgets.add(Text(
//     item.title,
//     maxLines: 1,
//     overflow: TextOverflow.ellipsis,
//   ));
//   return Padding(
//     child: ListTile(
//       // leading: genericTileImage(item.icon, null),
//       title: Row(children: rowWidgets),
//       trailing: IconButton(
//         icon: Icon(Icons.exit_to_app),
//         onPressed: () async => await getNavigation().navigateAsync(context,
//             navigateTo: (context) => GenericPage(item.id)),
//       ),
//     ),
//     padding: EdgeInsets.only(left: level * itemPadding),
//   );
// }

// Widget techTreeTilePresenter(BuildContext context, String name, int level) {
//   List<Widget> rowWidgets = List.empty(growable: true);
//   rowWidgets.add(Padding(
//     child: itemIcon,
//     padding: const EdgeInsets.only(right: 8.0),
//   ));
//   rowWidgets.add(Text(
//     name,
//     maxLines: 1,
//     overflow: TextOverflow.ellipsis,
//   ));
//   var child = Padding(
//     child: ListTile(
//       title: Row(children: rowWidgets),
//     ),
//     padding: EdgeInsets.only(left: level * itemPadding),
//   );
//   if (level == 0) {
//     return Card(child: child);
//   }
//   return child;
// }
