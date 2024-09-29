import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/common/image.dart';
import '../../constants/usage_key.dart';
import '../../contracts/generic_page_item.dart';
import '../../contracts/redux/app_state.dart';
import '../../helpers/generic_helper.dart';
import '../../helpers/hero_helper.dart';
import '../../redux/modules/generic/generic_page_fav_view_model.dart';

class GenericTopContent extends StatelessWidget {
  final GenericPageItem genericItem;
  const GenericTopContent({
    required this.genericItem,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hdAvailable = genericItem.cdnUrl != null && //
        genericItem.cdnUrl!.isNotEmpty;
    Color iconColour = getOverlayColour(HexColor(genericItem.colour));

    return StoreConnector<AppState, GenericPageFavViewModel>(
      converter: (store) => GenericPageFavViewModel.fromStore(store),
      builder: (storeCtx, viewModel) {
        List<Widget> stackWidgets = List.empty(growable: true);

        if (viewModel.displayGenericItemColour == false) {
          iconColour = Colors.white;
        }

        if (viewModel.displayGenericItemColour) {
          Widget itemWithBackground = KeyedSubtree(
            key: Key('${genericItem.id}-img-with-bg'),
            child: genericItemImageWithBackground(
              context,
              genericItem,
              hdAvailable: hdAvailable,
            ),
          );
          stackWidgets.add(itemWithBackground);
        } else {
          Widget itemImage = KeyedSubtree(
            key: Key('${genericItem.id}-img'),
            child: genericItemImage(
              context,
              genericItem.icon,
              imageHero: gameItemIconHero(genericItem),
              name: genericItem.name,
              hdAvailable: hdAvailable,
            ),
          );
          stackWidgets.add(itemImage);
        }

        if (hdAvailable) {
          Widget hdAvailable = KeyedSubtree(
            key: Key('${genericItem.id}-hd-available'),
            child: getHdImage(
              context,
              genericItem.icon,
              genericItem.name,
              iconColour,
            ),
          );
          stackWidgets.add(hdAvailable);
        }

        stackWidgets.add(
          getFavouriteStar(
            genericItem.icon,
            genericItem.id,
            viewModel.favourites,
            iconColour,
            viewModel.addFavourite,
            viewModel.removeFavourite,
          ),
        );

        if ((genericItem.usage ?? []).contains(UsageKey.hasDevProperties)) {
          Widget devSheet = KeyedSubtree(
            key: Key('${genericItem.id}-hd-dev-sheet'),
            child: getDevSheet(
              context,
              genericItem.id,
              iconColour,
              hdAvailable,
            ),
          );
          stackWidgets.add(devSheet);
        }

        return Stack(
          key: Key('${genericItem.id}-bg-stack'),
          children: stackWidgets,
        );
      },
    );
  }
}
