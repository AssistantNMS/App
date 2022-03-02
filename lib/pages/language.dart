import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../components/scaffoldTemplates/genericPageScaffold.dart';
import '../constants/AnalyticsEvent.dart';
import '../constants/NmsExternalUrls.dart';

class Language extends StatelessWidget {
  Language() {
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
            title: getTranslations().fromKey(LocaleKey.useTranslationTool),
            colour: getTheme().getSecondaryColour(context),
            onPress: () => launchExternalURL(
              ExternalUrls.assistantAppsToolSite,
            ),
          ),
          positiveButton(
            title: getTranslations().fromKey(LocaleKey.github),
            colour: getTheme().getSecondaryColour(context),
            eventString: AnalyticsEvent.externalLinkGitHubGeneral,
            onPress: () => launchExternalURL(NmsExternalUrls.githubGeneralRepo),
          ),
        ],
      ),
    );
  }
}
