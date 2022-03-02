import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

Widget shortcutActionButton(context, List<ActionItem> actions) =>
    _androidShortcutActionButton(context, actions);

Widget shortcutPresenter(context, ActionItem action) => Row(
      children: [
        action.image ?? Icon(action.icon),
        const SizedBox(width: 10),
        Text(
          action.text,
          style: TextStyle(
            color: getTheme().getIsDark(context) ? Colors.white : Colors.black,
          ),
        ),
      ],
    );

Widget _androidShortcutActionButton(context, List<ActionItem> actions) {
  if (actions.length == 1) {
    return actionItemToAndroidAction(actions)[0];
  }
  return PopupMenuButton<Function>(
    onSelected: (Function func) {
      if (func != null) func();
    },
    icon: const Icon(Icons.link),
    itemBuilder: (BuildContext context) => actions
        .map((action) => PopupMenuItem<Function>(
              value: action.onPressed,
              child: shortcutPresenter(context, action),
            ))
        .toList(),
  );
}
