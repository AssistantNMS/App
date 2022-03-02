import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

Widget translatorTilePresenter(BuildContext context,
        TranslatorLeaderboardItemViewModel contributor, int index) =>
    genericListTileWithNetworkImage(
      context,
      imageUrl: contributor.profileImageUrl,
      name: contributor.username,
      subtitle: Text(
        '{0} points'.replaceAll("{0}", contributor.total.toString()),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        '# ${(index + 1).toString()}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
