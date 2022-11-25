// ignore_for_file: no_logic_in_create_state

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart'
    hide ExternalUrls;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';

import '../../components/portal/galacticAddress.dart';
import '../../components/portal/portalGlyphList.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../constants/NmsExternalUrls.dart';
import '../../contracts/portal/portalRecord.dart';
import '../../contracts/redux/appState.dart';
import '../../helpers/genericHelper.dart';
import '../../helpers/hexHelper.dart';
import '../../redux/modules/portal/portalViewModel.dart';
import 'addPortalPage.dart';

class ViewPortalPage extends StatefulWidget {
  final PortalRecord item;
  const ViewPortalPage(this.item, {Key key}) : super(key: key);

  @override
  createState() => _ViewPortalPageState(item);
}

class _ViewPortalPageState extends State<ViewPortalPage> {
  PortalRecord item;

  _ViewPortalPageState(this.item) {
    getAnalytics().trackEvent(AnalyticsEvent.viewPortalPage);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PortalViewModel>(
      converter: (store) => PortalViewModel.fromStore(store),
      builder: (_, portalViewModel) => basicGenericPageScaffold(
        context,
        title: item.name,
        body: getBody(context, portalViewModel),
        fab: FloatingActionButton(
          onPressed: () async {
            PortalRecord temp =
                await getNavigation().navigateAsync<PortalRecord>(
              context,
              navigateTo: (context) => AddPortalPage(item, isEdit: true),
            );
            if (temp == null || temp is! PortalRecord) return;
            portalViewModel.editPortal(
                temp.name, temp.codes, temp.tags, temp.uuid);
            setState(() {
              item = temp;
            });
          },
          heroTag: 'ViewPortalPage',
          child: const Icon(Icons.edit),
          foregroundColor: getTheme().fabForegroundColourSelector(context),
          backgroundColor: getTheme().fabColourSelector(context),
        ),
      ),
    );
  }

  Widget getBody(
    BuildContext scaffoldContext,
    PortalViewModel portalViewModel,
  ) {
    List<Widget> widgets = List.empty(growable: true);
    widgets.add(twoLinePortalGlyphList(
      item.codes,
      useAltGlyphs: portalViewModel.useAltGlyphs,
    ));

    String hexString = allUpperCase(intArrayToHex(item.codes));
    widgets.add(GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(hexString, style: const TextStyle(fontSize: 20)),
          IconButton(
            icon: const Icon(Icons.content_copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: hexString));
              getSnackbar().showSnackbar(
                scaffoldContext,
                LocaleKey.coordinatesCopied,
                description: hexString,
              );
            },
          )
        ],
      ),
    ));

    if (item.tags != null && item.tags.isNotEmpty) {
      widgets.add(Wrap(
        alignment: WrapAlignment.center,
        children: item.tags.map((tag) => genericChip(context, tag)).toList(),
      ));
    }

    // String dateString = (item.date != null && item.date.length > 10)
    //     ? item.date.substring(0, 10)
    //     : item.date ?? '';
    // widgets.add(Padding(
    //   padding: const EdgeInsets.only(top: 8, bottom: 12),
    //   child: genericItemGroup(dateString),
    // ));

    widgets.add(emptySpace3x());

    void Function(String gAddress) onCopy;
    onCopy = (String gAddress) {
      Clipboard.setData(ClipboardData(text: gAddress));
      getSnackbar().showSnackbar(
        scaffoldContext,
        LocaleKey.galacticAddressCopied,
        description: gAddress,
      );
    };
    widgets.add(galacticAddress(context, item.codes, onCopy: onCopy));

    String url = NmsExternalUrls.nmsPortals + hexString;
    Future Function() onTap;
    onTap = () => launchExternalURL(url);
    widgets.add(GestureDetector(
      child: Chip(
        label: const Text('nmsportals.github.io'),
        deleteIcon: const Icon(Icons.open_in_new),
        onDeleted: onTap,
      ),
      onTap: onTap,
    ));

    widgets.add(emptySpace8x());

    return listWithScrollbar(
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
    );
  }
}
