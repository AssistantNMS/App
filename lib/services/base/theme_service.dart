import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colour.dart';
import '../../constants/fonts.dart';
import '../../theme/themes.dart';

class ThemeService implements IThemeService {
  @override
  ThemeData getTheme(BuildContext context) => AdaptiveTheme.of(context).theme;

  @override
  Color getPrimaryColour(BuildContext context) =>
      getTheme(context).primaryColor;

  @override
  Color getSecondaryColour(BuildContext context) =>
      getTheme(context).colorScheme.secondary;

  @override
  Color getDarkModeSecondaryColour() =>
      getDynamicTheme(Brightness.dark, defaultFontFamily).colorScheme.secondary;

  @override
  bool getIsDark(BuildContext context) =>
      getTheme(context).brightness == Brightness.dark;

  @override
  Color getBackgroundColour(BuildContext context) =>
      getTheme(context).colorScheme.surface;

  @override
  Color getScaffoldBackgroundColour(BuildContext context) =>
      getTheme(context).scaffoldBackgroundColor;

  @override
  void setFontFamily(BuildContext context, String fontFamily) {
    AdaptiveTheme.of(context).setTheme(
      light: getDynamicTheme(Brightness.light, defaultFontFamily),
      dark: getDynamicTheme(Brightness.dark, defaultFontFamily),
    );
  }

  @override
  Color getH1Colour(BuildContext context) {
    var textColour =
        AdaptiveTheme.of(context).theme.textTheme.displayLarge?.color;
    if (textColour == null) {
      return getIsDark(context) ? Colors.white : Colors.black;
    }
    return textColour;
  }

  @override
  Color getTextColour(BuildContext context) =>
      getIsDark(context) ? Colors.white : Colors.black;

  @override
  void setBrightness(BuildContext context, bool isDark) {
    AdaptiveTheme.of(context).setThemeMode(
      isDark ? AdaptiveThemeMode.light : AdaptiveThemeMode.dark,
    );
  }

  @override
  Color getAndroidColour() => HexColor(AppColour.androidChipHex);

  @override
  Color getIosColour() => HexColor(AppColour.iOSChipHex);

  @override
  Color getCardTextColour(BuildContext context) =>
      getIsDark(context) ? Colors.white54 : Colors.black54;

  @override
  Color getCardBackgroundColour(BuildContext context) => lighten(
        getDynamicTheme(Brightness.dark, defaultFontFamily).colorScheme.surface,
        0.25,
      );

  @override
  bool useWhiteForeground(Color backgroundColor) =>
      1.05 / (backgroundColor.computeLuminance() + 0.05) > 2.5;

  @override
  Color getForegroundTextColour(Color backgroundColor) =>
      useWhiteForeground(backgroundColor) ? Colors.white : Colors.black;

  @override
  Color fabForegroundColourSelector(BuildContext context) => Colors.white;

  @override
  Color fabColourSelector(BuildContext context) =>
      getTheme(context).colorScheme.primary;

  @override
  Color buttonBackgroundColour(BuildContext context) =>
      getSecondaryColour(context);

  @override
  Color buttonForegroundColour(BuildContext context) => Colors.black;
}
