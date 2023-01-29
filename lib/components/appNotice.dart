import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../constants/NmsUIConstants.dart';

Widget appNoticeTile(AppNoticeViewModel notice) {
  return FlatCard(
    child: Padding(
      padding: const EdgeInsets.all(4),
      child: appNoticeTileCore(notice),
    ),
  );
}

Widget appNoticeTileCore(AppNoticeViewModel notice) {
  void Function() onTap = () => {};

  if (notice.externalUrl.isNotEmpty) {
    onTap = () => launchExternalURL(notice.externalUrl);
  }

  return ListTile(
    leading: ClipRRect(
      borderRadius: NMSUIConstants.gameItemBorderRadius,
      child: ImageFromNetwork(imageUrl: notice.iconUrl, width: 50.0),
    ),
    title: Text(notice.name, maxLines: 1),
    subtitle: Text(notice.subtitle, maxLines: 1),
    trailing: (notice.externalUrl.isEmpty)
        ? null
        : IconButton(
            icon: const Icon(Icons.chevron_right),
            iconSize: 32,
            onPressed: onTap,
          ),
    onTap: onTap,
  );
}
