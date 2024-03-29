import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../constants/app_duration.dart';
import '../../constants/modal.dart';
import '../../constants/nms_ui_constants.dart';
import '../../contracts/redux/app_state.dart';
import '../../redux/modules/setting/share_view_model.dart';
import '../common/row_helper.dart';

const shareableAppLink = 'https://app.nmsassistant.com/link{0}/{1}.html';

class ShareBottomSheet extends StatefulWidget {
  final String itemId;
  final String itemName;
  const ShareBottomSheet({
    Key? key,
    required this.itemId,
    required this.itemName,
  }) : super(key: key);

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
          String nameParam = (widget.itemName).replaceAllMapped(
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
        widgets.add(const EmptySpace2x());
        widgets.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                displayLink,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ));
        widgets.add(const EmptySpace1x());
        widgets.add(
          rowWith2Columns(
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(getTranslations().fromKey(LocaleKey.shareForceLanguage)),
                getBaseWidget().adaptiveCheckbox(
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
                Text(getTranslations().fromKey(LocaleKey.shareIncludeName)),
                getBaseWidget().adaptiveCheckbox(
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
        widgets.add(getBaseWidget().customDivider());
        widgets.add(ListTile(
          leading: const Icon(Icons.share),
          title: Text(getTranslations().fromKey(LocaleKey.copyToClipboard)),
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
          title: Text(getTranslations().fromKey(LocaleKey.shareOpenLink)),
          onTap: () => launchExternalURL(fullLink),
        ));

        if (isAndroid || isiOS) {
          widgets.add(ListTile(
            leading: const Icon(Icons.interests_outlined),
            title: Text(getTranslations().fromKey(LocaleKey.shareOpenMenu)),
            onTap: () async {
              await getNavigation().pop(context);
              shareTextManual(fullLink);
            },
          ));
        }

        widgets.add(const EmptySpace8x());

        return AnimatedSize(
          duration: AppDuration.modal,
          child: Container(
            constraints: modalSmallHeightSize(context),
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
