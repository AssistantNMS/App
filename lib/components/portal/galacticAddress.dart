import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../helpers/hexHelper.dart';

Widget galacticAddress(
    BuildContext context, List<int> currentCodes, Function(String) onCopy) {
  List<Widget> widgets = List.empty(growable: true);
  Function() onTap;
  if (currentCodes.length == 12) {
    List<String> hexCodes = intArrayToHexArray(currentCodes);
    String section1Code = getCodeForSection(hexCodes, 1, 2047, 4096);
    String section2Code = getCodeForSection(hexCodes, 2, 127, 256);
    String section3Code = getCodeForSection(hexCodes, 3, 2047, 4096);
    String section4Code = padBy4String(getHexForSection(hexCodes, 4));

    const textStyle = TextStyle(fontSize: 20);
    if (int.tryParse(section4Code, radix: 16) > 767) {
      widgets.add(Text(
        getTranslations().fromKey(LocaleKey.galacticAddressInvalid),
        style: textStyle,
      ));
    } else {
      var gAddr = '$section1Code:$section2Code:$section3Code:$section4Code';
      onTap = () => onCopy(gAddr);
      widgets.add(Text(gAddr, style: textStyle));
      widgets.add(
        IconButton(icon: const Icon(Icons.content_copy), onPressed: onTap),
      );
    }
  }

  return GestureDetector(
    child: Column(children: [
      Text(getTranslations().fromKey(LocaleKey.galacticAddress)),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: widgets)
    ]),
    onTap: onTap,
  );
}

String getCodeForSection(List<String> hexCodes, int section, int add, int mod) {
  String sectionHex = getHexForSection(hexCodes, section);
  int intFromHex = int.tryParse(sectionHex, radix: 16);
  String modifiedHex = intCodeToHexString(intFromHex, add, mod);
  String padded = padBy4String(modifiedHex);
  return padded;
}

String getHexForSection(List<String> hexCodes, int section) {
  String codeString = '0';
  if (section == 1) {
    codeString = hexCodes[9] + hexCodes[10] + hexCodes[11];
  } else if (section == 2) {
    codeString = hexCodes[4] + hexCodes[5];
  } else if (section == 3) {
    codeString = hexCodes[6] + hexCodes[7] + hexCodes[8];
  } else if (section == 4) {
    codeString = hexCodes[1] + hexCodes[2] + hexCodes[3];
  }
  return codeString;
}

String intCodeToHexString(int code, int add, int mod) {
  int addValue = code + add;
  int modvalue = addValue % mod;
  int absModValue = modvalue.abs();
  String absHexString = absModValue.toRadixString(16);
  return allUpperCase(absHexString);
}

String padBy4String(String input) => padString(input, 4);
