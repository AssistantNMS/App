import 'package:flutter/cupertino.dart'
    show CupertinoThemeData, CupertinoTextThemeData;
import 'package:flutter/material.dart';

ThemeData getDynamicTheme(Brightness brightness, String fontFamily) {
  return darkTheme(fontFamily);
}

ThemeData darkTheme(String fontFamily) {
  final base = ThemeData.dark();
  final primary = Colors.indigo[300];
  final secondary = Colors.teal[200];
  return base.copyWith(
    primaryColor: primary,
    // accentColor: secondary, //DEPRECATED
    colorScheme: base.colorScheme.copyWith(
      primary: primary,
      secondary: secondary,
      secondaryContainer: secondary,
    ),
    textTheme: _buildAppTextTheme(base.textTheme, fontFamily),
    primaryTextTheme: _buildAppTextTheme(base.primaryTextTheme, fontFamily),
    // accentTextTheme: _buildAppTextTheme(base.accentTextTheme, fontFamily), //DEPRECATED
    iconTheme: IconThemeData(color: secondary),
    buttonTheme: ButtonThemeData(
      buttonColor: secondary,
      textTheme: ButtonTextTheme.primary,
    ),
    brightness: Brightness.dark,
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),
  );
}

TextTheme _buildAppTextTheme(TextTheme base, String fontFamily) {
  return base
      .copyWith(
        headlineSmall: base.headlineSmall.copyWith(fontWeight: FontWeight.w900),
        titleLarge: base.titleLarge.copyWith(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
        ),
        bodySmall: base.bodySmall.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),
      )
      .apply(fontFamily: fontFamily);
}

CupertinoThemeData toAppleTheme(ThemeData theme) {
  return CupertinoThemeData(
    brightness: theme.brightness,
    primaryColor: theme.primaryColor,
    primaryContrastingColor: theme.colorScheme.secondary,
    scaffoldBackgroundColor: theme.scaffoldBackgroundColor,
    // barBackgroundColor: theme.primaryColor,
    textTheme: toAppleTextTheme(theme),
  );
}

CupertinoTextThemeData toAppleTextTheme(ThemeData theme) {
  return CupertinoTextThemeData(
    // brightness: theme.brightness,
    primaryColor: theme.primaryColor,
    // actionTextStyle: const TextStyle(
    //   color: theme.accentColor,
    //   backgroundColor: theme.backgroundColor,
    // ),
    // textStyle: const TextStyle(
    //   color: theme.accentColor,
    //   backgroundColor: theme.backgroundColor,
    // )
  );
}
