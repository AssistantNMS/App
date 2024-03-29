import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../constants/platforms.dart';

import '../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../components/tilePresenters/setting_tile_presenter.dart';
import '../constants/analytics_event.dart';
import '../constants/fonts.dart';
import '../constants/homepage_items.dart';
import '../constants/nms_external_urls.dart';
import '../contracts/enum/homepage_type.dart';
import '../contracts/redux/app_state.dart';
import '../env/app_version_num.dart';
import '../helpers/date_helper.dart';
import '../helpers/useless_button_helper.dart';
import '../redux/modules/setting/setting_view_model.dart';

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
      LocalImage(
          imagePath:
              SelectedPlatform.getFromValue(viewModel.platformIndex).icon),
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
        FlatCard(
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
      widgets.add(PositiveButton(
        title: 'Useless button',
        onTap: () => uselessButtonFunc(
          context,
          viewModel.uselessButtonTaps,
          viewModel.increaseUselessButtonTaps,
        ),
      ));
    }

    widgets.add(const EmptySpace3x());

    widgets.add(const Center(child: Text('BuildName: $appsBuildName')));
    widgets.add(const Center(child: Text('BuildNumber: $appsBuildNum')));
    widgets.add(Center(
      child: GestureDetector(
        child: const Text(appsCommit, maxLines: 1),
        onTap: () => launchExternalURL(
          NmsExternalUrls.githubViewAppRepoAtCommit + appsCommit,
        ),
      ),
    ));

    widgets.add(const EmptySpace8x());

    return listWithScrollbar(
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
      scrollController: ScrollController(),
    );
  }
}
