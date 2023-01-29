import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

TextStyle? getThemeSubtitle(BuildContext ctx) =>
    getTheme().getTheme(ctx).textTheme.titleMedium;

TextStyle? getThemeBodyLarge(BuildContext ctx) =>
    getTheme().getTheme(ctx).primaryTextTheme.bodyLarge;

TextStyle? getThemeBodyMedium(BuildContext ctx) =>
    getTheme().getTheme(ctx).primaryTextTheme.bodyMedium;

TextStyle? getThemeBodySmall(BuildContext ctx) =>
    getTheme().getTheme(ctx).primaryTextTheme.bodyLarge;
