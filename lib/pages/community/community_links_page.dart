import 'package:after_layout/after_layout.dart';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/constants/nms_external_urls.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/community_link_tile_presenter.dart';
import '../../constants/analytics_event.dart';
import '../../contracts/generated/community_link_meta_view_model.dart';
import '../../contracts/generated/community_link_view_model.dart';
import '../../helpers/column_helper.dart';
import '../../helpers/search_helpers.dart';
import '../../integration/dependency_injection.dart';

class CommunityLinksPage extends StatefulWidget {
  CommunityLinksPage({Key? key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.communityLinkPage);
  }

  @override
  _CommunityLinksPageWidget createState() => _CommunityLinksPageWidget();
}

class _CommunityLinksPageWidget extends State<CommunityLinksPage>
    with AfterLayoutMixin<CommunityLinksPage> {
  bool isLoading = true;
  bool hasFailed = false;
  CommunityLinkMetaViewModel meta = CommunityLinkMetaViewModel.empty();

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    ResultWithValue<CommunityLinkMetaViewModel> result =
        await getCommunityApiService().getAllCommunityLinks();
    setState(() {
      meta = result.value;
      isLoading = false;
      hasFailed = result.hasFailed;
    });
  }

  Future<ResultWithValue<List<CommunityLinkViewModel>>>
      getAllCommunityLinks() async {
    if (hasFailed) return ResultWithValue(false, List.empty(), '');

    List<CommunityLinkViewModel> newValue = meta.items
        .where((comLink) => comLink.customId != 'AssistantNMS')
        .toList();
    newValue.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    return ResultWithValue(true, newValue, '');
  }

  @override
  Widget build(BuildContext context) {
    ListItemDisplayerType<CommunityLinkViewModel> tilePresenter =
        communityLinkTilePresenter(meta.chipColours);

    if (isLoading) {
      return basicGenericPageScaffold(
        context,
        title: getTranslations().fromKey(LocaleKey.communityLinks),
        body: getLoading().fullPageLoading(context),
      );
    }

    ActionItem questionWidget = ActionItem(
      icon: Icons.help_outline,
      onPressed: () => getDialog().showSimpleHelpDialog(
        context,
        getTranslations().fromKey(LocaleKey.help),
        'Information supplied by NMS Community Search\n\n${NmsExternalUrls.communitySearchHomepage}',
        buttonBuilder: (BuildContext dialogCtx) => [
          GestureDetector(
            child: Padding(
              child: Text(getTranslations().fromKey(LocaleKey.viewPostOnline)),
              padding: const EdgeInsets.all(12),
            ),
            onTap: () => launchExternalURL(
              NmsExternalUrls.communitySearchHomepage,
            ),
          ),
          GestureDetector(
            child: Padding(
              child: Text(getTranslations().fromKey(LocaleKey.close)),
              padding: const EdgeInsets.all(12),
            ),
            onTap: () => getNavigation().pop(dialogCtx),
          ),
        ],
      ),
    );

    return getBaseWidget().appScaffold(
      context,
      appBar: getBaseWidget().appBarForSubPage(
        context,
        title: Text(getTranslations().fromKey(LocaleKey.communityLinks)),
        showHomeAction: true,
        actions: [questionWidget],
      ),
      body: SearchableGrid<CommunityLinkViewModel>(
        () => getAllCommunityLinks(),
        // listItemDisplayer: tilePresenter,
        // listItemSearch: searchCommunityLinksByName,
        gridItemDisplayer: tilePresenter,
        gridItemSearch: searchCommunityLinksByName,
        gridViewColumnCalculator: getCommunityLinkColumnCount,
        minListForSearch: 20,
        addFabPadding: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => launchExternalURL(
          NmsExternalUrls.communitySearchAddLinkForm,
        ),
        heroTag: 'AddCommunitySearchLink',
        child: const Icon(Icons.add),
        foregroundColor: getTheme().fabForegroundColourSelector(context),
        backgroundColor: getTheme().fabColourSelector(context),
      ),
    );
  }
}
