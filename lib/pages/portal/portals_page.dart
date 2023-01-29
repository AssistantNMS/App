import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/portal_tile_presenter.dart';
import '../../constants/analytics_event.dart';
import '../../constants/routes.dart';
import '../../contracts/portal/portal_record.dart';
import '../../contracts/redux/app_state.dart';
import '../../helpers/search_helpers.dart';
import '../../redux/modules/portal/portalViewModel.dart';
import 'add_portal_page.dart';
import 'view_portal_page.dart';

class PortalsPage extends StatefulWidget {
  const PortalsPage({Key? key}) : super(key: key);

  @override
  createState() => _PortalsPageState();
}

class _PortalsPageState extends State<PortalsPage> {
  int _counter = 0;
  _PortalsPageState() {
    getAnalytics().trackEvent(AnalyticsEvent.portalPage);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PortalViewModel>(
      converter: (store) => PortalViewModel.fromStore(store),
      builder: (_, portalViewModel) => basicGenericPageScaffold(
        context,
        title: getTranslations().fromKey(LocaleKey.savedPortalCoordinates),
        actions: [
          ActionItem(
            icon: Icons.screen_rotation_alt_rounded,
            onPressed: () => getNavigation().navigateAwayFromHomeAsync(
              context,
              navigateToNamed: Routes.portalConverter,
            ),
          )
        ],
        body: getBody(context, portalViewModel),
        fab: getFab(context, portalViewModel),
      ),
    );
  }

  Widget getFab(BuildContext fabCtx, PortalViewModel portalViewModel) {
    Color foregroundColor = getTheme().fabForegroundColourSelector(fabCtx);
    Color backgroundColor = getTheme().fabColourSelector(fabCtx);
    return FloatingActionButton(
      onPressed: () async {
        PortalRecord currentRecord = PortalRecord(
          codes: List.empty(growable: true),
          tags: List.empty(growable: true),
        );
        PortalRecord? temp = await getNavigation().navigateAsync<PortalRecord>(
          context,
          navigateTo: (context) => AddPortalPage(currentRecord),
        );
        if (temp == null) return;
        portalViewModel.addPortal(temp.name ?? '...', temp.codes, temp.tags);
        setState(() {
          _counter++;
        });
      },
      heroTag: 'PortalsPage',
      child: const Icon(Icons.add),
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
    );
  }

  Widget getBody(BuildContext context, PortalViewModel portalViewModel) {
    return SearchableList<PortalRecord>(
      getSearchListFutureFromList(portalViewModel.portals),
      listItemDisplayer: (BuildContext context, PortalRecord portal,
              {void Function()? onTap}) =>
          portalTilePresenter(
        context,
        portal,
        useAltGlyphs: portalViewModel.useAltGlyphs,
        onTap: () => onLocalTap(portal),
        onEdit: () => onEdit(portal, portalViewModel),
        onDelete: () => onDelete(portal, portalViewModel),
      ),
      listItemSearch: searchPortal,
      deleteAll: () => deleteAll(portalViewModel),
      key: Key(
        'numItems: ${portalViewModel.portals.length.toString()} counter: $_counter useAltGlyphs: ${portalViewModel.useAltGlyphs}',
      ),
      minListForSearch: 5,
    );
  }

  void onLocalTap(PortalRecord portal) async {
    await getNavigation().navigateAsync(
      context,
      navigateTo: (context) => ViewPortalPage(portal),
    );
    setState(() {
      _counter++;
    });
  }

  void onEdit(PortalRecord portal, PortalViewModel portalViewModel) async {
    PortalRecord? temp = await getNavigation().navigateAsync<PortalRecord>(
      context,
      navigateTo: (context) => AddPortalPage(portal, isEdit: true),
    );
    if (temp == null) return;
    portalViewModel.editPortal(
      temp.name ?? '...',
      temp.codes,
      temp.tags,
      temp.uuid,
    );
    setState(() {
      _counter++;
    });
  }

  void onDelete(PortalRecord portal, PortalViewModel portalViewModel) {
    getDialog().showSimpleDialog(
      context,
      getTranslations().fromKey(LocaleKey.delete),
      Text(getTranslations().fromKey(LocaleKey.areYouSure)),
      buttonBuilder: (BuildContext ctx) => [
        getDialog().simpleDialogCloseButton(ctx),
        getDialog().simpleDialogPositiveButton(
          ctx,
          title: LocaleKey.yes,
          onTap: () {
            portalViewModel.removePortal(portal.uuid);
            getNavigation().pop(ctx);
          },
        ),
      ],
    );
  }

  void deleteAll(PortalViewModel portalViewModel) {
    getDialog().showSimpleDialog(
      context,
      getTranslations().fromKey(LocaleKey.deleteAll),
      Text(getTranslations().fromKey(LocaleKey.areYouSure)),
      buttonBuilder: (BuildContext ctx) => [
        getDialog().simpleDialogCloseButton(ctx),
        getDialog().simpleDialogPositiveButton(
          ctx,
          title: LocaleKey.yes,
          onTap: () {
            portalViewModel.removeAllPortals();
            getNavigation().pop(ctx);
          },
        ),
      ],
    );
  }
}
