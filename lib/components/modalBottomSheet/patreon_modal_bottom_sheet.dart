import 'package:assistantnms_app/components/common/row_helper.dart';
import 'package:flutter/material.dart';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import '../../constants/app_duration.dart';
import '../../constants/Modal.dart';
import '../../constants/Patreon.dart';

import '../../constants/app_image.dart';
import '../../constants/nms_ui_constants.dart';
import '../../constants/routes.dart';
import '../../helpers/themeHelper.dart';

class PatreonModalBottomSheet extends StatelessWidget {
  final DateTime unlockDate;
  final void Function(BuildContext dialogCtx)? onTap;
  final Future<void> Function(BuildContext dialogCtx)? onSettingsTap;

  const PatreonModalBottomSheet({
    Key? key,
    required this.unlockDate,
    this.onTap,
    this.onSettingsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget Function()> widgets = [];

    int timeDiff = unlockDate.millisecondsSinceEpoch -
        DateTime.now().millisecondsSinceEpoch;
    String titleText = getTranslations().fromKey(LocaleKey.featureNotAvailable);
    String descripText =
        getTranslations().fromKey(LocaleKey.featureNotAvailableDescrip);

    int placeHolderIndex = descripText.indexOf('{0}');
    List<InlineSpan> nodes = [
      TextSpan(text: descripText.substring(0, placeHolderIndex)),
      TextSpan(
        text: getFriendlyTimeLeft(context, timeDiff),
        style: TextStyle(
          color: getTheme().getSecondaryColour(context),
          fontSize: 20,
        ),
      ),
      TextSpan(text: descripText.substring(placeHolderIndex + 3)),
    ];

    widgets.add(
      () => Container(
        color: HexColor('#424242'),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 12),
            child: SizedBox(
              child: LocalImage(imagePath: AppImage.patreonFeature),
              height: 200,
            ),
          ),
        ),
      ),
    );

    widgets.add(() => const EmptySpace2x());
    widgets.add(() => GenericItemGroup(titleText));
    widgets.add(() => const EmptySpace1x());
    widgets.add(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: RichText(
          text: TextSpan(
            style: getThemeSubtitle(context),
            children: nodes,
          ),
          textAlign: TextAlign.center,
          maxLines: 10,
        ),
      ),
    );
    widgets.add(() => const EmptySpace2x());

    widgets.add(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: rowWith2Columns(
          PositiveButton(
            title: getTranslations().fromKey(LocaleKey.patreon),
            backgroundColour: HexColor(NMSUIConstants.PatreonHex),
            onTap: () => launchExternalURL(ExternalUrls.patreon),
          ),
          PositiveButton(
            title: getTranslations().fromKey(LocaleKey.settings),
            onTap: () async {
              if (onSettingsTap == null) return;

              await onSettingsTap!(context);

              await getNavigation().navigateAwayFromHomeAsync(
                context,
                navigateToNamed: Routes.settings,
              );
            },
          ),
        ),
      ),
    );

    widgets.add(() => const EmptySpace8x());

    return AnimatedSize(
      duration: AppDuration.modal,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        child: Container(
          constraints: modalFullHeightSize(context),
          child: ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: widgets.length,
            itemBuilder: (_, int index) => widgets[index](),
            shrinkWrap: true,
          ),
        ),
      ),
    );
  }
}

void handlePatreonBottomModalSheetWhenTapped(
  BuildContext navContext,
  bool isPatron, {
  required DateTime unlockDate,
  required void Function(BuildContext dialogCtx) onTap,
  Future<void> Function(BuildContext dialogCtx)? onSettingsTap,
}) {
  bool isLocked = isPatreonFeatureLocked(unlockDate, isPatron);
  if (isLocked == false) {
    onTap(navContext);
    return;
  }

  adaptiveBottomModalSheet(
    navContext,
    hasRoundedCorners: true,
    builder: (BuildContext innerContext) => PatreonModalBottomSheet(
      onSettingsTap: onSettingsTap,
      unlockDate: unlockDate,
      onTap: onTap,
    ),
  );
}
