import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/AppImage.dart';
import '../../contracts/data/platformControlMapping.dart';

const String paleYellowColourClass = 'C9D68B';
const String goldColourClass = 'B09857';
const String darkRedColourClass = 'AE615E';
const String paleBlueColourClass = '83BCDB';
const String greenColourClass = 'AADE9B';
const String purpleColourClass = 'B0A5DD';
const String offWhiteColourClass = 'F5F5F5';
const String orangeColourClass = 'F3A923';
const String redColourClass = 'C03022';

String getColourValueFromTag(String tag) {
  switch (tag.toUpperCase()) {
    case 'IMG':
      return redColourClass;

    case 'EARTH':
    case 'TITLE':
    case 'TRANS_EXP':
    case 'TEMPERATURE':
    case 'TECHNOLOGY':
    case 'TECHNOLOLY':
      return paleBlueColourClass;

    case 'TRANS_TRA':
    case 'TRADEABLE':
      return greenColourClass;

    case 'TRANS_WAR':
    case 'WARNING':
      return darkRedColourClass;

    case 'FUEL':
      return redColourClass;
    case 'STELLAR':
      return paleYellowColourClass;
    case 'COMMODITY':
      return goldColourClass;
    case 'SPECIAL':
      return purpleColourClass;
    case 'VAL_ON':
      return offWhiteColourClass;
    case 'CATALYST':
      return orangeColourClass;
  }

  return '';
}

InlineSpan renderNode(BuildContext context, String colour, String wordChain) {
  TextStyle textStyle = (colour != null && colour.length == 6)
      ? TextStyle(color: HexColor(colour))
      : Theme.of(context).textTheme.subtitle1;

  return TextSpan(text: wordChain, style: textStyle);
}

List<Widget> genericPageDescripHighlightText(BuildContext context, String text,
    List<PlatformControlMapping> controlLookup) {
  RegExp doubleTagRegex = RegExp(r'<\w+>(<\w+>(\w+\s*)*<>)<>');
  RegExp tagStartRegex = RegExp(r'(.*)<(\w+)>(.*)');
  RegExp tagEndRegex = RegExp(r'(.*)<>(.*)');

  String currentColourValue = '';
  List<RichText> paragraphNodes = List.empty(growable: true);
  if (!text.contains('<>')) return [genericItemDescription(text)];

  List<String> paragraphs = text.split(RegExp(r'\r?\n'));
  for (var paragraphIndex = 0;
      paragraphIndex < paragraphs.length;
      paragraphIndex++) {
    String paragraph = paragraphs[paragraphIndex];
    if (paragraph.length < 2) continue;

    String wordChain = '';
    List<InlineSpan> nodes = List.empty(growable: true);
    List<String> words = paragraph.split(' ');
    for (int wordIndex = 0; wordIndex < words.length; wordIndex++) {
      String word = words[wordIndex];
      String displayWord = word;
      String localTag = '<unused>';
      String leftOverDisplayWordFront = '';
      String leftOverDisplayWord = '';

      List<RegExpMatch> doubleMatches =
          doubleTagRegex.allMatches(word).toList();
      if (doubleMatches != null &&
          doubleMatches.isNotEmpty &&
          doubleMatches[0].groupCount > 0) {
        word = doubleMatches[0].group(1);
      }

      var startMatches = tagStartRegex.allMatches(word).toList();
      if (startMatches != null &&
          startMatches.length == 1 &&
          startMatches[0].groupCount == 3) {
        leftOverDisplayWordFront = startMatches[0].group(1);
        displayWord = startMatches[0].group(3);
        localTag = '<' + startMatches[0].group(2) + '>';
        currentColourValue = getColourValueFromTag(startMatches[0].group(2));
      }

      List<RegExpMatch> endMatches = tagEndRegex.allMatches(word).toList();
      bool hasEndMatch = endMatches != null &&
          endMatches.length == 1 &&
          endMatches[0].groupCount >= 2;
      if (hasEndMatch) {
        displayWord = (endMatches[0].group(1) ?? '').replaceAll(localTag, '');
      }
      if (endMatches != null &&
          endMatches.length == 1 &&
          endMatches[0].groupCount >= 2) {
        leftOverDisplayWord = endMatches[0].group(2) + ' ';
      }

      if (currentColourValue.length > 1) {
        if (wordChain.length > 1) {
          nodes.add(renderNode(context, '', wordChain));
        }
        if (leftOverDisplayWordFront.isNotEmpty) {
          nodes.add(renderNode(context, '', leftOverDisplayWordFront));
        }
        if (localTag == '<IMG>') {
          String lookupKey =
              displayWord.replaceAll('(', '').replaceAll(')', '');
          String imagePath = AppImage.controlUnknown;
          PlatformControlMapping lookupResult = controlLookup
              .firstWhere((cl) => cl.key == lookupKey, orElse: () => null);
          if (lookupResult == null ||
              lookupResult.icon == null ||
              lookupResult.icon.isEmpty) {
            lookupResult = controlLookup.firstWhere(
                (cl) => cl.key.contains(lookupKey),
                orElse: () => null);
          }

          if (lookupResult != null &&
              lookupResult.icon != null &&
              lookupResult.icon.isNotEmpty) {
            imagePath = '${AppImage.controls}${lookupResult.icon}';
          }
          nodes.add(WidgetSpan(
              child: localImage(
            imagePath,
            height: 18,
            padding: const EdgeInsets.symmetric(horizontal: 4),
          )));
        } else {
          nodes.add(renderNode(context, currentColourValue,
              displayWord + ((leftOverDisplayWord.isNotEmpty) ? '' : ' ')));
        }
        if (leftOverDisplayWord.isNotEmpty) {
          nodes.add(renderNode(context, '', leftOverDisplayWord));
        }
        wordChain = '';
      } else {
        wordChain += displayWord + ' ';
      }

      if (hasEndMatch) {
        currentColourValue = '';
      }
    }
    if (wordChain.length > 1) {
      nodes.add(renderNode(context, '', wordChain));
    }

    paragraphNodes.add(
      RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.subtitle1,
          children: nodes,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  return paragraphNodes
      .map((para) => Padding(
            padding: const EdgeInsets.all(4),
            child: para,
          ))
      .toList();
}
