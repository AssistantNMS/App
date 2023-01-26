import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../components/scaffoldTemplates/genericPageScaffold.dart';
import '../constants/AnalyticsEvent.dart';
import '../constants/NmsExternalUrls.dart';

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
        additionalButtons: [
          positiveButton(
            context,
            title: getTranslations().fromKey(LocaleKey.useTranslationTool),
            onPress: () => launchExternalURL(
              ExternalUrls.assistantAppsToolSite,
            ),
          ),
          positiveButton(
            context,
            title: getTranslations().fromKey(LocaleKey.github),
            eventString: AnalyticsEvent.externalLinkGitHubGeneral,
            onPress: () => launchExternalURL(NmsExternalUrls.githubGeneralRepo),
          ),
        ],
      ),
    );
  }
}
