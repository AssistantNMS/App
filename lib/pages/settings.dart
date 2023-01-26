import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../constants/Platforms.dart';

import '../components/scaffoldTemplates/genericPageScaffold.dart';
import '../components/tilePresenters/settingTilePresenter.dart';
import '../constants/AnalyticsEvent.dart';
import '../constants/Fonts.dart';
import '../constants/HomepageItems.dart';
import '../contracts/enum/homepageType.dart';
import '../contracts/redux/appState.dart';
import '../helpers/dateHelper.dart';
import '../helpers/uselessButtonHelper.dart';
import '../redux/modules/setting/settingViewModel.dart';

class Settings extends StatelessWidget {
  final void Function(Locale locale) onLocaleChange;
  Settings(this.onLocaleChange, {Key? key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.settingsPage);
  }

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.settings),
      body: StoreConnector<AppState, SettingViewModel>(
        converter: (store) => SettingViewModel.fromStore(store),
        builder: (_, viewModel) => getBody(context, viewModel),
      ),
    );
  }

  Widget getBody(BuildContext context, SettingViewModel viewModel) {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(headingSettingTilePresenter(
        getTranslations().fromKey(LocaleKey.general)));

    widgets.add(languageSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.appLanguage),
      viewModel.selectedLanguage,
      onChange: (Locale locale) => onLocaleChange(locale),
    ));

    // widgets.add(boolSettingTilePresenter(
    //   context,
    //   getTranslations().fromKey(LocaleKey.darkModeEnabled),
    //   getTheme().getIsDark(context),
    //   onChange: () => this._changeBrightness(context),
    // ));

    widgets.add(boolSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.allItemsListUseCompactTiles),
      viewModel.genericTileIsCompact,
      onChange: viewModel.toggleGenericTileIsCompact,
    ));

    widgets.add(boolSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.guidesUseCompactTiles),
      viewModel.guidesIsCompact,
      onChange: viewModel.toggleGuideIsCompact,
    ));

    if (isApple) {
      widgets.add(boolSettingTilePresenter(
        context,
        getTranslations().fromKey(LocaleKey.useMaterialTheme),
        viewModel.showMaterialTheme,
        onChange: viewModel.toggleShowMaterialTheme,
      ));
    }

    widgets.add(boolSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.showItemBackgroundColours),
      viewModel.displayGenericItemColour,
      onChange: viewModel.toggleDisplayGenericItemColour,
    ));

    widgets.add(listSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.platform),
      localImage(SelectedPlatform.getFromValue(viewModel.platformIndex).icon),
      availablePlatforms
          .map(
            (hp) => DropdownOption(
              hp.title,
              value: hp.index.toString(),
              icon: SelectedPlatform.getFromValue(hp.index).icon,
            ),
          )
          .toList(),
      onChange: (String newValue) {
        int? intValue = int.tryParse(newValue);
        if (intValue == null) return;
        viewModel.setPlatformIndex(intValue);
      },
    ));

    widgets.add(listSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.settingsFont),
      Text(
        getTranslations().fromKey(
          SelectedFont.getFromFontFamily(viewModel.fontFamily).localeKey,
        ),
      ),
      availableFonts
          .map((hp) => DropdownOption(
                getTranslations().fromKey(hp.localeKey),
                value: hp.fontFamily.toString(),
              ))
          .toList(),
      onChange: (String newValue) {
        viewModel.setFontFamily(newValue);
        getTheme().setFontFamily(context, newValue);
      },
    ));

    widgets.add(listSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.homepage),
      Text(
        getTranslations().fromKey(
          getLocaleFromHomepageType(viewModel.homepageType),
        ),
      ),
      homepageItems
          .map((hp) => DropdownOption(
                getTranslations().fromKey(hp.localeKey),
                value: hp.localeKey.toString(),
              ))
          .toList(),
      onChange: (String newValue) {
        HomepageItem homepageItem = HomepageItem.defaultHomepageItem();
        for (HomepageItem item in homepageItems) {
          if (item.localeKey.toString() == newValue) {
            homepageItem = item;
          }
        }

        if (viewModel.homepageType != homepageItem.homepageType) {
          viewModel.setHomepageType(homepageItem.homepageType);
          getNavigation().navigateHomeAsync(
            context,
            navigateToNamed: HomepageItem.getByType(
              homepageItem.homepageType,
            ).routeToNamed,
            pushReplacement: true,
          );
        }
      },
    ));

    if (viewModel.homepageType == HomepageType.custom) {
      widgets.add(
        flatCard(
          child: genericListTile(
            context,
            leadingImage: null,
            name: getTranslations().fromKey(LocaleKey.forceNumberOfColumns),
            trailing: viewModel.customHomePageColumnCount == 0
                ? const Icon(Icons.do_not_disturb_alt_outlined, size: 32)
                : Text(viewModel.customHomePageColumnCount.toString()),
            onTap: () {
              TextEditingController controller = TextEditingController(
                text: (viewModel.customHomePageColumnCount < 1)
                    ? ''
                    : viewModel.customHomePageColumnCount.toString(),
              );
              getDialog().showQuantityDialog(
                context,
                controller,
                amounts: [0, 1, 2, 3, 4, 5],
                onSuccess: (BuildContext ctx, String quantity) {
                  int? intQuantity = int.tryParse(quantity);
                  if (intQuantity == null) return;
                  if (intQuantity > 10) intQuantity = 10;
                  viewModel.setCustomHomePageColumnCount(intQuantity);
                },
              );
            },
          ),
        ),
      );
    }

    widgets.add(boolSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.hideSpoilerWarnings),
      viewModel.dontShowSpoilerAlert,
      onChange: viewModel.setShowSpoilerAlert,
    ));

    widgets.add(boolSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.mergeInventoryQuantities),
      viewModel.mergeInventoryQuantities,
      onChange: viewModel.toggleMergeInventoryQuantities,
    ));

    if (isInFestivePeriod()) {
      widgets.add(boolSettingTilePresenter(
        context,
        getTranslations().fromKey(LocaleKey.displaySeasonalBackground),
        viewModel.showFestiveBackground,
        onChange: () => viewModel.toggleShowFestiveBackground(),
      ));
    }

    widgets.add(patreonCodeSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.patreonAccess),
      viewModel.isPatron,
      onChange: viewModel.setIsPatron,
    ));

    widgets.add(
      headingSettingTilePresenter(getTranslations().fromKey(LocaleKey.portals)),
    );

    widgets.add(boolSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.useAltGlyphs),
      viewModel.useAltGlyphs,
      onChange: viewModel.toggleAltGlyphs,
    ));

    widgets.add(
      headingSettingTilePresenter(getTranslations().fromKey(LocaleKey.other)),
    );

    widgets.add(logTilePresenter(context));

    widgets.add(linkSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.privacyPolicy),
      icon: Icons.description,
      onTap: () => launchExternalURL(ExternalUrls.privacyPolicy),
    ));

    widgets.add(linkSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.termsAndConditions),
      icon: Icons.description,
      onTap: () => launchExternalURL(ExternalUrls.termsAndConditions),
    ));

    widgets.add(legalTilePresenter());

    if (viewModel.selectedLanguage == 'en') {
      widgets.add(positiveButton(
        context,
        title: 'Useless button',
        onPress: () => uselessButtonFunc(
          context,
          viewModel.uselessButtonTaps,
          viewModel.increaseUselessButtonTaps,
        ),
      ));
    }

    widgets.add(emptySpace3x());

    return listWithScrollbar(
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
      scrollController: ScrollController(),
    );
  }
}
