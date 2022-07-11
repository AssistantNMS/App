import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/generated/communityLinkChipColourViewModel.dart';
import '../../contracts/generated/communityLinkViewModel.dart';
import '../../helpers/communityLinkHelper.dart';
import '../../pages/community/communityLinksDetailsPage.dart';

Widget Function(
    BuildContext, CommunityLinkViewModel) communityLinkTilePresenter(
  List<CommunityLinkChipColourViewModel> chipColours,
) =>
    (BuildContext context, CommunityLinkViewModel communityLink) {
      return ListTile(
        leading: Hero(
          key: Key(communityLink.id),
          tag: communityLink.id,
          child: networkImage(
            handleCommunitySearchIcon(communityLink.icon),
            boxfit: BoxFit.cover,
            height: 50.0,
            width: 50.0,
          ),
        ),
        title: Text(
          communityLink.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: (communityLink.desc != null && communityLink.desc.isNotEmpty)
            ? Text(
                communityLink.desc,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        onTap: () => getNavigation().navigateAwayFromHomeAsync(
          context,
          navigateTo: (_) => CommunityLinksDetailsPage(
            communityLink,
            chipColours,
          ),
        ),
      );
    };
