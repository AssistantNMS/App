import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

class CustomMenuItem {
  Widget image;
  LocaleKey title;
  Widget Function(BuildContext context)? navigateTo;
  String? navigateToNamed;
  String? navigateToExternal;

  CustomMenuItem({
    required this.image,
    required this.title,
    this.navigateTo,
    this.navigateToNamed,
    this.navigateToExternal,
  });
}
