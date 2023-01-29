import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/social_tile_presenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/data/socialItem.dart';
import '../../integration/dependencyInjection.dart';

class SocialPage extends StatelessWidget {
  SocialPage({Key? key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.socialPage);
  }

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.social),
      body: SearchableList<SocialItem>(
        () => getDataRepo().getSocial(context),
        listItemDisplayer: socialLinkTilePresenter,
        listItemSearch: (SocialItem _, String __) => false,
        minListForSearch: 100,
      ),
      fab: FloatingActionButton(
        onPressed: () => shareText(LocaleKey.shareContent),
        heroTag: 'SocialPage',
        child: const Icon(Icons.share),
        foregroundColor: getTheme().fabForegroundColourSelector(context),
        backgroundColor: getTheme().fabColourSelector(context),
      ),
    );
  }
}
