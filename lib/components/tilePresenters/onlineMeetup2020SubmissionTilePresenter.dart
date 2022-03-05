import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/generated/onlineMeetup2020SubmissionViewModel.dart';

Widget onlineMeetup2020SubmissionTilePresenter(
    BuildContext context, OnlineMeetup2020SubmissionViewModel submission) {
  Function() onTap;
  onTap = () => launchExternalURL(submission.externalUrl);
  Row userInfoNameAndImageRow = Row(
    mainAxisSize: MainAxisSize.max,
    children: (submission.userName != null && submission.userName.length > 1)
        ? [
            ClipOval(
              child: networkImage(submission.userImage, height: 50, width: 50),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                submission.userName,
                maxLines: 1,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ]
        : [],
  );
  Widget userInfo =
      (submission.externalUrl == null || submission.externalUrl.length < 5)
          ? userInfoNameAndImageRow
          : Stack(
              children: [
                userInfoNameAndImageRow,
                Positioned(
                  child: IconButton(
                    icon: const Icon(Icons.open_in_new, size: 36),
                    onPressed: onTap,
                  ),
                  top: 0,
                  right: 8,
                  bottom: 0,
                ),
              ],
            );

  List<Widget> columnWidgets = List.empty(growable: true);
  columnWidgets.add(userInfo);
  if (submission.text != null && submission.text.length > 1) {
    columnWidgets.add(customDivider());
    columnWidgets.add(Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            submission.text,
            textAlign: TextAlign.left,
            maxLines: 10,
          ),
        ],
      ),
    ));
  }
  return GestureDetector(
    child: Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        children: [
          if (submission.imageUrl != null &&
              submission.imageUrl.length > 5) ...[
            networkImage(submission.imageUrl, boxfit: BoxFit.fitWidth),
          ],
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: columnWidgets,
            ),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
    ),
    onTap: onTap,
  );
}
