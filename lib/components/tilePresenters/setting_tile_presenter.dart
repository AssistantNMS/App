import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../constants/analytics_event.dart';

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

Widget boolSettingTilePresenter(
  BuildContext context,
  String name,
  bool value, {
  void Function()? onChange,
}) {
  //
  void Function() tempOnChange;
  tempOnChange = () {
    if (onChange != null) onChange();
  };

  return FlatCard(
    child: genericListTile(
      context,
      leadingImage: null,
      name: name,
      trailing: getBaseWidget().adaptiveCheckbox(
        value: value,
        onChanged: (bool unused) => tempOnChange(),
      ),
      onTap: tempOnChange,
    ),
  );
}

Widget languageSettingTilePresenter(
  BuildContext context,
  String name,
  String value, {
  void Function(Locale locale)? onChange,
}) {
  //
  void Function() tempOnChange;
  tempOnChange = () async {
    if (onChange == null) return;

    String? temp = await getTranslations().langaugeSelectionPage(context);
    // if null, no language selected
    if (temp != null) onChange(getTranslations().getLocaleFromKey(temp));
  };
  LocalizationMap currentLocal =
      getTranslations().getCurrentLocalizationMap(context, value);
  return FlatCard(
    child: languageTilePresenter(
      context,
      name,
      currentLocal.countryCode,
      trailingDisplay: currentLocal.name,
      onTap: tempOnChange,
    ),
  );
}

Widget listSettingTilePresenter(
  BuildContext context,
  String name,
  Widget trailing,
  List<DropdownOption> options, {
  void Function(String)? onChange,
}) {
  void Function() tempOnChange;
  tempOnChange = () {
    if (onChange == null) return;
    getDialog().showOptionsDialog(
      context,
      name,
      options,
      onSuccess: (ctx, value) => onChange(value),
    );
  };

  return FlatCard(
    child: genericListTile(
      context,
      leadingImage: null,
      name: name,
      onTap: tempOnChange,
      trailing: trailing,
    ),
  );
}

Widget patreonCodeSettingTilePresenter(
  BuildContext context,
  String name,
  bool value, {
  void Function(bool)? onChange,
}) {
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
    String newName = (code.isEmpty) ? '' : code;
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
            if (onChange != null) onChange(true);
          } else {
            getLog().d('patreonOAuthLogin message ' + loginResult.errorMessage);
          }
        },
      ),
    );
  };

  return FlatCard(
    child: genericListTile(
      context,
      leadingImage: null,
      name: name,
      trailing: getBaseWidget().adaptiveCheckbox(
        value: value,
        onChanged: (_) => patreonModalSheet(),
      ),
      onTap: patreonModalSheet,
      onLongPress: patreonCodeModal,
    ),
  );
}
