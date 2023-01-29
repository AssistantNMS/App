// ignore_for_file: prefer_function_declarations_over_variables

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/generated/communitySpotlightViewModel.dart';

Widget communitySpotlightTilePresenter(
  BuildContext context,
  CommuntySpotlightViewModel communitySpotlight, {
  void Function()? onTap,
}) {
  Function() localOnTap =
      onTap ?? () => launchExternalURL(communitySpotlight.externalUrl);
  Row userInfoNameAndImageRow = Row(
    children: (communitySpotlight.userName.length > 1)
        ? [
            ClipOval(
              child: ImageFromNetwork(
                  imageUrl: communitySpotlight.userImage,
                  height: 50,
                  width: 50),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                communitySpotlight.userName,
                maxLines: 1,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ]
        : [],
  );
  Widget userInfo = (communitySpotlight.externalUrl.length < 5)
      ? userInfoNameAndImageRow
      : Stack(
          children: [
            userInfoNameAndImageRow,
            Positioned(
              child: IconButton(
                icon: const Icon(Icons.open_in_new, size: 32),
                onPressed: localOnTap,
              ),
              top: 0,
              right: 8,
              bottom: 0,
            ),
          ],
        );

  List<Widget> descripWidgets = List.empty(growable: true);
  if (communitySpotlight.title.length > 1) {
    descripWidgets.add(Padding(
      child: Text(
        communitySpotlight.title,
        textAlign: TextAlign.left,
        style: const TextStyle(fontSize: 18),
        maxLines: 1,
      ),
      padding: const EdgeInsets.only(bottom: 4),
    ));
  }
  if (communitySpotlight.subtitle.length > 1) {
    descripWidgets.add(Text(
      communitySpotlight.subtitle,
      textAlign: TextAlign.center,
      maxLines: 5,
    ));
  }

  List<Widget> columnWidgets = List.empty(growable: true);
  columnWidgets.add(userInfo);
  if (descripWidgets.isNotEmpty) {
    columnWidgets.add(customDivider());
    columnWidgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: descripWidgets,
        ),
      ),
    );
  }
  return GestureDetector(
    child: Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        children: [
          if (communitySpotlight.previewImageUrl.length > 5) ...[
            ImageFromNetwork(
              imageUrl: communitySpotlight.previewImageUrl,
              boxfit: BoxFit.fitWidth,
            ),
          ],
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, bottom: 16),
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
    onTap: localOnTap,
  );
  // return genericListTileWithNetworkImage(
  //     context,
  //     imageUrl: communitySpotlight.userImage,
  //     name: communitySpotlight.userName,
  //     subtitle: (communitySpotlight.subtitle != null &&
  //             communitySpotlight.subtitle.isNotEmpty)
  //         ? Text(
  //             communitySpotlight.subtitle,
  //             maxLines: 1,
  //             overflow: TextOverflow.ellipsis,
  //           )
  //         : null,
  //     onTap: () => launchExternalURL(communitySpotlight.externalUrl),
  //   );
}
