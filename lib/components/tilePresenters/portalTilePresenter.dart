import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/portal/portalRecord.dart';
import '../../helpers/genericHelper.dart';
import '../portal/portalGlyphList.dart';

Widget portalTilePresenter(
  BuildContext context,
  PortalRecord portalItem, {
  void Function()? onTap,
  void Function()? onEdit,
  void Function()? onDelete,
  bool useAltGlyphs = true,
}) {
  Widget? popupMenu = positionedPopupMenu(
    context,
    onEdit: onEdit,
    onDelete: onDelete,
  );
  return GestureDetector(
    child: Stack(children: [
      Card(
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 12, right: 4, left: 4),
            child: Text(
              portalItem.name ?? '...',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: twoLinePortalGlyphList(portalItem.codes,
                useAltGlyphs: useAltGlyphs),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            children: portalItem.tags
                .map((g) => genericChip(context, g, color: Colors.transparent))
                .toList(),
          ),
        ]),
      ),
      if (popupMenu != null) ...[popupMenu],
    ]),
    onTap: onTap,
    onLongPress: onDelete,
  );
}
