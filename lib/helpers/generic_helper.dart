import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart'
    hide ExternalUrls;
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../components/common/image.dart';
import '../../components/modalBottomSheet/dev_detail_modal_bottom_sheet.dart';
import '../components/currency_text.dart';
import '../components/floatingActionButton/cart_floating_action_button.dart';
import '../components/floatingActionButton/inventory_floating_action_button.dart';
import '../components/tilePresenters/generic_tile_presenter.dart';
import '../components/tilePresenters/required_item_tile_presenter.dart';
import '../constants/app_duration.dart';
import '../constants/app_image.dart';
import '../constants/id_prefix.dart';
import '../contracts/data/platform_control_mapping.dart';
import '../contracts/favourite/favourite_item.dart';
import '../contracts/generic_page_item.dart';
import '../pages/generic/generic_page_descrip_highlight_text.dart';

const int maxNumberOfRowsForRecipeCategory = 3;

Widget genericItemCredits(
  BuildContext context,
  String credits, {
  Color? colour,
}) =>
    genericItemWithListWidgets(
      CurrencyText(
        credits,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        addDecimal: false,
      ),
      LocalImage(
        imagePath: '${getPath().imageAssetPathPrefix}/credits.png',
        height: 17,
      ),
    );

Widget genericItemNanites(
  BuildContext context,
  String nanites, {
  Color? colour,
}) =>
    Container(
      child: genericItemIntCurrency(
        context,
        nanites,
        '${getPath().imageAssetPathPrefix}/nanites.png',
        colour: colour,
      ),
    );
Widget genericItemQuicksilver(
  BuildContext context,
  String quicksilver, {
  Color? colour,
}) =>
    genericItemIntCurrency(
      context,
      quicksilver,
      '${getPath().imageAssetPathPrefix}/rawMaterials/57.png',
      colour: colour,
    );
Widget genericItemSalvagedData(
  BuildContext context,
  String salvagedData, {
  Color? colour,
}) =>
    Container(
      child: genericItemIntCurrency(
        context,
        salvagedData,
        '${getPath().imageAssetPathPrefix}/constructedTechnology/90.png',
        colour: colour,
      ),
    );
Widget genericItemFactoryOverride(
  BuildContext context,
  String factoryOverrideAmount, {
  Color? colour,
}) =>
    Container(
      child: genericItemIntCurrency(
        context,
        factoryOverrideAmount,
        '${getPath().imageAssetPathPrefix}/${AppImage.factoryOverride}',
        colour: colour,
      ),
    );
Widget genericItemIntCurrency(
  BuildContext context,
  String currency,
  String imageUrl, {
  Color? colour,
}) =>
    genericItemWithListWidgets(
      Text(
        currency,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: getThemeBodyLarge(context) //
            ?.copyWith(
          color: colour ?? Colors.black,
        ),
      ),
      LocalImage(imagePath: imageUrl, height: 20),
    );

Widget genericItemTextWithIcon(
  BuildContext context,
  String text,
  IconData icon, {
  Color? colour,
  bool addSpace = true,
}) =>
    genericItemWithListWidgets(
      Text(
        text,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: getThemeBodyLarge(context)?.copyWith(color: colour),
      ),
      Container(
        child: Icon(icon, size: 18, color: colour),
        margin: const EdgeInsets.only(top: 1),
      ),
      addSpace: addSpace,
    );

Widget genericItemWithListWidgets(
  Widget first,
  Widget second, {
  bool addSpace = true,
}) =>
    Container(
      child: Wrap(alignment: WrapAlignment.center, children: [
        first,
        addSpace
            ? Padding(padding: const EdgeInsets.only(left: 5), child: second)
            : second,
      ]),
      margin: const EdgeInsets.all(4.0),
    );

Widget genericIconWithText(
  IconData icon,
  String text, {
  void Function()? onTap,
}) =>
    Row(
      children: [
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(icon),
          ),
          onTap: () {
            if (onTap != null) onTap();
          },
        ),
        Text(text),
      ],
    );

