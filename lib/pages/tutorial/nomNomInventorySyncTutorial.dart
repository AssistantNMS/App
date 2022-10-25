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
    var listContentConfig = [
      ContentConfig(
        title: getTranslations() //
            .fromKey(LocaleKey.stepNum)
            .replaceAll('{0}', '1'),
        centerWidget: Column(
          children: [
            localImage(AppImage.nomNom),
            emptySpace8x(),
            genericItemGroup(
              getTranslations().fromKey(LocaleKey.downloadNomNom),
            ),
            flatCard(
              child: nomNomDownloadTile(
                context,
                subtitle: getTranslations() //
                    .fromKey(LocaleKey.downloadFromGithub),
              ),
            ),
            emptySpace3x(),
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
            genericItemGroup(getTranslations().fromKey(LocaleKey.nomNomStep2)),
            tutorialImage(
              context,
              title: getTranslations()
                  .fromKey(LocaleKey.stepNum)
                  .replaceAll('{0}', '2'),
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
        title:
            getTranslations().fromKey(LocaleKey.stepNum).replaceAll('{0}', '3'),
        centerWidget: Column(
          children: [
            genericItemGroup(getTranslations().fromKey(LocaleKey.nomNomStep3)),
            tutorialImage(
              context,
              title: getTranslations().fromKey(LocaleKey.nomNomStep3),
              icon: AppImage.nomnomIntroStep3,
            ),
            emptySpace3x(),
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
            genericItemGroup(getTranslations().fromKey(LocaleKey.nomNomStep4)),
            localImage(AppImage.nomnomIntroStep4),
            emptySpace3x(),
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
