import 'dart:math';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../../constants/HomepageItems.dart';
import '../../../contracts/redux/appState.dart';
import '../../../redux/modules/setting/introViewModel.dart';

class Valentines2021 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> availableImages = List.empty(growable: true);
    String prefix = getPath().imageAssetPathPrefix;
    availableImages.add('$prefix/special/valentinesCard1.png');
    availableImages.add('$prefix/special/valentinesCard2.png');
    availableImages.add('$prefix/special/valentinesCard3.png');
    var index = Random.secure().nextInt(availableImages.length);
    String selectedImage = availableImages[index];

    return basicGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.valentines),
      showBackAction: false,
      showHomeAction: false,
      body: StoreConnector<AppState, IntroViewModel>(
        converter: (store) => IntroViewModel.fromStore(store),
        builder: (_, introViewModel) {
          var widgets = [
            Container(
              child: localImage(selectedImage, boxfit: BoxFit.fitWidth),
              margin: const EdgeInsets.all(0),
            ),
            Container(
              child: Center(
                child: Text(
                  "#${index + 1}",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              margin: const EdgeInsets.all(4.0),
            ),
            Container(
              child: Text(
                getTranslations().fromKey(LocaleKey.noticeContent),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
                style: TextStyle(fontSize: 20),
              ),
              margin: const EdgeInsets.all(4.0),
            ),
            positiveButton(
              title: getTranslations().fromKey(LocaleKey.noticeAccept),
              colour: getTheme().getSecondaryColour(context),
              padding: EdgeInsets.symmetric(vertical: 8),
              onPress: () async => await getNavigation().navigateAsync(
                context,
                navigateToNamed: HomepageItem.getByType(
                  introViewModel.homepageType,
                ).routeToNamed,
              ),
            ),
            negativeButton(
              title: getTranslations().fromKey(LocaleKey.noticeReject),
              padding: EdgeInsets.symmetric(vertical: 8),
              onPress: () async {
                introViewModel.hideValentines2021Intro();
                await getNavigation().navigateHomeAsync(
                  context,
                  navigateToNamed: HomepageItem.getByType(
                    introViewModel.homepageType,
                  ).routeToNamed,
                  pushReplacement: true,
                );
              },
            ),
          ];
          return listWithScrollbar(
            shrinkWrap: true,
            padding: EdgeInsets.all(12),
            itemCount: widgets.length,
            itemBuilder: (BuildContext context, int index) => widgets[index],
          );
        },
      ),
    );
  }
}