List<Widget> genericItemWithOverflowButton<T>(
  context,
  List<T> itemArray,
  Widget Function(BuildContext context, T item) presenter, {
  void Function()? viewMoreOnPress,
}) {
  int numRecords = itemArray.length > maxNumberOfRowsForRecipeCategory
      ? maxNumberOfRowsForRecipeCategory
      : itemArray.length;
  List<Widget> widgets = List.empty(growable: true);
  for (var itemIndex = 0; itemIndex < numRecords; itemIndex++) {
    widgets.add(FlatCard(
      child: presenter(context, itemArray[itemIndex]),
    ));
  }
  if (itemArray.length > maxNumberOfRowsForRecipeCategory &&
      viewMoreOnPress != null) {
    widgets.add(viewMoreButton(
      context,
      (itemArray.length - numRecords),
      viewMoreOnPress,
    ));
  }
  return widgets;
}

Widget viewMoreButton(context, int numLeftOver, viewMoreOnPress) {
  String viewMore = getTranslations().fromKey(LocaleKey.viewXMore);
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 4.0),
    child: PositiveButton(
      title: viewMore.replaceAll("{0}", numLeftOver.toString()),
      onTap: () {
        if (viewMoreOnPress == null) return;
        viewMoreOnPress();
      },
    ),
  );
}

Widget? getFloatingActionButtonFromSnapshot(
  BuildContext context,
  TextEditingController controller,
  AsyncSnapshot<ResultWithValue<GenericPageItem>> snapshot, {
  void Function(GenericPageItem item, int quantity)? addToCart,
}) {
  switch (snapshot.connectionState) {
    case ConnectionState.none:
    case ConnectionState.active:
    case ConnectionState.waiting:
      return null;
    case ConnectionState.done:
      if (snapshot.hasError) {
        return null;
      }
  }

  if (snapshot.data == null ||
      snapshot.data?.value == null ||
      snapshot.data?.value.name == null ||
      snapshot.data?.value.group == null ||
      snapshot.data?.value.description == null ||
      snapshot.data?.value.requiredItems == null ||
      snapshot.data?.value.refiners == null ||
      snapshot.data?.value.usedInRecipes == null ||
      snapshot.data?.value.usedInRefiners == null) {
    return null;
  }

  return getFloatingActionButton(
    context,
    controller,
    snapshot.data!.value,
    addToCart: addToCart,
  );
}

Widget? getFloatingActionButton(
  BuildContext context,
  TextEditingController controller,
  GenericPageItem genericItem, {
  void Function(GenericPageItem item, int quantity)? addToCart,
}) {
  if (genericItem.description == null ||
      genericItem.requiredItems == null ||
      genericItem.refiners == null ||
      genericItem.usedInRecipes == null ||
      genericItem.usedInRefiners == null) {
    return null;
  }

  List<SpeedDialChild> fabs = List.empty(growable: true);
  fabs.add(inventorySpeedDial(context, genericItem));
  if (!genericItem.id.contains(IdPrefix.cooking) && addToCart != null) {
    fabs.add(cartFloatingActionButton(
      context,
      controller,
      genericItem,
      addToCart,
    ));
  }
  if (fabs.isEmpty) return null;
  if (fabs.length == 1) {
    return inventoryFloatingActionButton(
      context,
      genericItem.id,
      controller,
      genericItem,
    );
  }

  Color colourStart = getTheme().fabColourSelector(context);
  return SpeedDial(
    icon: Icons.add,
    animatedIconTheme: const IconThemeData(size: 24.0),
    closeManually: false,
    curve: Curves.bounceIn,
    overlayColor: Colors.black,
    overlayOpacity: 0.5,
    tooltip: 'Speed Dial',
    heroTag: 'speed-dial-hero-tag',
    backgroundColor: colourStart,
    foregroundColor: getTheme().fabForegroundColourSelector(context),
    children: fabs,
  );
}

