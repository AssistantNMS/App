import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/generated/communityLinkChipColourViewModel.dart';
import '../../contracts/generated/communityLinkViewModel.dart';
import '../../helpers/communityLinkHelper.dart';
import '../../pages/community/communityLinksDetailsPage.dart';

Widget Function(BuildContext, CommunityLinkViewModel)
    communityLinkTilePresenter(
  List<CommunityLinkChipColourViewModel> chipColours,
) {
  return (BuildContext context, CommunityLinkViewModel communityLink) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
      child: GestureDetector(
        child: Card(
          child: Column(
            children: [
              Row(
                children: [
                  Hero(
                    key: Key(communityLink.id),
                    tag: communityLink.id,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                      ),
                      child: networkImage(
                        handleCommunitySearchIcon(communityLink.icon),
                        boxfit: BoxFit.cover,
                        height: 50.0,
                        width: 50.0,
                      ),
                    ),
                  ),
                  emptySpace1x(),
                  Expanded(
                    child: Text(
                      communityLink.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              if ((communityLink.desc ?? '').isNotEmpty) ...[
                const Divider(height: 2),
                emptySpace1x(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: genericItemDescription(
                    communityLink.desc ?? '',
                    maxLines: 2,
                  ),
                ),
              ],
              emptySpace1x(),
              const Divider(height: 2),
              Wrap(
                alignment: WrapAlignment.center,
                children: communityLink.tags
                    .map((tag) => communityTag(tag, chipColours))
                    .toList(),
              ),
              emptySpace(0.25),
            ],
          ),
        ),
        onTap: () => getNavigation().navigateAwayFromHomeAsync(
          context,
          navigateTo: (_) => CommunityLinksDetailsPage(
            communityLink,
            chipColours,
          ),
        ),
      ),
    );
  };
}

Widget communityTag(
    String tag, List<CommunityLinkChipColourViewModel> chipColours) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: Chip(
      label: Text(tag, style: const TextStyle(color: Colors.black)),
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      elevation: 5,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      shadowColor: Colors.black,
      backgroundColor: handleTagColour(tag, chipColours),
    ),
  );
}
