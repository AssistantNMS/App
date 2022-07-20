import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/NmsExternalUrls.dart';
import '../contracts/generated/communityLinkChipColourViewModel.dart';

String handleCommunitySearchIcon(String icon) {
  String imageUrl = icon;
  bool isRemote = imageUrl.contains('https://') || //
      imageUrl.contains('http://');

  if (isRemote == false) {
    imageUrl = NmsExternalUrls.communitySearchHomepage + icon;
  }
  return imageUrl;
}

Color handleTagColour(
  String text,
  List<CommunityLinkChipColourViewModel> chipColours,
) {
  CommunityLinkChipColourViewModel foundItem = chipColours.firstWhere(
      (cc) => cc.name.toLowerCase() == text.toLowerCase(),
      orElse: () => null);

  if (foundItem == null) return HexColor('#e5e5e5');
  return HexColor(foundItem.colour);
}

Widget renderSingleLink(BuildContext linkContext, String link) {
  String localLink = link;
  String cleanLink = 'Unsupported link';
  String linkComment = '';

  RegExp markdownLinkRegex = RegExp(r'^\[(.+)\]\((.+)\)');
  List<RegExpMatch> markdownRegexArr =
      markdownLinkRegex.allMatches(link).toList();
  if (markdownRegexArr != null &&
      markdownRegexArr.isNotEmpty &&
      markdownRegexArr[0].groupCount > 1) {
    linkComment = '(${markdownRegexArr[0].group(1).toString()})';
    localLink = markdownRegexArr[0].group(2).toString();
  }

  RegExp linkRegex =
      RegExp('^(?:https?://)?(?:[^@/\n]+@)?(?:www.)?([^:/?\n]+)');
  String preCleanLink = localLink
      .replaceAll('https://', '')
      .replaceAll('http://', '')
      .replaceAll('www.', '')
      .replaceAll('/index.html', '')
      .replaceAll('.html', '');
  List<RegExpMatch> regexArr = linkRegex.allMatches(preCleanLink).toList();
  cleanLink =
      ((regexArr?.length ?? 0) > 0) ? regexArr[0].group(0) : preCleanLink;

  double fontSize = 18;
  return GestureDetector(
    child: Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            cleanLink,
            style: TextStyle(
              color: getTheme().getSecondaryColour(linkContext),
              fontSize: fontSize,
            ),
          ),
          if (linkComment.isNotEmpty) ...[
            Text(
              ' ' + linkComment,
              style: TextStyle(
                color: Colors.grey,
                fontSize: fontSize,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    ),
    onTap: () => launchExternalURL(localLink),
    onLongPress: () {
      Clipboard.setData(ClipboardData(text: localLink));
      getSnackbar().showSnackbar(
        linkContext,
        LocaleKey.copyToClipboard,
        description: localLink,
        onNegative: () async {
          await getNavigation().pop(linkContext);
        },
      );
    },
  );
}
