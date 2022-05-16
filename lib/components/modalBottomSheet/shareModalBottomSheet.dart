import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../constants/AppDuration.dart';
import '../../constants/Modal.dart';
import '../../constants/NmsUIConstants.dart';
import '../../contracts/redux/appState.dart';
import '../../redux/modules/setting/shareViewModel.dart';
import '../common/rowHelper.dart';

const shareableAppLink = 'https://app.nmsassistant.com/link{0}/{1}.html';

class ShareBottomSheet extends StatefulWidget {
  final String itemId;
  final String itemName;
  const ShareBottomSheet({Key key, this.itemId, this.itemName})
      : super(key: key);

  @override
  _ShareBottomSheetState createState() => _ShareBottomSheetState();
}

class _ShareBottomSheetState extends State<ShareBottomSheet> {
  bool forceLang = false;
  bool includeName = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ShareViewModel>(
      converter: (store) => ShareViewModel.fromStore(store),
      builder: (BuildContext storeContext, viewModel) {
        String selectedLang = '/' + viewModel.selectedLanguage;
        if (viewModel.selectedLanguage == 'en') selectedLang = '';

        String baseUrl = shareableAppLink
            .replaceAll('{0}', selectedLang)
            .replaceAll('{1}', widget.itemId);

        List<String> params = List.empty(growable: true);
        if (forceLang) {
          params.add('lang=${viewModel.selectedLanguage}');
        }
        if (includeName) {
          String nameParam = (widget.itemName ?? '').replaceAllMapped(
            RegExp(r'/\s/g'),
            (_) => '-',
          );
          params.add(nameParam);
        }
        String paramString =
            (params.isNotEmpty) ? ('?' + params.join('&')) : '';
        String fullLink = '$baseUrl$paramString';
        String displayLink = fullLink.replaceAll('https://', '');

        List<Widget> widgets = List.empty(growable: true);
        widgets.add(emptySpace2x());
        widgets.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              displayLink,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ));
        widgets.add(emptySpace1x());
        widgets.add(
          rowWith2Columns(
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Force language'), // TODO translate
                adaptiveCheckbox(
                  value: forceLang,
                  onChanged: (bool newValue) {
                    setState(() {
                      forceLang = newValue;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Include name'), // TODO translate
                adaptiveCheckbox(
                  value: includeName,
                  onChanged: (bool newValue) {
                    setState(() {
                      includeName = newValue;
                    });
                  },
                ),
              ],
            ),
          ),
        );
        widgets.add(customDivider());
        widgets.add(ListTile(
          leading: const Icon(Icons.share),
          title: const Text('Copy to clipboard'), // TODO translate
          onTap: () {
            Clipboard.setData(ClipboardData(text: fullLink));
            getSnackbar().showSnackbar(
              storeContext,
              LocaleKey.share,
              description: displayLink,
              onNegative: () async {
                await getNavigation().pop(context);
                await getNavigation().pop(context);
              },
            );
          },
        ));
        widgets.add(ListTile(
          leading: const Icon(Icons.open_in_new),
          title: const Text('Open link'), // TODO translate
          onTap: () => launchExternalURL(fullLink),
        ));

        if (isAndroid || isiOS) {
          widgets.add(ListTile(
            leading: const Icon(Icons.interests_outlined),
            title: const Text('Open share menu'), // TODO translate
            onTap: () => shareTextManual(fullLink),
          ));
        }

        widgets.add(emptySpace8x());

        return AnimatedSize(
          duration: AppDuration.modal,
          child: Container(
            constraints: modalDefaultSize(context),
            child: ListView.builder(
              padding: NMSUIConstants.buttonPadding,
              itemCount: widgets.length,
              itemBuilder: (_, int index) => widgets[index],
              shrinkWrap: true,
            ),
          ),
        );
      },
    );
  }
}
