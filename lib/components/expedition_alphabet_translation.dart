import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:avatar_glow/avatar_glow.dart';

import 'package:flutter/material.dart';

import '../constants/fonts.dart';

class ExpeditionAlphabetTranslation extends StatefulWidget {
  final String text;
  const ExpeditionAlphabetTranslation(this.text, {Key? key}) : super(key: key);
  @override
  createState() => _ExpeditionAlphabetTranslationWidget();
}

class _ExpeditionAlphabetTranslationWidget
    extends State<ExpeditionAlphabetTranslation> with TickerProviderStateMixin {
  bool _reveal = false;

  @override
  Widget build(BuildContext context) {
    TextStyle? currentFont =
        getThemeSubtitle(context)?.copyWith(color: Colors.black);
    TextStyle? expeditionFont =
        currentFont?.copyWith(fontFamily: nmsExpeditionFontFamily);

    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: GestureDetector(
        child: AvatarGlow(
          glowRadiusFactor: 0.2,
          child: getBaseWidget().appChip(
            key: Key(_reveal.toString()),
            text: widget.text,
            style: _reveal ? currentFont : expeditionFont,
            backgroundColor: Colors.white,
          ),
        ),
        onTap: () => setState(() {
          _reveal = !_reveal;
        }),
      ),
    );
  }
}
