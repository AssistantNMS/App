import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../contracts/data/generated_meta.dart';
import '../integration/dependency_injection.dart';

import '../components/modalBottomSheet/update_modal_bottom_sheet.dart';
import '../constants/app_image.dart';
import '../contracts/misc/custom_menu.dart';
import '../redux/modules/setting/drawer_settings_view_model.dart';

List<Widget> getDrawerItems(context, DrawerSettingsViewModel viewModel) {
  List<Widget> widgets = List.empty(growable: true);
  Color drawerIconColour = getTheme().getDarkModeSecondaryColour();

  widgets.addAll(_mapToDrawerItem(
    context,
    getMenuOptionsSection1(context, viewModel, drawerIconColour),
  ));
  widgets.add(getBaseWidget().customDivider());
  widgets.addAll(_mapToDrawerItem(
    context,
    getMenuOptionsSection2(context, viewModel, drawerIconColour),
  ));
  widgets.add(getBaseWidget().customDivider());
  widgets.addAll(_mapToDrawerItem(
    context,
    getMenuOptionsSection3(context, viewModel, drawerIconColour),
  ));
  widgets.add(getBaseWidget().customDivider());
  widgets.addAll(_mapToDrawerItem(
    context,
    getMenuOptionsSection4(context, viewModel, drawerIconColour),
  ));
  widgets.add(getBaseWidget().customDivider());

  widgets.add(CachedFutureBuilder<ResultWithValue<GeneratedMeta>>(
    future: getDataRepo().getGeneratedMeta(context),
    whileLoading: () => getLoading().smallLoadingTile(context),
    whenDoneLoading: (ResultWithValue<GeneratedMeta> metaResult) {
      return packageVersionTile(
        metaResult.isSuccess ? metaResult.value.gameVersion : 'Unknown',
        onTap: () {
          adaptiveBottomModalSheet(
            context,
            hasRoundedCorners: true,
            builder: (BuildContext innerContext) {
              return const UpdateBottomSheet();
            },
          );
        },
      );
    },
  ));

  widgets.add(_drawerItem(
    context,
    image: const ListTileImage(partialPath: AppImage.assistantApps),
    key: LocaleKey.assistantApps,
    onTap: (_) {
      adaptiveBottomModalSheet(
        context,
        hasRoundedCorners: true,
        builder: (BuildContext innerC) => const AssistantAppsModalBottomSheet(
          appType: AssistantAppType.nms,
        ),
      );
    },
  ));
  widgets.add(const EmptySpace3x());

  return widgets;
}

Widget _drawerItem(
  BuildContext context, {
  required Widget image,
  required LocaleKey key,
  String? navigateToNamed,
  String? navigateToExternal,
  bool isLocked = false,
  bool isNew = false,
  Function(BuildContext)? onTap,
  Function(BuildContext)? onLongPress,
}) {
  Widget? isLockedWidget;
  if (isLocked) {
    isLockedWidget = Icon(
      Icons.lock_clock,
      color: getTheme().getDarkModeSecondaryColour(),
    );
  }

  ListTile tile = ListTile(
    key: Key('$image-${key.toString()}'),
    leading: image,
    title: Text(getTranslations().fromKey(key)),
    dense: true,
    trailing: isLockedWidget,
    onLongPress: () {
      if (onLongPress != null) onLongPress(context);
    },
    onTap: () async {
      if (onTap != null) {
        onTap(context);
        return;
      }

      if (navigateToNamed != null) {
        await getNavigation().navigateAwayFromHomeAsync(context,
            navigateToNamed: navigateToNamed);
      } else if (navigateToExternal != null) {
        launchExternalURL(navigateToExternal);
      }
    },
  );
  if (isNew) {
    return WrapInNewBanner(
      message: LocaleKey.newItem,
      child: tile,
      location: isLocked ? BannerLocation.topStart : BannerLocation.topEnd,
    );
  }
  return tile;
}

List<Widget> _mapToDrawerItem(BuildContext context, List<CustomMenu> menus) {
  List<Widget> widgets = List.empty(growable: true);
  for (CustomMenu menu in menus) {
    if (menu.hideInDrawer) continue;
    widgets.add(_drawerItem(
      context,
      image: menu.drawerIcon ?? menu.icon,
      key: menu.title,
      navigateToNamed: menu.navigateToNamed,
      navigateToExternal: menu.navigateToExternal,
      isLocked: menu.isLocked,
      isNew: menu.isNew,
      onTap: menu.onTap,
      onLongPress: menu.onLongPress,
    ));
  }
  return widgets;
}
