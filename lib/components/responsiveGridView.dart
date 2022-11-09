import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

Widget responsiveGrid<T>(
  BuildContext context,
  List<T> items,
  Widget Function(BuildContext context, T item) gridItemPresenter,
) {
  double deviceWidth = MediaQuery.of(context).size.width;
  int numberOfColumns = 8;
  if (deviceWidth < 1400.0) numberOfColumns = 7;
  if (deviceWidth < 1200.0) numberOfColumns = 6;
  if (deviceWidth < 1000.0) numberOfColumns = 5;
  if (deviceWidth < 800.0) numberOfColumns = 4;
  if (deviceWidth < 600.0) numberOfColumns = 3;
  if (deviceWidth < 400.0) numberOfColumns = 2;

  return GridView.builder(
    primary: false,
    shrinkWrap: true,
    padding: const EdgeInsets.all(8),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: numberOfColumns,
    ),
    itemCount: items.length,
    itemBuilder: (BuildContext context, int index) => gridItemPresenter(
      context,
      items[index],
    ),
  );
}

Widget responsiveSelectorGrid<T>(
    BuildContext context,
    List<T> items,
    int selectedIndex,
    Widget Function(BuildContext context, T item) gridItemPresenter) {
  double deviceWidth = MediaQuery.of(context).size.width;
  int numberOfColumns = 8;
  if (deviceWidth < 800) numberOfColumns = 8;
  if (deviceWidth < 600) numberOfColumns = 6;
  if (deviceWidth < 400) numberOfColumns = 4;

  return GridView.builder(
    primary: false,
    shrinkWrap: true,
    padding: const EdgeInsets.all(8),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: numberOfColumns,
    ),
    itemCount: items.length,
    itemBuilder: (BuildContext context, int index) => Container(
      child: gridItemPresenter(context, items[index]),
      color: index == selectedIndex
          ? getTheme().getSecondaryColour(context)
          : null,
    ),
  );
}
