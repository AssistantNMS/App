import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

Widget randomPortalFAB(
  BuildContext fabCtx, {
  required bool isDisabled,
  required void Function() startRoll,
  required void Function() copyCode,
}) {
  Color foregroundColor = getTheme().fabForegroundColourSelector(fabCtx);
  Color backgroundColor = getTheme().fabColourSelector(fabCtx);
  if (isDisabled) {
    return const RandomPortalFABLoader();
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      FloatingActionButton(
        child: const Icon(Icons.copy),
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        onPressed: () => copyCode(),
        heroTag: 'copy-portalcode',
      ),
      const SizedBox(height: 10, width: 10),
      FloatingActionButton(
        child: const Icon(Icons.refresh),
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        onPressed: () => startRoll(),
        heroTag: 'reroll-portals',
      ),
    ],
  );
}

class RandomPortalFABLoader extends StatefulWidget {
  const RandomPortalFABLoader({Key? key}) : super(key: key);

  @override
  createState() => _RandomPortalFABLoaderState();
}

class _RandomPortalFABLoaderState extends State<RandomPortalFABLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color foregroundColor = getTheme().fabForegroundColourSelector(context);
    Color backgroundColor = getTheme().fabColourSelector(context);

    return FloatingActionButton(
      foregroundColor: foregroundColor.withOpacity(0.5),
      backgroundColor: backgroundColor.withOpacity(0.5),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * math.pi,
            child: const Icon(Icons.refresh),
          );
        },
      ),
      onPressed: () {},
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
