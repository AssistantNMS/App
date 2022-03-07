# Assistant for No Man's Sky (Android + iOS apps)
**Project Owner**: [Khaoz-Topsy][kurtGithub]

The **Assistant for No Man's Sky** is an app that gives users information about the game, such as crafting recipes, refiner recipes, item costs, blueprint costs, a portal library and guides. Almost all of the data is extracted from the **No Man's Sky** game files. This project would not be possible without the hard work of the NMS Modding community and the [MBinCompiler][mbincompiler].

> This app was originally released in early August 2019! The app was originally named No Man's Sky Recipes, when submitting the app to the Apple Store it was rejected due to the name and so the app was renamed. 

After 2 years of development and maintenance, the app was made open source so that the community to have greater control and oversight of what goes into the apps and hopefully some people might want to help fix bugs 😅

[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/uses-badges.svg)](https://forthebadge.com)

[![Follow on Twitter](https://img.shields.io/twitter/follow/AssistantNMS?color=%231d9bf0&style=for-the-badge)][assistantnmsTwitter]
[![Discord](https://img.shields.io/discord/625007826913198080?style=for-the-badge)][discord]

## Running the project
**Prerequisites:**
- [Flutter][flutter]
- Android SDK, (easiest way to install is to go through the [Android Studio install][androidStudio]

**Steps:**
1. Rename the `env.dart.template` file to `env.dart`
2. Flutter

## Contributing
Please take a look at the [Contribution Guideline](./.github/CONTRIBUTING.md) before creating an issue or pull request.

If you would like to help add languages to the app please use this tool [AssistantApps tool][assistantAppsTools].

## Builds (CI/CD)
The Mobile Apps are built and released to the [Google Play Store][googlePlayStore] and [Apple App Store Store][appleAppStore] using [CodeMagic][codeMagic].

- [![Codemagic build status](https://api.codemagic.io/apps/5d9da9057a0a9500105180bf/5ef3374ec0adbfe0fdee431d/status_badge.svg)](https://codemagic.io/apps/5d9da9057a0a9500105180bf/5ef3374ec0adbfe0fdee431d/latest_build) - Android & iOS (Production)
- [![Codemagic build status](https://api.codemagic.io/apps/5d9da9057a0a9500105180bf/5e180f76d95f1f258ec86619/status_badge.svg)](https://codemagic.io/apps/5d9da9057a0a9500105180bf/5da07d2e7338b0000f046ba3/latest_build) - Android (Production)
- [![Codemagic build status](https://api.codemagic.io/apps/5d9da9057a0a9500105180bf/5d9da9057a0a9500105180be/status_badge.svg)](https://codemagic.io/apps/5d9da9057a0a9500105180bf/5d9da9057a0a9500105180be/latest_build) - Android (Alpha)
- [![Codemagic build status](https://api.codemagic.io/apps/5d9da9057a0a9500105180bf/5d9dc56b7a0a95000a475d84/status_badge.svg)](https://codemagic.io/apps/5d9da9057a0a9500105180bf/5d9dc56b7a0a95000a475d84/latest_build) - iOS Build

__The iOS build on [CodeMagic][codeMagic] generally reports that it has failed even though it actually successfully built and pushed the `.ipa` file to the Apple App Store. This is because they poll the App Store checking if the `.ipa` file is there and after a few attempts throw an error. So ignore build failures for anything that has to do with iOS 🙄.__

## Links
- [Website][assistantnmsWebsite]
- [Google Play Store][googlePlayStore]
- [Apple App Store Store][appleAppStore]

- [Twitter][assistantnmsTwitter]
- [Discord][assistantAppsDiscord]
- [Facebook][assistantnmsFacebook]
- [Steam Community Page][assistantnmsSteamComm]



<!-- Links used in the page -->

[kurtGithub]: https://github.com/Khaoz-Topsy
[assistantAppsTools]: https://tools.assistantapps.com
[assistantAppsDiscord]: https://assistantapps.com/discord?ref=nmsAssistantGithub
[assistantnmsWebsite]: https://nmsassistant.com
[assistantnmsTwitter]: https://twitter.com/AssistantNMS?ref=nmsAssistantGithub
[assistantnmsFacebook]: https://facebook.com/AssistantNMS?ref=nmsAssistantGithub
[assistantnmsSteamComm]: https://steamcommunity.com/groups/AssistantNMS?ref=nmsAssistantGithub
[discord]: https://assistantapps.com/discord?ref=AssistantAppsDocs

<!-- Other -->
[mbincompiler]: https://github.com/monkeyman192/MBINCompiler
[flutter]: https://docs.flutter.dev/get-started/install
[androidStudio]: https://developer.android.com/studio
[googlePlayStore]: https://play.google.com/store/apps/details?id=com.kurtlourens.no_mans_sky_recipes
[appleAppStore]: https://apps.apple.com/us/app/assistant-for-no-mans-sky/id1480287625
[codeMagic]: https://codemagic.io

