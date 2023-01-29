import 'dart:math';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../../contracts/redux/app_state.dart';
import '../../../redux/modules/setting/introViewModel.dart';

class Valentines2020 extends StatelessWidget {
  const Valentines2020({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> availableImages = List.empty(growable: true);
    String prefix = getPath().imageAssetPathPrefix;
    availableImages.add('$prefix/special/valentinesCard1.jpg');
    availableImages.add('$prefix/special/valentinesCard2.jpg');
    availableImages.add('$prefix/special/valentinesCard3.jpg');
    var index = Random.secure().nextInt(availableImages.length);
    String selectedImage = availableImages[index];

    String url = 'https://www.reddit.com/r/NMS_GalacticCorporate/';
    Future Function() gotToFunc;
    gotToFunc = () => launchExternalURL(url);

    return basicGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.valentines),
      actions: [goHomeAction(context)],
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
            GestureDetector(
              child: getBaseWidget().appChip(
                label: const Text('NMS_GalacticCorporate'),
                backgroundColor: Colors.transparent,
                deleteIcon: const Icon(Icons.open_in_new),
                onDeleted: gotToFunc,
              ),
              onTap: gotToFunc,
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
