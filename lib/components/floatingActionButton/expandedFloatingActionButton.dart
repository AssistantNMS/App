import 'package:assistantapps_flutter_common/integration/dependencyInjection.dart';
import 'package:flutter/material.dart';

class FabItem {
  const FabItem(this.title, this.icon, {this.onPress});

  final IconData icon;
  final Function onPress;
  final String title;
}

class FabMenuItem extends StatelessWidget {
  const FabMenuItem(this.item, {Key key}) : super(key: key);

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

class ExpandedFabButton extends AnimatedWidget {
  const ExpandedFabButton({
    Key key,
    @required this.items,
    this.onPress,
    Animation animation,
  }) : super(key: key, listenable: animation);

  final List<FabItem> items;
  final Function onPress;

  get _animation => listenable;

  Widget buildItem(BuildContext context, int index) {
    final screenWidth = MediaQuery.of(context).size.width;

    final transform = Matrix4.translationValues(
      -(screenWidth - _animation.value * screenWidth) *
          ((items.length - index) / 4),
      0.0,
      0.0,
    );

    return Align(
      alignment: Alignment.centerRight,
      child: Transform(
        transform: transform,
        child: Opacity(
          opacity: _animation.value,
          child: FabMenuItem(items[index]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IgnorePointer(
          ignoring: _animation.value == 0,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(height: 9),
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: items.length,
            itemBuilder: buildItem,
          ),
        ),
        FloatingActionButton(
          backgroundColor: getTheme().fabColourSelector(context),
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            color: getTheme().fabForegroundColourSelector(context),
            progress: _animation,
          ),
          onPressed: onPress,
        ),
      ],
    );
  }
}
