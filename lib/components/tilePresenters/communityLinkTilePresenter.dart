import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/generated/communityLinkViewModel.dart';

Widget communityLinkTilePresenter(
        BuildContext context, CommunityLinkViewModel communityLink) =>
    genericListTileWithNetworkImage(
      context,
      imageUrl: communityLink.iconUrl,
      name: communityLink.name,
      subtitle:
          (communityLink.subtitle != null && communityLink.subtitle.isNotEmpty)
              ? Text(
                  communityLink.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
      onTap: () => launchExternalURL(communityLink.externalUrl),
    );
