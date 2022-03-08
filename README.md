# Assistant for No Man's Sky (Android + iOS apps)
**Project Owner**: [Khaoz-Topsy][kurtGithub]

The **Assistant for No Man's Sky** is an app that gives users information about the game, such as crafting recipes, refiner recipes, item costs, blueprint costs, a portal library and guides. Almost all of the data is extracted from the **No Man's Sky** game files. This project would not be possible without the hard work of the NMS Modding community and the [MBinCompiler][mbincompiler].

> This app was originally released in early August 2019! The app was originally named No Man's Sky Recipes, when submitting the app to the Apple Store it was rejected due to the name and so the app was renamed. 

After 2 years of development and maintenance, the app was made open source so that the community to have greater control and oversight of what goes into the apps and hopefully some people might want to help fix bugs 😅

[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/uses-badges.svg)](https://forthebadge.com)

[![Follow on Twitter](https://img.shields.io/twitter/follow/AssistantNMS?color=%231d9bf0&style=for-the-badge)][assistantnmsTwitter]
[![Discord](https://img.shields.io/discord/625007826913198080?style=for-the-badge)][discord]

[![Supported by the No Man's Sky Community Developers & Designers](https://raw.githubusercontent.com/NMSCD/About/master/badge/purple-ftb.svg)][nmscd]

<!--- 
![Latest version](https://api.assistantapps.com/badge/version/589405b4-e40f-4cd9-b793-6bf37944ee09.svg?platforms=0&platforms=1)
[![Android review](https://api.assistantapps.com/badge/1/1.svg)][googlePlayStore]
[![iOS review](https://api.assistantapps.com/badge/1/2.svg)][appleAppStore]
--->

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

- ![Codemagic build status](https://api.codemagic.io/apps/5d9da9057a0a9500105180bf/5ef3374ec0adbfe0fdee431d/status_badge.svg) - Android & iOS (Production)
- ![Codemagic build status](https://api.codemagic.io/apps/5d9da9057a0a9500105180bf/5e180f76d95f1f258ec86619/status_badge.svg) - Android (Production)
- ![Codemagic build status](https://api.codemagic.io/apps/5d9da9057a0a9500105180bf/5d9da9057a0a9500105180be/status_badge.svg) - Android (Alpha)
- ![Codemagic build status](https://api.codemagic.io/apps/5d9da9057a0a9500105180bf/5d9dc56b7a0a95000a475d84/status_badge.svg) - iOS Build

__The iOS build on [CodeMagic][codeMagic] generally reports that it has failed even though it actually successfully built and pushed the `.ipa` file to the Apple App Store. This is because they poll the App Store checking if the `.ipa` file is there and after a few attempts throw an error. So ignore build failures for anything that has to do with iOS 🙄.__

## Links
[![Website](https://img.shields.io/badge/Website-nmsassistant.com-blue?color=7986cc&style=for-the-badge)][assistantnmsWebsite]
[![WebApp](https://img.shields.io/badge/Web%20App-app.nmsassistant.com-blue?color=7986cc&style=for-the-badge)][assistantnmsWebapp]

[![GooglePlay](https://img.shields.io/badge/Download-Google%20Play%20Store-blue?color=34A853&style=for-the-badge)][googlePlayStore]
[![AppleAppStore](https://img.shields.io/badge/Download-Apple%20App%20Store-black?color=444444&style=for-the-badge)][appleAppStore]

[![Twitter](https://img.shields.io/badge/Twitter-@AssistantNMS-blue?color=1DA1F2&style=for-the-badge)][assistantnmsTwitter]
[![Discord](https://img.shields.io/badge/Discord-AssistantApps-blue?color=5865F2&style=for-the-badge)][discord]
[![Facebook](https://img.shields.io/badge/Facebook-AssistantNMS-blue?color=1877f2&style=for-the-badge)][assistantnmsFacebook]
[![Steam Community Page](https://img.shields.io/badge/Steam%20Community%20Page-AssistantNMS-black?style=for-the-badge)][assistantnmsSteamComm]



<!-- Links used in the page -->

[kurtGithub]: https://github.com/Khaoz-Topsy?ref=AssistantNMSGithub
[assistantAppsTools]: https://tools.assistantapps.com?ref=AssistantNMSGithub
[assistantnmsWebsite]: https://nmsassistant.com?ref=AssistantNMSGithub
[assistantnmsWebapp]: https://app.nmsassistant.com?ref=AssistantNMSGithub
[assistantnmsTwitter]: https://twitter.com/AssistantNMS?ref=AssistantNMSGithub
[assistantnmsFacebook]: https://facebook.com/AssistantNMS?ref=AssistantNMSGithub
[assistantnmsSteamComm]: https://steamcommunity.com/groups/AssistantNMS?ref=AssistantNMSGithub
[googlePlayStore]: https://play.google.com/store/apps/details?id=com.kurtlourens.no_mans_sky_recipes&ref=AssistantNMSGithub
[appleAppStore]: https://apps.apple.com/us/app/assistant-for-no-mans-sky/id1480287625?ref=AssistantNMSGithub
[discord]: https://assistantapps.com/discord?ref=AssistantNMSGithub
[nmscd]: https://github.com/NMSCD?ref=AssistantNMSGithub

<!-- Other -->
[mbincompiler]: https://github.com/monkeyman192/MBINCompiler
[flutter]: https://docs.flutter.dev/get-started/install
[androidStudio]: https://developer.android.com/studio
[codeMagic]: https://codemagic.io

