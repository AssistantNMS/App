import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../constants/Fonts.dart';

class ExpeditionAlphabetTranslationAnimated extends StatefulWidget {
  final String text;
  const ExpeditionAlphabetTranslationAnimated(this.text, {Key key})
      : super(key: key);
  @override
  _ExpeditionAlphabetTranslationAnimatedWidget createState() =>
      // ignore: no_logic_in_create_state
      _ExpeditionAlphabetTranslationAnimatedWidget(text);
}

class _ExpeditionAlphabetTranslationAnimatedWidget
    extends State<ExpeditionAlphabetTranslationAnimated>
    with TickerProviderStateMixin {
  final String text;
  Timer _timer;
  int _counter = 0;
  final Random _rng = Random();

  _ExpeditionAlphabetTranslationAnimatedWidget(this.text);

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
    TextStyle currentFont =
        Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.black);
    TextStyle expeditionFont =
        currentFont.copyWith(fontFamily: nmsExpeditionFontFamily);

    TextSpan content = TextSpan(
      style: currentFont,
      children: text
          .split('')
          .map((char) {
            bool shoExpFont = _rng.nextInt(100) > 25;
            TextStyle styleToUse = shoExpFont ? expeditionFont : currentFont;
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
      child: Chip(
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
    if (_timer != null && _timer.isActive) _timer.cancel();
    super.dispose();
  }
}
