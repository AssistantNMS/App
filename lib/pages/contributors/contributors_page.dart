import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../contracts/misc/segment_view_item.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/contributor_tile_presenter.dart';
import '../../components/tilePresenters/translator_tile_presenter.dart';
import '../../constants/analytics_event.dart';
import '../../contracts/generated/contributor_view_model.dart';
import '../../integration/dependency_injection.dart';

class ContributorsPage extends StatefulWidget {
  const ContributorsPage({Key? key}) : super(key: key);

  @override
  _ContributorsWidget createState() => _ContributorsWidget();
}

class _ContributorsWidget extends State<ContributorsPage> {
  int currentSelection = 0;

  _ContributorsWidget() {
    getAnalytics().trackEvent(AnalyticsEvent.contributorsPage);
  }

  @override
  Widget build(BuildContext context) {
    List<SegmentViewItem> viewOptions = [
      SegmentViewItem(
        title: LocaleKey.contributors,
        builder: (innerCtx) => SearchableList<ContributorViewModel>(
          () => getContributorApiService().getContributors(),
          listItemDisplayer: contributorTilePresenter,
          listItemSearch: (ContributorViewModel option, String search) => false,
          minListForSearch: 1000,
          addFabPadding: true,
        ),
      ),
      SegmentViewItem(
        title: LocaleKey.translators,
        builder: (innerCtx) =>
            SearchableList<TranslatorLeaderboardItemViewModel>(
          () => getAssistantAppsApi().getTranslators(),
          listItemWithIndexDisplayer: translatorTilePresenter,
          listItemSearch: (TranslatorLeaderboardItemViewModel _, String __) =>
              false,
          minListForSearch: 1000,
          lastListItemWidget: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PositiveButton(
              title: getTranslations().fromKey(LocaleKey.useTranslationTool),
              onTap: () => launchExternalURL(
                ExternalUrls.assistantAppsToolSite,
              ),
            ),
          ),
          addFabPadding: true,
        ),
      ),
      SegmentViewItem(
        title: LocaleKey.donation,
        builder: (innerCtx) => const DonatorsPageComponent(
          SmallLoadMorePageButton(),
        ),
      ),
    ];

    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.contributors),
      body: Column(
        key: Key('currentSelection: $currentSelection'),
        children: [
          AdaptiveSegmentedControl(
            controlItems: viewOptions.map((s) => s.toSegmentOption()).toList(),
            currentSelection: currentSelection,
            onSegmentChosen: (index) {
              setState(() {
                currentSelection = index;
              });
            },
          ),
          customDivider(),
          Expanded(
            key: Key('currentSelection body: $currentSelection'),
            child: viewOptions[currentSelection].builder(context),
          ),
        ],
      ),
    );
  }
}
