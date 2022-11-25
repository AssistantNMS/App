import 'package:avatar_glow/avatar_glow.dart';

import 'package:flutter/material.dart';

import '../constants/Fonts.dart';
import '../helpers/themeHelper.dart';

class ExpeditionAlphabetTranslation extends StatefulWidget {
  final String text;
  const ExpeditionAlphabetTranslation(this.text, {Key key}) : super(key: key);
  @override
  _ExpeditionAlphabetTranslationWidget createState() =>
      // ignore: no_logic_in_create_state
      _ExpeditionAlphabetTranslationWidget(text);
}

class _ExpeditionAlphabetTranslationWidget
    extends State<ExpeditionAlphabetTranslation> with TickerProviderStateMixin {
  final String text;
  bool _reveal = false;

  _ExpeditionAlphabetTranslationWidget(this.text);

  @override
  Widget build(BuildContext context) {
    TextStyle currentFont =
        getThemeSubtitle(context).copyWith(color: Colors.black);
    TextStyle expeditionFont =
        currentFont.copyWith(fontFamily: nmsExpeditionFontFamily);

    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: GestureDetector(
        child: AvatarGlow(
          endRadius: 30.0,
          child: Chip(
            key: Key(_reveal.toString()),
            label: Text(text, style: _reveal ? currentFont : expeditionFont),
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
