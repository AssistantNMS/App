import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../helpers/currency_helper.dart';

class CurrencyText extends StatelessWidget {
  final TextStyle? style;
  final String numberString;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final bool addDecimal;

  const CurrencyText(
    this.numberString, {
    Key? key,
    this.style,
    this.textAlign,
    this.overflow,
    this.addDecimal = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      currencyFormat(numberString, addDecimal: addDecimal),
      textAlign: textAlign,
      style: style ??
          getThemeBodyLarge(context)?.copyWith(
            color: Colors.black,
          ),
      overflow: overflow,
    );
  }
}
