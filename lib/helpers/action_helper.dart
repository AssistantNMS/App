import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

ActionItem editNameInAppBarAction(
  BuildContext context,
  LocaleKey dialogTitle, {
  String? currentName,
  required LocaleKey nameIfEmpty,
  required void Function(String) onEdit,
}) =>
    ActionItem(
      icon: Icons.edit,
      onPressed: () async {
        String name = await getDialog().asyncInputDialog(
            context, getTranslations().fromKey(dialogTitle),
            defaultText: currentName);
        String newName = name.isEmpty //
            ? getTranslations().fromKey(nameIfEmpty)
            : name;
        onEdit(newName);
      },
    );
