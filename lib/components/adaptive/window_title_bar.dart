import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/constants/app_image.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/cupertino.dart' show ObstructingPreferredSizeWidget;
import 'package:flutter/material.dart';

import '../windows_buttons.dart';

class WindowTitleBar extends StatelessWidget
    implements PreferredSizeWidget, ObstructingPreferredSizeWidget {
  final String title;
  final List<ActionItem>? actions;
  @override
  final Size preferredSize;
  final dynamic bottom;
  final Color? backgroundColor;
  static const double kMinInteractiveDimensionCupertino = 44.0;

  WindowTitleBar(
    this.title, {
    Key? key,
    this.bottom,
    this.backgroundColor,
    this.actions,
  })  : preferredSize = Size.fromHeight(
            kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
      child: Container(
        color: getTheme().getScaffoldBackgroundColour(context),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: LocalImage(
                imagePath: AppImage.assistantNMSWindowIcon,
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            Expanded(
              child: MoveWindow(
                child: Center(
                  child: Row(
                    children: [
                      GenericItemDescription(title),
                    ],
                  ),
                ),
              ),
            ),
            const WindowButtons(),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldFullyObstruct(BuildContext context) => true;
}
