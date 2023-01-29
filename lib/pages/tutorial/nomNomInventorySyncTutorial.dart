import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

import '../../components/tilePresenters/youtubers_tile_presenter.dart';
import '../../constants/app_image.dart';

class NomNomInventorySyncTutorial extends StatelessWidget {
  const NomNomInventorySyncTutorial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const iconFgColour = Colors.white;
    var listContentConfig = [
      ContentConfig(
        title: getTranslations() //
            .fromKey(LocaleKey.stepNum)
            .replaceAll('{0}', '1'),
        centerWidget: Column(
          children: [
            const LocalImage(imagePath: AppImage.nomNom),
            const EmptySpace8x(),
            GenericItemGroup(
              getTranslations().fromKey(LocaleKey.downloadNomNom),
            ),
            FlatCard(
              child: nomNomDownloadTile(
                context,
                subtitle: getTranslations() //
                    .fromKey(LocaleKey.downloadFromGithub),
              ),
            ),
            const EmptySpace3x(),
          ],
        ),
        colorBegin: getTheme().getScaffoldBackgroundColour(context),
        colorEnd: getTheme().getScaffoldBackgroundColour(context),
      ),
      ContentConfig(
        title:
            getTranslations().fromKey(LocaleKey.stepNum).replaceAll('{0}', '2'),
        centerWidget: Column(
          children: [
            GenericItemGroup(getTranslations().fromKey(LocaleKey.nomNomStep2)),
            tutorialImage(
              context,
              title: getTranslations()
                  .fromKey(LocaleKey.stepNum)
                  .replaceAll('{0}', '2'),
              icon: AppImage.nomnomIntroStep2,
            ),
            // GenericItemDescription(
            //   '"Bases & Storage" > "Sync to AssistantNMS" > "Generate code"',
            // ),
            const EmptySpace3x(),
          ],
        ),
        colorBegin: getTheme().getScaffoldBackgroundColour(context),
        colorEnd: getTheme().getScaffoldBackgroundColour(context),
      ),
      ContentConfig(
        title:
            getTranslations().fromKey(LocaleKey.stepNum).replaceAll('{0}', '3'),
        centerWidget: Column(
          children: [
            GenericItemGroup(getTranslations().fromKey(LocaleKey.nomNomStep3)),
            tutorialImage(
              context,
              title: getTranslations().fromKey(LocaleKey.nomNomStep3),
              icon: AppImage.nomnomIntroStep3,
            ),
            const EmptySpace3x(),
          ],
        ),
        colorBegin: getTheme().getScaffoldBackgroundColour(context),
        colorEnd: getTheme().getScaffoldBackgroundColour(context),
      ),
      ContentConfig(
        title:
            getTranslations().fromKey(LocaleKey.stepNum).replaceAll('{0}', '4'),
        centerWidget: Column(
          children: [
            GenericItemGroup(getTranslations().fromKey(LocaleKey.nomNomStep4)),
            const LocalImage(imagePath: AppImage.nomnomIntroStep4),
            const EmptySpace3x(),
          ],
        ),
        colorBegin: getTheme().getScaffoldBackgroundColour(context),
        colorEnd: getTheme().getScaffoldBackgroundColour(context),
      ),
    ];
    return IntroSlider(
      listContentConfig: listContentConfig,
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
    required String title,
    required String icon,
  }) {
    return GestureDetector(
      child: Container(
        child: LocalImage(imagePath: icon),
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
