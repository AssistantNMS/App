import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:breakpoint/breakpoint.dart';

import '../../constants/routes.dart';
import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/fishing_page_tile_presenter.dart';
import '../../constants/app_image.dart';

class FishingPageLink {
  FishingPageLink({
    required this.route,
    required this.imgPath,
    required this.name,
    required this.colour,
  });

  String route;
  String imgPath;
  String name;
  String colour;
}

List<FishingPageLink> pageLinks = [
  FishingPageLink(
    route: Routes.fishingBait,
    imgPath: AppImage.fishingBait,
    colour: '095C77',
    name: getTranslations().fromKey(LocaleKey.fishingBait),
  ),
  FishingPageLink(
    route: Routes.fishingGgfBait,
    imgPath: AppImage.goodGuysFree,
    colour: '095C77',
    name: getTranslations().fromKey(LocaleKey.fishingBait) + ' (GoodGuysFree)',
  ),
  FishingPageLink(
    route: Routes.fishingLocations,
    imgPath: AppImage.fishingLocation,
    colour: 'F3A923',
    name: getTranslations().fromKey(LocaleKey.fishingLocation),
  )
];

class FishingPage extends StatelessWidget {
  const FishingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.fishing),
      body: SearchableGrid<FishingPageLink>(
        () => Future.value(ResultWithValue(true, pageLinks, '')),
        gridItemDisplayer: fishingPageLinkTilePresenter,
        gridViewColumnCalculator: (breakpoint) {
          if (breakpoint.window == WindowSize.medium) return 2;
          if (breakpoint.window == WindowSize.large) return 3;
          if (breakpoint.window == WindowSize.xlarge) return 4;

          return 1;
        },
        key: Key(getTranslations().currentLanguage),
        hintText: getTranslations().fromKey(LocaleKey.searchItems),
        addFabPadding: true,
        minListForSearch: 1000,
      ),
    );
  }
}
