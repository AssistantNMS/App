// ignore_for_file: prefer_function_declarations_over_variables

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../contracts/generated/friend_code_view_model.dart';

Widget friendCodeTilePresenter(
  BuildContext context,
  FriendCodeViewModel friendCode,
) {
  String imagePath = 'link.png';
  if (friendCode.platformType == 1) imagePath = 'platformPc.png';
  if (friendCode.platformType == 2) imagePath = 'platformPs4.png';
  if (friendCode.platformType == 3) imagePath = 'platformXb1.png';

  onTap() {
    Clipboard.setData(ClipboardData(text: friendCode.code));
    getSnackbar().showSnackbar(
      context,
      LocaleKey.friendCodeCopied,
      description: friendCode.code,
    );
  }

  return genericListTileWithSubtitle(
    context,
    leadingImage: imagePath,
    name: friendCode.name,
    subtitle: Text(
      friendCode.code,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    trailing: IconButton(
      icon: Icon(Icons.copy, color: getTheme().getSecondaryColour(context)),
      onPressed: onTap,
    ),
    onTap: onTap,
  );
}
