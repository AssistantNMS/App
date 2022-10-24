import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

import '../../components/tilePresenters/youtubersTilePresenter.dart';
import '../../constants/AppImage.dart';

class NomNomInventorySyncTutorial extends StatelessWidget {
  const NomNomInventorySyncTutorial({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const iconFgColour = Colors.white;
    return IntroSlider(
      listContentConfig: [
        ContentConfig(
          title: 'Step 1', // TODO translate
          centerWidget: Column(
            children: [
              localImage(AppImage.nomNom),
              emptySpace8x(),
              genericItemGroup('Download and run NomNom'),
              flatCard(
                child: nomNomDownloadTile(
                  context,
                  subtitle: 'Download from Github',
                ), // TODO translate
              ),
              emptySpace3x(),
            ],
          ),
          colorBegin: getTheme().getScaffoldBackgroundColour(context),
          colorEnd: getTheme().getScaffoldBackgroundColour(context),
        ),
        ContentConfig(
          title: 'Step 2', // TODO translate
          centerWidget: Column(
            children: [
              genericItemGroup('Open up the menu in NomNom'),
              tutorialImage(
                context,
                title: 'Step 2',
                icon: AppImage.nomnomIntroStep2,
              ),
              // genericItemDescription(
              //   '"Bases & Storage" > "Sync to AssistantNMS" > "Generate code"',
              // ),
              emptySpace3x(),
            ],
          ),
          colorBegin: getTheme().getScaffoldBackgroundColour(context),
          colorEnd: getTheme().getScaffoldBackgroundColour(context),
        ),
        ContentConfig(
          title: 'Step 3', // TODO translate
          centerWidget: Column(
            children: [
              genericItemGroup(
                  'Select the inventory to sync and generate the code'),
              tutorialImage(
                context,
                title: 'Step 3',
                icon: AppImage.nomnomIntroStep3,
              ),
              emptySpace3x(),
            ],
          ),
          colorBegin: getTheme().getScaffoldBackgroundColour(context),
          colorEnd: getTheme().getScaffoldBackgroundColour(context),
        ),
        ContentConfig(
          title: 'Step 4', // TODO translate
          centerWidget: Column(
            children: [
              genericItemGroup('Enter the code into the app'),
              localImage(AppImage.nomnomIntroStep4),
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
      indicatorConfig: IndicatorConfig(
        colorIndicator: Colors.white,
        colorActiveIndicator: getTheme().getSecondaryColour(context),
      ),
      backgroundColorAllTabs: getTheme().getBackgroundColour(context),
    );
  }

  Widget tutorialImage(
    context, {
    String title,
    String icon,
  }) {
    return GestureDetector(
      child: Container(
        child: localImage(icon),
        margin: const EdgeInsets.all(4.0),
      ),
      onTap: () => getNavigation().navigateAsync(
        context,
        navigateTo: (context) => ImageViewerPage(
          title,
          icon,
          analyticsKey: '',
        ),
      ),
    );
  }
}
