import 'package:assistantapps_flutter_common/integration/dependency_injection.dart';
import 'package:flutter/material.dart';

class FabItem {
  const FabItem(
    this.title,
    this.icon, {
    this.onPress,
  });

  final IconData icon;
  final void Function()? onPress;
  final String title;
}

class FabMenuItem extends StatelessWidget {
  const FabMenuItem(this.item, {Key? key}) : super(key: key);

  final FabItem item;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: const StadiumBorder(),
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 24, right: 16),
      color: getTheme().fabForegroundColourSelector(context),
      splashColor: Colors.grey.withOpacity(0.1),
      highlightColor: Colors.grey.withOpacity(0.1),
      elevation: 0,
      highlightElevation: 2,
      disabledColor: getTheme().fabForegroundColourSelector(context),
      onPressed: item.onPress,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(item.title),
          const SizedBox(width: 8),
          Icon(item.icon, color: getTheme().fabColourSelector(context)),
        ],
      ),
    );
  }
}
