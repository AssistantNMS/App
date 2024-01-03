import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../constants/analytics_event.dart';
import '../constants/nms_external_urls.dart';

class Language extends StatelessWidget {
  Language({Key? key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.languageHelpPage);
  }

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.language),
      body: LanguagePageContent(
        numberOfLanguagesToShow: 20,
        additionalButtons: [
          PositiveButton(
            title: getTranslations().fromKey(LocaleKey.useTranslationTool),
            onTap: () => launchExternalURL(
              ExternalUrls.assistantAppsToolSite,
            ),
          ),
          PositiveButton(
            title: getTranslations().fromKey(LocaleKey.github),
            eventString: AnalyticsEvent.externalLinkGitHubGeneral,
            onTap: () => launchExternalURL(NmsExternalUrls.githubGeneralRepo),
          ),
        ],
      ),
    );
  }
}
