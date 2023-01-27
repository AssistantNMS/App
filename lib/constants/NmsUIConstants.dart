// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class NMSUIConstants {
  static const int ReleaseNotesDescripNumLines = 3;
  static const String DateFormat = 'yyyy-MM-dd';
  static const String DateTimeFormat = 'yyyy-MM-dd HH:mm';
  static const String FeedbackAnswerDefault = '...';
  static ShapeBorder noBorderRadius =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(0));
  static const int DonationsPageSize = 20;
  static const String PatreonHex = 'FF424D';
  static const String ObsoleteAppId = 'tech16';
  static BorderRadius gameItemBorderRadius = BorderRadius.circular(4.0);
  static BorderRadius generalBorderRadius = BorderRadius.circular(12.0);
  static EdgeInsets buttonPadding = const EdgeInsets.symmetric(horizontal: 12);
}
