import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

class CustomMenuItem {
  Widget image;
  LocaleKey title;
  Function navigateTo;
  String navigateToNamed;
  String navigateToExternl;

  CustomMenuItem({
    this.image,
    this.title,
    this.navigateTo,
    this.navigateToNamed,
    this.navigateToExternl,
  });
}
