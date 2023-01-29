import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../contracts/favourite/favourite_item.dart';
import '../../contracts/generic_page_item.dart';

SpeedDialChild favouriteFloatingActionButton(
        BuildContext context,
        GenericPageItem genericItem,
        Function(FavouriteItem newItem) addFavourite) =>
    SpeedDialChild(
      backgroundColor: getTheme().fabColourSelector(context),
      foregroundColor: getTheme().fabForegroundColourSelector(context),
      onTap: () => addFavourite(
        FavouriteItem(id: genericItem.id),
      ),
      child: CorrectlySizedImageFromIcon(
        icon: Icons.star,
        colour: getTheme().fabForegroundColourSelector(context),
      ),
    );
