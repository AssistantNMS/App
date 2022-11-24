import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart'
    hide ExternalUrls;
import 'package:assistantnms_app/helpers/themeHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../components/common/image.dart';
import '../../components/modalBottomSheet/devDetailModalBottomSheet.dart';

import '../components/currencyText.dart';
import '../components/floatingActionButton/cartFloatingActionButton.dart';
import '../components/floatingActionButton/inventoryFloatingActionButton.dart';
import '../components/tilePresenters/genericTilePresenter.dart';
import '../components/tilePresenters/requiredItemTilePresenter.dart';
import '../constants/AppDuration.dart';
import '../constants/AppImage.dart';
import '../constants/IdPrefix.dart';
import '../contracts/data/platformControlMapping.dart';
import '../contracts/favourite/favouriteItem.dart';
import '../contracts/genericPageItem.dart';
import '../pages/generic/genericPageDescripHighlightText.dart';

const int maxNumberOfRowsForRecipeCategory = 3;

Widget genericItemCredits(BuildContext context, String credits,
        {Color colour}) =>
    genericItemWithListWidgets(
      CurrencyText(
        credits,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        addDecimal: false,
        style: getThemeBodyLarge(context).copyWith(color: colour),
      ),
      localImage('${getPath().imageAssetPathPrefix}/credits.png', height: 17),
    );

Widget genericItemNanites(BuildContext context, String nanites,
        {Color colour}) =>
    Container(
      child: genericItemIntCurrency(
        context,
        nanites,
        '${getPath().imageAssetPathPrefix}/nanites.png',
        colour: colour,
      ),
    );
Widget genericItemQuicksilver(BuildContext context, String quicksilver,
        {Color colour}) =>
    genericItemIntCurrency(
      context,
      quicksilver,
      '${getPath().imageAssetPathPrefix}/rawMaterials/57.png',
      colour: colour,
    );
Widget genericItemSalvagedData(BuildContext context, String salvagedData,
        {Color colour}) =>
    Container(
      child: genericItemIntCurrency(
        context,
        salvagedData,
        '${getPath().imageAssetPathPrefix}/constructedTechnology/90.png',
        colour: colour,
      ),
    );
Widget genericItemFactoryOverride(
        BuildContext context, String factoryOverrideAmount,
        {Color colour}) =>
    Container(
      child: genericItemIntCurrency(
        context,
        factoryOverrideAmount,
        '${getPath().imageAssetPathPrefix}/${AppImage.factoryOverride}',
        colour: colour,
      ),
    );
Widget genericItemIntCurrency(
        BuildContext context, String currency, String imageUrl,
        {Color colour}) =>
    genericItemWithListWidgets(
      Text(
        currency,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: getThemeBodyLarge(context).copyWith(color: colour),
      ),
      localImage(imageUrl, height: 17),
    );

Widget genericItemTextWithIcon(BuildContext context, String text, IconData icon,
        {Color colour, bool addSpace = true}) =>
    genericItemWithListWidgets(
      Text(
        text,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: getThemeBodyLarge(context).copyWith(color: colour),
      ),
      Icon(icon, size: 17, color: colour),
      addSpace: addSpace,
    );

Widget genericItemWithListWidgets(Widget first, Widget second,
        {bool addSpace = true}) =>
    Container(
      child: Wrap(alignment: WrapAlignment.center, children: [
        first,
        addSpace
            ? Padding(padding: const EdgeInsets.only(left: 5), child: second)
            : second,
      ]),
      margin: const EdgeInsets.all(4.0),
    );

