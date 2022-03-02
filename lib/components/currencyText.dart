import 'package:flutter/material.dart';

import '../helpers/currencyHelper.dart';

class CurrencyText extends StatelessWidget {
  final TextStyle style;
  final String numberString;
  final TextAlign textAlign;
  final TextOverflow overflow;

  const CurrencyText(
    this.numberString, {
    Key key,
    this.style,
    this.textAlign,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      currencyFormat(numberString),
      textAlign: textAlign,
      style: style,
      overflow: overflow,
    );
  }
}
