import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/app_image.dart';
import '../../contracts/data/egg_trait.dart';

Widget eggTraitTilePresenter(BuildContext context, EggTrait eggTrait) {
  return genericListTileWithSubtitleAndImageCount(
    context,
    leadingImage: genericTileImage('other/93.png'),
    title: getTranslations().fromString(eggTrait.traitType),
    subtitle: Text(getTranslations().fromString(eggTrait.trait)),
    trailing: LocalImage(
      imagePath: eggTrait.isPositiveEffect
          ? AppImage.companionInc
          : AppImage.companionDec,
      width: 36,
      height: 36,
    ),
  );
}
