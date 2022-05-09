import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../contracts/genericPageItem.dart';
import '../dialogs/quantityDialog.dart';

SpeedDialChild cartFloatingActionButton(
        BuildContext context,
        TextEditingController controller,
        GenericPageItem genericItem,
        Function(GenericPageItem item, int quantity) addToCart) =>
    SpeedDialChild(
      child: Padding(
        child: getListTileImage('fab/cart.png'),
        padding: const EdgeInsets.all(8),
      ),
      label: isDesktop ? getTranslations().fromKey(LocaleKey.cart) : null,
      foregroundColor: getTheme().fabForegroundColourSelector(context),
      backgroundColor: getTheme().fabColourSelector(context),
      onTap: () => showQuantityDialog(
        context,
        controller,
        onSuccess: (String quantity) {
          int intQuantity = int.tryParse(quantity);
          if (intQuantity == null) return;
          addToCart(genericItem, intQuantity);
        },
      ),
    );
