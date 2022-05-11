import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

ActionItem goHomeAction(BuildContext context) {
  return ActionItem(
    icon: Icons.home,
    text: 'Home page',
    onPressed: () async => await getNavigation().navigateHomeAsync(context),
  );
}
