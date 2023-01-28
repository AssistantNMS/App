import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import '../../components/tilePresenters/communityLinkTilePresenter.dart';
import '../../contracts/generated/communityLinkChipColourViewModel.dart';
import '../../contracts/generated/communityLinkViewModel.dart';
import '../../helpers/communityLinkHelper.dart';

const double bannerHeight = 225;

class CommunityLinksDetailsPage extends StatelessWidget {
  final CommunityLinkViewModel communityLink;
  final List<CommunityLinkChipColourViewModel> chipColours;
  const CommunityLinksDetailsPage(this.communityLink, this.chipColours,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getBaseWidget().appScaffold(
      context,
      appBar: getBaseWidget().appBarForSubPage(
        context,
        title: Text(communityLink.name),
        showHomeAction: true,
        showBackAction: true,
      ),
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext bodyCtx) {
    List<Widget> widgets = List.empty(growable: true);

    if (communityLink.banners.isEmpty) {
      Widget linkIcon = Hero(
        key: Key(communityLink.id),
        tag: communityLink.id,
        child: ImageFromNetwork(
          imageUrl: handleCommunitySearchIcon(communityLink.icon),
          boxfit: BoxFit.cover,
          width: 50,
        ),
      );

      widgets.add(const EmptySpace1x());
      widgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [linkIcon],
      ));
    } else if (communityLink.banners.length < 2) {
      widgets.add(
        ImageFromNetwork(
          imageUrl: handleCommunitySearchIcon(communityLink.banners[0]),
          boxfit: BoxFit.fitWidth,
          width: double.infinity,
        ),
      );
    } else {
      widgets.add(
        ImageSlideshow(
          width: double.infinity,
          height: bannerHeight,
          initialPage: 0,
          indicatorColor: getTheme().getSecondaryColour(bodyCtx),
          indicatorBackgroundColor:
              getTheme().getScaffoldBackgroundColour(bodyCtx),
          children: communityLink.banners
              .map(
                (banner) => ImageFromNetwork(
                  imageUrl: handleCommunitySearchIcon(banner),
                  boxfit: BoxFit.fitWidth,
                  width: double.infinity,
                ),
              )
              .toList(),
          isLoop: true,
        ),
      );
    }

    widgets.add(const EmptySpace1x());
    widgets.add(GenericItemDescription(communityLink.desc));
    widgets.add(const EmptySpace1x());

    List<Widget> linkChildren = List.empty(growable: true);
    for (String link in communityLink.links) {
      linkChildren.add(renderSingleLink(bodyCtx, link));
    }

    widgets.add(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: linkChildren,
      ),
    ));
    widgets.add(const EmptySpace1x());

    List<Widget> wrapChildren = List.empty(growable: true);
    for (String tag in communityLink.tags) {
      wrapChildren.add(communityTag(tag, chipColours));
    }

    widgets.add(Wrap(alignment: WrapAlignment.center, children: wrapChildren));
    widgets.add(const EmptySpace(10));

    return listWithScrollbar(
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
      scrollController: ScrollController(),
    );
  }
}
