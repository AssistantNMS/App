import 'dart:async';
import 'dart:math';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../constants/Fonts.dart';
import '../helpers/theme_helper.dart';

class ExpeditionAlphabetTranslationAnimated extends StatefulWidget {
  final String text;
  const ExpeditionAlphabetTranslationAnimated(this.text, {Key? key})
      : super(key: key);
  @override
  createState() => _ExpeditionAlphabetTranslationAnimatedWidget();
}

class _ExpeditionAlphabetTranslationAnimatedWidget
    extends State<ExpeditionAlphabetTranslationAnimated>
    with TickerProviderStateMixin {
  late Timer _timer;
  int _counter = 0;
  final Random _rng = Random();

  @override
  initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), handleTimeout);
  }

  void handleTimeout(timer) {
    setState(() {
      _counter += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? currentFont =
        getThemeSubtitle(context)?.copyWith(color: Colors.black);
    TextStyle? expeditionFont =
        currentFont?.copyWith(fontFamily: nmsExpeditionFontFamily);

    TextSpan content = TextSpan(
      style: currentFont,
      children: widget.text
          .split('')
          .map((char) {
            bool shoExpFont = _rng.nextInt(100) > 25;
            TextStyle? styleToUse = shoExpFont ? expeditionFont : currentFont;
            return Text(char, style: styleToUse);
          })
          .toList()
          .map((charWidget) {
            return WidgetSpan(
              child: SizedBox(
                width: 18,
                child: Center(child: charWidget),
              ),
            );
          })
          .toList(),
    );

    return Padding(
      child: getBaseWidget().appChip(
        label: RichText(
          key: Key(_counter.toString()),
          text: content,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 4),
    );
  }

  @override
  void dispose() {
    if (_timer.isActive) _timer.cancel();
    super.dispose();
  }
}
