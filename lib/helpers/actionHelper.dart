import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../components/dialogs/asyncInputDialog.dart';

ActionItem editNameInAppBarAction(BuildContext context, LocaleKey dialogTitle,
        {String currentName,
        @required LocaleKey nameIfEmpty,
        Function(String) onEdit}) =>
    ActionItem(
      icon: Icons.edit,
      onPressed: () async {
        var name = await asyncInputDialog(
            context, getTranslations().fromKey(dialogTitle),
            defaultText: currentName);
        var newName = (name == null || name.isEmpty)
            ? getTranslations().fromKey(nameIfEmpty)
            : name;
        onEdit(newName);
      },
    );