List<Widget> getConsumableRewards(
  context,
  List<String> consumableRewards,
  List<PlatformControlMapping>? controlLookup,
) {
  List<Widget> widgets = List.empty(growable: true);

  for (String consReward in consumableRewards) {
    widgets.add(const EmptySpace1x());
    widgets.addAll(
      genericPageDescripHighlightText(
        context,
        consReward,
        controlLookup ?? List.empty(),
      ),
    );
  }

  if (widgets.isEmpty) return widgets;

  return [
    const EmptySpace1x(),
    FlatCard(
      child: Column(
        children: [
          ...widgets,
          const EmptySpace1x(),
        ],
      ),
    ),
    const EmptySpace1x(),
  ];
}

Widget Function(BuildContext, GenericPageItem, {void Function()? onTap})
    getListItemDisplayer(
        bool genericTileIsCompact, bool displayGenericItemColour,
        {bool isHero = false}) {
  var presenterWithIsHero = displayGenericItemColour
      ? genericHomeTileWithRequiredItemsAndBackgroundColourPresenter
      : genericHomeTileWithRequiredItemsPresenter;

  if (genericTileIsCompact) {
    presenterWithIsHero = displayGenericItemColour
        ? genericTileWithBackgroundColourPresenter
        : genericTilePresenter;
  }
  return (BuildContext ctx, GenericPageItem item, {void Function()? onTap}) =>
      presenterWithIsHero(ctx, item, isHero, onTap: onTap);
}

Widget getFavouriteStar(
  String itemIcon,
  String itemId,
  List<FavouriteItem> favourites,
  Color iconColour,
  Function addFavourite,
  Function removeFavourite,
) {
  bool isFavourited = favourites.any((f) => f.id == itemId);
  IconButton favouriteStar = IconButton(
    icon: Icon(
      isFavourited ? Icons.star : Icons.star_border,
      color: iconColour,
    ),
    tooltip: isFavourited ? 'Unfavourite' : 'Favourite',
    onPressed: isFavourited
        ? () => removeFavourite(itemId)
        : () => addFavourite(
              FavouriteItem(icon: itemIcon, id: itemId),
            ),
  );
  return Positioned(
    top: 0,
    right: 0,
    child: animateWidgetIn(
      duration: AppDuration.genericIconFadeIn,
      child: favouriteStar,
    ),
  );
}

Widget getHdImage(
    BuildContext context, String itemIcon, String itemName, Color iconColour) {
  return Positioned(
    top: 0,
    left: 0,
    child: animateWidgetIn(
      duration: AppDuration.genericIconFadeIn,
      child: IconButton(
        icon: Icon(Icons.hd, color: iconColour),
        tooltip: 'HD image',
        onPressed: genericItemImageOnTap(
          context,
          itemIcon,
          false,
          itemName,
          true,
        ),
      ),
    ),
  );
}

Widget gridIconTilePresenter(BuildContext innerContext, String imageprefix,
        String imageAddress, Function(String icon) onTap) =>
    genericItemImage(
      innerContext,
      '$imageprefix$imageAddress',
      disableZoom: true,
      onTap: () => onTap(imageAddress),
    );

String removeAllNameVariables(String input) {
  return input
      .replaceAll('„%NAME%“-', '') //
      .replaceAll('„%NAME%“', '') //
      .replaceAll('%NAME%-', '') //
      .replaceAll('%NAME%', '');
}

Widget getDevSheet(
    BuildContext context, String itemId, Color iconColour, bool hdAvailable) {
  Widget iconBtn = animateWidgetIn(
    duration: AppDuration.genericIconFadeIn,
    child: IconButton(
      icon: Icon(Icons.code, color: iconColour),
      tooltip: 'Developer details',
      onPressed: () {
        adaptiveBottomModalSheet(
          context,
          hasRoundedCorners: true,
          builder: (BuildContext innerContext) => DevDetailBottomSheet(itemId),
        );
      },
    ),
  );

  return hdAvailable
      ? Positioned(left: 0, bottom: 0, child: iconBtn)
      : Positioned(left: 0, top: 0, child: iconBtn);
}
