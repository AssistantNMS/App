import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/data/socialItem.dart';

Widget socialLinkTilePresenter(BuildContext context, SocialItem socialItem) =>
    ListTile(
      leading: localImage(
        '${getPath().imageAssetPathPrefix}/${socialItem.icon}',
        padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0),
      ),
      title: Text(
        socialItem.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => launchExternalURL(socialItem.link),
    );
