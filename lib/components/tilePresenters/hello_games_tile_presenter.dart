import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/nms_ui_constants.dart';
import '../../contracts/helloGames/news_item.dart';
import '../../contracts/helloGames/release_note.dart';

Widget releaseNoteTilePresenter(BuildContext context, ReleaseNote release,
    {void Function()? onTap}) {
  List<Widget> platformChips = List.empty(growable: true);
  if (release.isPc) {
    platformChips.add(getBaseWidget().appChip(
      text: 'PC',
      backgroundColor: Colors.red[400]!,
    ));
    platformChips.add(getBaseWidget().appChip(
      text: 'Mac',
      backgroundColor: Colors.red[400]!,
    ));
  }
  if (release.isMac) {}
  if (release.isPs4) {
    platformChips.add(getBaseWidget().appChip(
      text: 'PS4',
      backgroundColor: Colors.blue,
    ));
  }
  if (release.isPs5) {
    platformChips.add(getBaseWidget().appChip(
      text: 'PS5',
      backgroundColor: Colors.blue,
    ));
  }
  if (release.isXb1) {
    platformChips.add(getBaseWidget().appChip(
      text: 'XB1',
      backgroundColor: Colors.green,
    ));
  }
  if (release.isXbsx) {
    platformChips.add(getBaseWidget().appChip(
      text: 'X/S',
      backgroundColor: Colors.green,
    ));
  }
  if (release.isNsw) {
    platformChips.add(getBaseWidget().appChip(
      text: 'Nintendo Switch',
      backgroundColor: Colors.red[900]!,
    ));
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
    child: Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 8),
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
              Wrap(children: platformChips, spacing: 6),
            ],
          ),
        ),
        margin: const EdgeInsets.all(4),
      ),
    ),
    onTap: () => launchExternalURL(release.link),
  );
}

Widget newsItemTilePresenter(BuildContext context, NewsItem newsItem,
    {void Function()? onTap}) {
  Widget image = ImageFromNetwork(
    imageUrl: newsItem.image,
    loading: LocalImage(
        imagePath: '${getPath().imageAssetPathPrefix}/defaultNews.jpg'),
  );
  return GestureDetector(
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.all(4),
      ),
    ),
    onTap: () => launchExternalURL(newsItem.link),
  );
}
