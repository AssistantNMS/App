import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/generated/community_link_chip_colour_view_model.dart';
import '../../contracts/generated/community_link_view_model.dart';
import '../../helpers/community_link_helper.dart';
import '../../pages/community/community_links_details_page.dart';

ListItemDisplayerType<CommunityLinkViewModel> communityLinkTilePresenter(
  List<CommunityLinkChipColourViewModel> chipColours,
) {
  return (
    BuildContext ctx,
    CommunityLinkViewModel item, {
    void Function()? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: GestureDetector(
        child: Card(
          child: Column(
            children: [
              Row(
                children: [
                  Hero(
                    key: Key(item.id),
                    tag: item.id,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                      ),
                      child: ImageFromNetwork(
                        imageUrl: handleCommunitySearchIcon(item.icon),
                        boxfit: BoxFit.cover,
                        height: 50.0,
                        width: 50.0,
                      ),
                    ),
                  ),
                  const EmptySpace1x(),
                  Expanded(
                    child: Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              if ((item.desc).isNotEmpty) ...[
                const Divider(height: 2),
                const EmptySpace1x(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GenericItemDescription(
                    item.desc,
                    maxLines: 2,
                  ),
                ),
              ],
              const EmptySpace1x(),
              const Divider(height: 2),
              Wrap(
                alignment: WrapAlignment.center,
                children: item.tags
                    .map((tag) => communityTag(tag, chipColours))
                    .toList(),
              ),
              const EmptySpace(0.25),
            ],
          ),
        ),
        onTap: () => getNavigation().navigateAwayFromHomeAsync(
          ctx,
          navigateTo: (_) => CommunityLinksDetailsPage(
            item,
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
    child: getBaseWidget().appChip(
      label: Text(tag, style: const TextStyle(color: Colors.black)),
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      elevation: 5,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      shadowColor: Colors.black,
      backgroundColor: handleTagColour(tag, chipColours),
    ),
  );
}
