import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../contracts/guide/guideSectionItem.dart';
import '../common/image.dart';

Widget nmsSectionListItem(
        BuildContext context, String text, List<Widget> widgets) =>
    SliverStickyHeader(
      header: Container(
        height: 60.0,
        color: getTheme().getSecondaryColour(context),
        alignment: Alignment.center,
        margin: const EdgeInsets.all(0.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_c, i) => widgets[i],
          childCount: widgets.length,
        ),
      ),
    );

Widget nmsTextListItem(NmsGuideSectionItem item) => flatCard(
      child: ListTile(
        title: Text(
          item.content,
          maxLines: 2000,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );

Widget nmsLinkListItem(NmsGuideSectionItem item) {
  // ignore: prefer_function_declarations_over_variables
  Function() onTap = () => launchExternalURL(item.content);
  return flatCard(
    child: GestureDetector(
      child: Chip(
        label: Text(item.name),
        backgroundColor: Colors.transparent,
        deleteIcon: const Icon(Icons.open_in_new),
        onDeleted: onTap,
      ),
      onTap: onTap,
    ),
  );
}

Widget nmsImageListItem(context, NmsGuideSectionItem item, String folder) {
  bool isNetworkImage = (item.image == null || item.image.isEmpty);

  String imagePath = 'guide.png';
  if (isNetworkImage) {
    imagePath = item.imageUrl;
  } else {
    if (item.image.contains('${getPath().imageAssetPathPrefix}/')) {
      imagePath = item.image;
    } else {
      imagePath = 'assets/guide/$folder/${item.image}';
    }
  }

  return GestureDetector(
    child: flatCard(
      child: (item.image == null || item.image.isEmpty)
          ? networkImage(imagePath)
          : guideImage(imagePath),
    ),
    onTap: () async {
      await getNavigation().navigateAsync(
        context,
        navigateTo: (context) => ImageViewerPage(
          item.name,
          imagePath,
          analyticsKey: '',
        ),
      );
    },
  );
}

Widget nmsMarkdownListItem(NmsGuideSectionItem item) {
  return flatCard(
    child: Padding(
      child: MarkdownBody(data: item.content),
      padding: const EdgeInsets.all(16.0),
    ),
  );
}

Widget nmsTableListItem(context, NmsGuideSectionItem item) {
  List<Widget> headingRowChildren = item.columns
      .map((c) => Padding(
          child: Text(
            c,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          padding: const EdgeInsets.all(8.0)))
      .toList();

  List<TableRow> rows = List.empty(growable: true);
  rows.add(TableRow(children: headingRowChildren));

  for (List<String> row in item.rows) {
    List<Widget> rowChildren = List.empty(growable: true);
    for (int colIndex = 0; colIndex < item.columns.length; colIndex++) {
      rowChildren.add(Padding(
        child: Text(row[colIndex]),
        padding: const EdgeInsets.all(8.0),
      ));
    }
    rows.add(TableRow(children: rowChildren));
  }

  return flatCard(
    child: Padding(
      child: Table(
        children: rows,
        border:
            TableBorder.all(width: 1, color: getTheme().getH1Colour(context)),
      ),
      padding: const EdgeInsets.all(16.0),
    ),
  );
}
