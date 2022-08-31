import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/constants/AppImage.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

import '../../components/tilePresenters/youtubersTilePresenter.dart';

class NomNomInventorySyncTutorial extends StatelessWidget {
  const NomNomInventorySyncTutorial({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const iconFgColour = Colors.white;
    return IntroSlider(
      slides: [
        Slide(
          title: 'NomNom Inventory Sync!', // TODO translate
          centerWidget: Column(
            children: [
              localImage(AppImage.nomNom),
              emptySpace8x(),
              genericItemGroup('Step 1: Download and run NomNom'),
              flatCard(
                child: nomNomDownloadTile(context,
                    subtitle: 'Download from Github'), // TODO translate
              ),
              emptySpace3x(),
            ],
          ),
          colorBegin: getTheme().getScaffoldBackgroundColour(context),
          colorEnd: getTheme().getScaffoldBackgroundColour(context),
        ),
        Slide(
          title: 'NomNom Inventory Sync!', // TODO translate
          centerWidget: Column(
            children: [
              localImage(AppImage.nomNom),
              emptySpace8x(),
              genericItemGroup('Step 2: Generate a code'),
              genericItemGroup('<image>'),
              genericItemDescription(
                  '"Bases & Storage" > "Sync to AssistantNMS" > "Generate code"'),
              emptySpace3x(),
            ],
          ),
          colorBegin: getTheme().getScaffoldBackgroundColour(context),
          colorEnd: getTheme().getScaffoldBackgroundColour(context),
        ),
        Slide(
          title: 'NomNom Inventory Sync!', // TODO translate
          centerWidget: Column(
            children: [
              localImage(AppImage.nomNom),
              emptySpace8x(),
              genericItemGroup('Step 3: Enter the into the app'),
              genericItemGroup('<image>'),
              emptySpace3x(),
            ],
          ),
          colorBegin: getTheme().getScaffoldBackgroundColour(context),
          colorEnd: getTheme().getScaffoldBackgroundColour(context),
        ),
      ],
      renderSkipBtn: const Icon(Icons.skip_next, color: iconFgColour),
      renderNextBtn: const Icon(Icons.navigate_next, color: iconFgColour),
      renderDoneBtn: const Icon(Icons.done, color: iconFgColour),
      onDonePress: () => getNavigation().pop(context),
      colorDot: Colors.white,
      colorActiveDot: getTheme().getSecondaryColour(context),
      backgroundColorAllSlides: getTheme().getBackgroundColour(context),
    );
  }
}
