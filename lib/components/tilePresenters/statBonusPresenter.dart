import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/AppImage.dart';
import '../../contracts/statBonus.dart';
import '../../contracts/proceduralStatBonus.dart';

Widget statBonusTilePresenter(BuildContext context, StatBonus statBonus) {
  String subTitle = statBonus.value.toString();
  if (statBonus.localeKeyTemplate != LocaleKey.unknown) {
    subTitle = getTranslations()
        .fromKey(statBonus.localeKeyTemplate)
        .replaceAll('{0}', statBonus.value);
  }
  return genericListTileWithSubtitleAndImageCount(
    context,
    leadingImage: Padding(
      padding: EdgeInsets.all(8),
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
  if (statBonus.localeKeyTemplate != LocaleKey.unknown) {
    if (statBonus.minValue.toString() == statBonus.maxValue.toString()) {
      subTitle = getTranslations()
          .fromKey(statBonus.localeKeyTemplate)
          .replaceAll('{0}', statBonus.minValue.toString());
    } else {
      subTitle = getTranslations()
              .fromKey(statBonus.localeKeyTemplate)
              .replaceAll('{0}', statBonus.minValue.toString()) +
          ' => ' +
          getTranslations()
              .fromKey(statBonus.localeKeyTemplate)
              .replaceAll('{0}', statBonus.maxValue.toString());
    }
  }

  return genericListTileWithSubtitleAndImageCount(
    context,
    leadingImage: Padding(
      padding: EdgeInsets.all(8),
      child: genericTileImage('${AppImage.statImages}/${statBonus.image}.png'),
    ),
    title: statBonus.name,
    subtitle: Text(subTitle),
    trailing: Text(statBonus.alwaysChoose
        ? getTranslations().fromKey(LocaleKey.statAlwaysIncluded)
        : getTranslations().fromKey(LocaleKey.statPossible)),
  );
}