Widget genericIconWithText(IconData icon, String text, {Function onTap}) => Row(
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

List<Widget> genericItemWithOverflowButton<T>(context, List<T> itemArray,
    Widget Function(BuildContext context, T item) presenter,
    {Function viewMoreOnPress}) {
  int numRecords = itemArray.length > maxNumberOfRowsForRecipeCategory
      ? maxNumberOfRowsForRecipeCategory
      : itemArray.length;
  List<Widget> widgets = List.empty(growable: true);
  for (var itemIndex = 0; itemIndex < numRecords; itemIndex++) {
    widgets.add(flatCard(
      child: presenter(context, itemArray[itemIndex]),
    ));
  }
  if (itemArray.length > maxNumberOfRowsForRecipeCategory &&
      viewMoreOnPress != null) {
    widgets.add(viewMoreButton(
        context, (itemArray.length - numRecords), viewMoreOnPress));
  }
  return widgets;
}

Widget viewMoreButton(context, int numLeftOver, viewMoreOnPress) {
  String viewMore = getTranslations().fromKey(LocaleKey.viewXMore);
  return Container(
    child: positiveButton(
      context,
      title: viewMore.replaceAll("{0}", numLeftOver.toString()),
      onPress: () {
        if (viewMoreOnPress == null) return;
        viewMoreOnPress();
      },
    ),
  );
}

Widget getFloatingActionButtonFromSnapshot(
    BuildContext context,
    TextEditingController controller,
    AsyncSnapshot<ResultWithValue<GenericPageItem>> snapshot) {
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
      snapshot.data.value == null ||
      snapshot.data.value.name == null ||
      snapshot.data.value.group == null ||
      snapshot.data.value.description == null ||
      snapshot.data.value.requiredItems == null ||
      snapshot.data.value.refiners == null ||
      snapshot.data.value.usedInRecipes == null ||
      snapshot.data.value.usedInRefiners == null) {
    return null;
  }

  return getFloatingActionButton(context, controller, snapshot.data.value);
}

Widget getFloatingActionButton(
  BuildContext context,
  TextEditingController controller,
  GenericPageItem genericItem, {
  Function(GenericPageItem item, int quantity) addToCart,
}) {
  if (genericItem.name == null ||
      genericItem.group == null ||
      genericItem.description == null ||
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
    animatedIcon: AnimatedIcons.menu_close,
    animatedIconTheme: const IconThemeData(size: 22.0),
    closeManually: false,
    curve: Curves.bounceIn,
    overlayColor: Colors.black,
    overlayOpacity: 0.5,
    childMargin: const EdgeInsets.only(right: 12, bottom: 12),
    tooltip: 'Speed Dial',
    heroTag: 'speed-dial-hero-tag',
    backgroundColor: colourStart,
    foregroundColor: getTheme().fabForegroundColourSelector(context),
    children: fabs,
  );
}

Widget genericChip(context, String title, {Color color, Function onTap}) =>
    genericChipWidget(context, Text(title), color: color, onTap: onTap);

Widget genericChipWidget(context, Widget content,
    {Color color, Function onTap}) {
  var child = Padding(
    child: Chip(
      label: content,
      backgroundColor: color ?? getTheme().getSecondaryColour(context),
    ),
    padding: const EdgeInsets.only(left: 4),
  );
  return (onTap == null) ? child : GestureDetector(child: child, onTap: onTap);
}

List<Widget> getConsumableRewards(context, List<String> consumableRewards,
    List<PlatformControlMapping> controlLookup) {
  List<Widget> widgets = List.empty(growable: true);

  for (String consReward in consumableRewards) {
    widgets.add(emptySpace1x());
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
    emptySpace1x(),
    flatCard(
      child: Column(
        children: [
          ...widgets,
          emptySpace1x(),
        ],
      ),
    ),
    emptySpace1x(),
  ];
}

Widget Function(BuildContext, GenericPageItem, {void Function() onTap})
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
  return (BuildContext ctx, GenericPageItem item, {void Function() onTap}) =>
      presenterWithIsHero(ctx, item, isHero, onTap: onTap);
}

// Widget Function(BuildContext, GenericPageItem, int)
//     getResponsiveListItemDisplayer(
//         bool genericTileIsCompact, bool displayGenericItemColour,
//         {void Function() onTap, bool isHero = false}) {
//   var presenterWithIsHero = displayGenericItemColour
//       ? genericHomeTileWithRequiredItemsAndBackgroundColourPresenter
//       : genericHomeTileWithRequiredItemsPresenter;

//   if (genericTileIsCompact) {
//     presenterWithIsHero = displayGenericItemColour
//         ? genericTileWithBackgroundColourPresenter
//         : genericTilePresenter;
//   }
//   return (BuildContext ctx, GenericPageItem item, int index) =>
//       presenterWithIsHero(ctx, item, isHero, onTap: onTap);
// }

Widget getFavouriteStar(
    String itemIcon,
    String itemId,
    List<FavouriteItem> favourites,
    Color iconColour,
    Function addFavourite,
    Function removeFavourite) {
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
