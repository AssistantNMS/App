import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../constants/AnalyticsEvent.dart';

import '../../env.dart';

Widget headingSettingTilePresenter(String name) {
  return ListTile(
    title: Text(
      name,
      maxLines: 1,
      style: const TextStyle(fontSize: 24),
      overflow: TextOverflow.ellipsis,
    ),
  );
}

Widget boolSettingTilePresenter(BuildContext context, String name, bool value,
    {Function() onChange}) {
  //
  void Function() tempOnChange;
  tempOnChange = () {
    if (onChange != null) onChange();
  };

  return flatCard(
    child: genericListTile(
      context,
      leadingImage: null,
      name: name,
      trailing: adaptiveCheckbox(
        value: value,
        activeColor: getTheme().getSecondaryColour(context),
        onChanged: (bool unused) => tempOnChange(),
      ),
      onTap: tempOnChange,
    ),
  );
}

Widget languageSettingTilePresenter(
    BuildContext context, String name, String value,
    {Function(Locale locale) onChange}) {
  //
  void Function() tempOnChange;
  tempOnChange = () async {
    if (onChange == null) return;

    String temp = await getTranslations().langaugeSelectionPage(context);
    // if null, no language selected
    if (temp != null) onChange(getTranslations().getLocaleFromKey(temp));
  };
  LocalizationMap currentLocal =
      getTranslations().getCurrentLocalizationMap(context, value);
  return flatCard(
    child: languageTilePresenter(
      context,
      name,
      currentLocal.countryCode,
      trailingDisplay: currentLocal.name,
      onTap: tempOnChange,
    ),
  );
}

Widget listSettingTilePresenter(BuildContext context, String name, String value,
    List<DropdownOption> options,
    {Function(String) onChange}) {
  void Function() tempOnChange;
  tempOnChange = () {
    getDialog().showOptionsDialog(
      context,
      name,
      options
          .map(
            (opt) => DropdownOption(
              opt.title,
              value: opt.value,
            ),
          )
          .toList(),
      onSuccess: (ctx, value) => onChange(value),
    );
  };

  return flatCard(
    child: genericListTile(
      context,
      leadingImage: null,
      name: name,
      onTap: tempOnChange,
      trailing: Text(value),
    ),
  );
}

Widget patreonCodeSettingTilePresenter(
    BuildContext context, String name, bool value,
    {Function(bool) onChange}) {
  //
  void Function() baseOnChange;
  baseOnChange = () async {
    if (onChange != null && value) {
      onChange(false);
      return;
    }
  };

  void Function() patreonCodeModal;
  patreonCodeModal = () async {
    baseOnChange();

    String code = await getDialog().asyncInputDialog(context, name);
    String newName = (code == null || code.isEmpty) ? '' : code;
    bool codeIsCorrect = Patreon.codes.any(
      (code) => code == newName.toUpperCase(),
    );
    if (codeIsCorrect && onChange != null && value == false) onChange(true);
  };

  void Function() patreonModalSheet;
  patreonModalSheet = () async {
    baseOnChange();

    if (value == true) return;

    adaptiveBottomModalSheet(
      context,
      hasRoundedCorners: true,
      builder: (BuildContext innerC) => PatreonLoginModalBottomSheet(
        AnalyticsEvent.patreonOAuthLogin,
        (Result loginResult) {
          if (loginResult.isSuccess) {
            onChange(true);
          } else {
            getLog().d('patreonOAuthLogin message ' + loginResult.errorMessage);
          }
        },
      ),
    );
  };

  return flatCard(
    child: genericListTile(
      context,
      leadingImage: null,
      name: name,
      trailing: adaptiveCheckbox(
        value: value,
        activeColor: getTheme().getSecondaryColour(context),
        onChanged: (_) => patreonModalSheet(),
      ),
      onTap: patreonModalSheet,
      onLongPress: patreonCodeModal,
    ),
  );
}
