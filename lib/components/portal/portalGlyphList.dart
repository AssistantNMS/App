import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

Widget portalGlyphList(
  List<int> currentCodes,
  int numItemsPerLine, {
  double height,
  double width,
  bool useAltGlyphs = false,
}) =>
    GridView.builder(
      primary: false,
      shrinkWrap: true,
      padding: const EdgeInsets.all(5),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 1,
        mainAxisSpacing: 10,
        crossAxisCount: numItemsPerLine,
      ),
      itemCount: 12,
      itemBuilder: (BuildContext context, int index) {
        String type = getTheme().getIsDark(context) ? 'white' : 'black';
        if (useAltGlyphs) type = 'alt';
        String basePath = getPath().imageAssetPathPrefix;
        String path = 'portals/$type/dot.png';
        if (index < currentCodes.length) {
          String hexNum = currentCodes[index].toRadixString(16);
          path = 'portals/$type/$hexNum.png';
        }
        return localImage('$basePath/$path');
      },
    );

Widget twoLinePortalGlyphList(List<int> currentCodes,
        {bool useAltGlyphs = false}) =>
    portalGlyphList(currentCodes, 6, useAltGlyphs: useAltGlyphs);

Widget oneLinePortalGlyphList(List<int> currentCodes,
        {bool useAltGlyphs = false}) =>
    portalGlyphList(currentCodes, 12, useAltGlyphs: useAltGlyphs);

Widget portalInput(
  BuildContext context, {
  @required String colour,
  @required void Function(int) addCode,
  double width,
  bool isDisabled = false,
}) {
  const double runSpacing = 1;
  const double spacing = 1;
  const columns = 4;
  double localWidth = width ?? MediaQuery.of(context).size.width;
  final w = (localWidth - runSpacing * (columns - 1)) / columns;

  return Wrap(
    runSpacing: runSpacing,
    spacing: spacing,
    alignment: WrapAlignment.center,
    children: List.generate(16, (index) {
      String hexNum = index.toRadixString(16);

      Widget imgChild = localImage(
        '${getPath().imageAssetPathPrefix}/portals/$colour/$hexNum.png',
        width: w,
        height: w,
      );

      return FittedBox(
        child: RawMaterialButton(
          onPressed: () => addCode(index),
          // fillColor: Colors.transparent,
          constraints: BoxConstraints.tightFor(width: w, height: w),
          child: (isDisabled == false)
              ? imgChild
              : ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    getTheme().getScaffoldBackgroundColour(context),
                    BlendMode.saturation,
                  ),
                  child: imgChild,
                ),
        ),
      );
    }),
  );
}
