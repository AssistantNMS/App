import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/NmsUIConstants.dart';
import '../../contracts/helloGames/newsItem.dart';
import '../../contracts/helloGames/releaseNote.dart';
import '../../helpers/genericHelper.dart';

Widget releaseNoteTilePresenter(BuildContext context, ReleaseNote release) {
  List<Widget> platformChips = List.empty(growable: true);
  if (release.isPc) {
    platformChips.add(genericChip(context, "PC", color: Colors.red));
  }
  if (release.isPs4) {
    platformChips.add(genericChip(context, "PS4", color: Colors.blue));
  }
  if (release.isPs5) {
    platformChips.add(genericChip(context, "PS5", color: Colors.blue));
  }
  if (release.isXb1) {
    platformChips.add(genericChip(context, "XB1", color: Colors.green));
  }
  if (release.isXbsx) {
    platformChips.add(genericChip(context, "X/S", color: Colors.green));
  }
  /*
  return genericListTileWithSubtitle(
    context,
    leadingImage: null,
    name: release.name,
    subtitle: Text(
      release.description,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    trailing: Wrap(children: platformChips),
    onTap: () => launchExternalURL(release.link),
  );
  */

  return GestureDetector(
    child: Card(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 4, left: 4),
            child: Text(
              release.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 4, left: 4),
            child: Text(
              release.description,
              maxLines: NMSUIConstants.ReleaseNotesDescripNumLines,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Wrap(children: platformChips),
        ],
      ),
      margin: const EdgeInsets.all(4),
    ),
    onTap: () => launchExternalURL(release.link),
  );
}

Widget newsItemTilePresenter(BuildContext context, NewsItem newsItem) {
  Widget image = networkImage(
    newsItem.image,
    loading: localImage('${getPath().imageAssetPathPrefix}/defaultNews.jpg'),
  );
  return GestureDetector(
    child: Card(
      child: Column(
        children: <Widget>[
          image,
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 4, left: 4),
            child: Text(
              newsItem.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 4, left: 4),
            child: Text(
              newsItem.date,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              newsItem.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      margin: const EdgeInsets.all(4),
    ),
    onTap: () => launchExternalURL(newsItem.link),
  );
}
