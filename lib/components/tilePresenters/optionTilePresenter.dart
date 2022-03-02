import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

Widget optionTilePresenter(BuildContext context, DropdownOption option,
    {Function onDelete}) {
  return Card(
    child: genericListTile(
      context,
      leadingImage: null,
      name: option.title,
      onTap: () {
        Navigator.of(context).pop(option.value);
      },
      trailing: (onDelete != null)
          ? popupMenu(context, onEdit: null, onDelete: onDelete)
          : null,
    ),
    margin: const EdgeInsets.all(0.0),
  );
}
