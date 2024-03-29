import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/app_image.dart';
import '../../contracts/stat_bonus.dart';
import '../../contracts/procedural_stat_bonus.dart';

Widget statBonusTilePresenter(BuildContext context, StatBonus statBonus) {
  String subTitle = statBonus.value.toString();
  String tempTrans = getTranslations()
      .fromString(statBonus.localeKeyTemplate)
      .replaceAll('{0}', statBonus.value);
  if (statBonus.localeKeyTemplate != tempTrans) {
    subTitle = tempTrans;
  }
  return genericListTileWithSubtitleAndImageCount(
    context,
    leadingImage: Padding(
      padding: const EdgeInsets.all(8),
      child: genericTileImage('${AppImage.statImages}/${statBonus.image}.png'),
    ),
    title: statBonus.name,
    subtitle: Text(subTitle),
  );
}

Widget proceduralStatBonusTilePresenter(
    BuildContext context, ProceduralStatBonus statBonus) {
  String subTitle =
      statBonus.minValue.toString() + ' => ' + statBonus.maxValue.toString();

  if (statBonus.localeKeyTemplate != 'unknown' &&
      statBonus.localeKeyTemplate != 'defaultTemplate') {
    if (statBonus.minValue.toString() == statBonus.maxValue.toString()) {
      subTitle = getTranslations()
          .fromString(statBonus.localeKeyTemplate)
          .replaceAll('{0}', statBonus.minValue.toString());
    } else {
      subTitle = getTranslations()
              .fromString(statBonus.localeKeyTemplate)
              .replaceAll('{0}', statBonus.minValue.toString()) +
          ' => ' +
          getTranslations()
              .fromString(statBonus.localeKeyTemplate)
              .replaceAll('{0}', statBonus.maxValue.toString());
    }
  }

  return genericListTileWithSubtitleAndImageCount(
    context,
    leadingImage: Padding(
      padding: const EdgeInsets.all(8),
      child: genericTileImage('${AppImage.statImages}/${statBonus.image}.png'),
    ),
    title: statBonus.name,
    subtitle: Text(subTitle),
    trailing: Text(statBonus.alwaysChoose
        ? getTranslations().fromKey(LocaleKey.statAlwaysIncluded)
        : getTranslations().fromKey(LocaleKey.statPossible)),
  );
}
