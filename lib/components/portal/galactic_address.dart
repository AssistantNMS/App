import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../helpers/hex_helper.dart';

Widget galacticAddress(
  BuildContext context,
  List<int> currentCodes, {
  bool hideTextHeading = false,
  void Function(String)? onCopy,
}) {
  List<Widget> widgets = List.empty(growable: true);
  void Function() onTap = () {};
  const textStyle = TextStyle(fontSize: 20);
  if (currentCodes.length == 12) {
    List<String> hexCodes = intArrayToHexArray(currentCodes);
    String section1Code = getCodeForSection(hexCodes, 1, 2047, 4096);
    String section2Code = getCodeForSection(hexCodes, 2, 127, 256);
    String section3Code = getCodeForSection(hexCodes, 3, 2047, 4096);
    String section4Code = padBy4String(getHexForSection(hexCodes, 4));

    if ((int.tryParse(section4Code, radix: 16) ?? 0) > 767) {
      widgets.add(Text(
        getTranslations().fromKey(LocaleKey.galacticAddressInvalid),
        style: textStyle,
      ));
    } else {
      String gAddr = allUpperCase(
        '$section1Code:$section2Code:$section3Code:$section4Code',
      );
      widgets.add(Text(gAddr, style: textStyle));
      if (onCopy != null) {
        onTap = () => onCopy(gAddr);
        widgets.add(
          IconButton(icon: const Icon(Icons.content_copy), onPressed: onTap),
        );
      }
    }
  } else {
    widgets.add(Text(
      getTranslations().fromKey(LocaleKey.galacticAddressInvalid),
      style: textStyle,
    ));
  }

  return GestureDetector(
    child: Column(children: [
      if (hideTextHeading == false) ...[
        Text(getTranslations().fromKey(LocaleKey.galacticAddress)),
      ],
      Row(mainAxisAlignment: MainAxisAlignment.center, children: widgets)
    ]),
    onTap: onTap,
  );
}

String getCodeForSection(List<String> hexCodes, int section, int add, int mod) {
  String sectionHex = getHexForSection(hexCodes, section);
  int intFromHex = int.tryParse(sectionHex, radix: 16) ?? 0;
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

ResultWithValue<String> portalCodesFromGalacticAddress(
  BuildContext context,
  String galAddrPlanetIndex,
  String galAddrA,
  String galAddrB,
  String galAddrC,
  String galAddrD,
) {
  try {
// Invalid
    var inValidList = [
      int.parse(galAddrA, radix: 16) > 4096,
      int.parse(galAddrA, radix: 16) < 0,
      int.parse(galAddrB, radix: 16) > 255,
      int.parse(galAddrB, radix: 16) < 0,
      int.parse(galAddrC, radix: 16) > 4096,
      int.parse(galAddrC, radix: 16) < 0,
      int.parse(galAddrD, radix: 16) > 767,
      int.parse(galAddrD, radix: 16) < 0,
    ];

    if (inValidList.contains(true)) {
      return ResultWithValue<String>(
        false,
        getTranslations().fromKey(LocaleKey.galacticAddressInvalid),
        '',
      );
    }

    // A
    int sectionAValueStep1 = int.parse(galAddrA, radix: 16);
    int sectionAValueStep2 = ((sectionAValueStep1 + 2049) % 4096).abs();
    String sectionAValueStep3 = sectionAValueStep2.round().toRadixString(16);
    String sectionAValueStep4 = padString(sectionAValueStep3, 3);

    // B
    int sectionBValueStep1 = int.parse(galAddrB, radix: 16);
    int sectionBValueStep2 = ((sectionBValueStep1 + 129) % 256).abs();
    String sectionBValueStep3 = sectionBValueStep2.toRadixString(16);
    String sectionBValueStep4 = padString(sectionBValueStep3, 2);

    // C
    int sectionCValueStep1 = int.parse(galAddrC, radix: 16);
    int sectionCValueStep2 = ((sectionCValueStep1 + 2049) % 4096).abs();
    String sectionCValueStep3 = sectionCValueStep2.toRadixString(16);
    String sectionCValueStep4 = padString(sectionCValueStep3, 3);

    // D
    String sectionDValueStep1 = galAddrD.substring(1);

    String portalAddr = int.parse(galAddrPlanetIndex).toString() +
        sectionDValueStep1 +
        sectionBValueStep4 +
        sectionCValueStep4 +
        sectionAValueStep4;

    return ResultWithValue<String>(true, allUpperCase(portalAddr), '');
  } catch (_) {
    return ResultWithValue<String>(
      false,
      getTranslations().fromKey(LocaleKey.galacticAddressInvalid),
      '',
    );
  }
}
