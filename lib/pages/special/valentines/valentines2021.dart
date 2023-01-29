import 'dart:math';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../../constants/HomepageItems.dart';
import '../../../contracts/redux/appState.dart';
import '../../../redux/modules/setting/introViewModel.dart';

class Valentines2021 extends StatelessWidget {
  const Valentines2021({Key? key}) : super(key: key);

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
              child:
                  LocalImage(imagePath: selectedImage, boxfit: BoxFit.fitWidth),
              margin: const EdgeInsets.all(0),
            ),
            Container(
              child: Center(
                child: Text(
                  "#${index + 1}",
                  style: const TextStyle(fontStyle: FontStyle.italic),
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
                style: const TextStyle(fontSize: 20),
              ),
              margin: const EdgeInsets.all(4.0),
            ),
            PositiveButton(
              title: getTranslations().fromKey(LocaleKey.noticeAccept),
              padding: const EdgeInsets.symmetric(vertical: 8),
              onTap: () async => await getNavigation().navigateAsync(
                context,
                navigateToNamed: HomepageItem.getByType(
                  introViewModel.homepageType,
                ).routeToNamed,
              ),
            ),
            NegativeButton(
              title: getTranslations().fromKey(LocaleKey.noticeReject),
              padding: const EdgeInsets.symmetric(vertical: 8),
              onTap: () async {
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
            padding: const EdgeInsets.all(12),
            itemCount: widgets.length,
            itemBuilder: (BuildContext context, int index) => widgets[index],
            scrollController: ScrollController(),
          );
        },
      ),
    );
  }
}
