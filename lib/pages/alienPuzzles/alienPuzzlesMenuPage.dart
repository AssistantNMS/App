import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../constants/analytics_event.dart';
import '../../constants/app_image.dart';
import '../../contracts/alienPuzzle/alien_puzzle_type.dart';
import 'alienPuzzlesListPage.dart';

const double tileHeight = 145;

class AlienPuzzlesMenuPage extends StatelessWidget {
  AlienPuzzlesMenuPage({Key? key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.alienPuzzlesMenuPage);
  }

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.puzzles),
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    List<Widget> listItems = List.empty(growable: true);
    listItems.add(
      menuTile(
        context,
        AppImage.observatory,
        tileHeight,
        LocaleKey.observatory,
        '',
        [AlienPuzzleType.Observatory],
      ),
    );
    listItems.add(
      menuTile(
        context,
        AppImage.transmissionTower,
        tileHeight,
        LocaleKey.transmissionTower,
        'Cyberpunk2350',
        [AlienPuzzleType.RadioTower],
      ),
    );
    listItems.add(
      menuTile(
        context,
        AppImage.manufacturingFacility,
        tileHeight,
        LocaleKey.manufacturingFacility,
        '',
        [AlienPuzzleType.Harvester, AlienPuzzleType.Factory],
      ),
    );
    listItems.add(
      menuTile(
        context,
        AppImage.abandonedBuilding,
        tileHeight,
        LocaleKey.abandonedBuilding,
        'Cyberpunk2350',
        [AlienPuzzleType.AbandonedBuildings],
      ),
    );
    listItems.add(
      menuTile(
        context,
        AppImage.monolith,
        tileHeight,
        LocaleKey.monolith,
        'Cyberpunk2350',
        [AlienPuzzleType.Monolith],
      ),
    );
    listItems.add(
      menuTile(
        context,
        AppImage.plaque,
        tileHeight,
        LocaleKey.plaque,
        '',
        [AlienPuzzleType.Plaque],
      ),
    );
    listItems.add(
      menuTile(
        context,
        AppImage.stationCore,
        tileHeight,
        LocaleKey.stationCore,
        'Cyberpunk2350',
        [AlienPuzzleType.StationCore],
      ),
    );

    return gridWithScrollbar(
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      itemCount: listItems.length,
      itemBuilder: (BuildContext context, int index) => listItems[index],
      gridViewColumnCalculator: (dynamic br) => 2,
    );
  }
}

Widget menuTile(
    BuildContext context,
    String backgroundImage,
    double backgroundHeight,
    LocaleKey title,
    String userCredit,
    List<AlienPuzzleType> puzzleTypes) {
  return InkWell(
    child: Stack(children: [
      SizedBox(
        height: backgroundHeight,
        width: double.infinity,
        child: Image.asset(
          backgroundImage,
          fit: BoxFit.cover,
        ),
      ),
      if (userCredit.isNotEmpty) ...[
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            child: GenericItemDescription(userCredit),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
              ),
              color: Color.fromRGBO(0, 0, 0, 0.65),
            ),
          ),
        ),
      ],
      Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(
          color: const Color.fromRGBO(0, 0, 0, 0.75),
          child: GenericItemName(getTranslations().fromKey(title)),
        ),
      ),
    ]),
    onTap: () => getNavigation().navigateAsync(
      context,
      navigateTo: (_) => AlienPuzzlesListPage(
        puzzleTypes: puzzleTypes,
        title: title,
      ),
    ),
  );
}
