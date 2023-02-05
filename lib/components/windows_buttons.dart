import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color hoverColour = getTheme().getSecondaryColour(context);
    Color textColour = getTheme().getTextColour(context);
    Color textHoverColour = getTheme().getForegroundTextColour(hoverColour);

    WindowButtonColors buttonColors = WindowButtonColors(
      mouseOver: hoverColour,
      mouseDown: hoverColour,
      iconNormal: textColour,
      iconMouseOver: textHoverColour,
    );

    WindowButtonColors closeButtonColors = WindowButtonColors(
      mouseOver: HexColor('E81123'),
      mouseDown: HexColor('E81123'),
      iconNormal: textColour,
      iconMouseOver: textHoverColour,
    );

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
