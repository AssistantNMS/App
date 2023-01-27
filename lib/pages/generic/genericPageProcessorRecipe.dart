// ignore_for_file: unnecessary_null_comparison

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/common/image.dart';
import '../../components/common/text.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/nutrientProcessorRecipeTilePresenter.dart';
import '../../components/tilePresenters/refinerRecipeTilePresenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../constants/IdPrefix.dart';
import '../../constants/NmsUIConstants.dart';
import '../../contracts/processor.dart';
import '../../contracts/processorRecipePageData.dart';
import '../../contracts/redux/appState.dart';
import '../../helpers/futureHelper.dart';
import '../../helpers/genericHelper.dart';
import '../../redux/modules/favourite/favouriteViewModel.dart';
import 'genericPage.dart';

class GenericPageProcessorRecipe extends StatelessWidget {
  final Processor processor;

  GenericPageProcessorRecipe(this.processor, {Key? key}) : super(key: key) {
    String key = '${AnalyticsEvent.processorRecipePage}: ${processor.id}';
    getAnalytics().trackEvent(key);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ResultWithValue<ProcessorRecipePageData>>(
      future: processorPageDetails(context, processor),
      builder: (BuildContext context,
          AsyncSnapshot<ResultWithValue<ProcessorRecipePageData>> snapshot) {
        return genericPageScaffold<ResultWithValue<ProcessorRecipePageData>>(
            context,
            processor.isRefiner
                ? getTranslations().fromKey(LocaleKey.refinedUsing)
                : getTranslations().fromKey(LocaleKey.cooking),
            snapshot,
            body: (BuildContext context,
                    AsyncSnapshot<ResultWithValue<ProcessorRecipePageData>>
                        snapshot) =>
                StoreConnector<AppState, FavouriteViewModel>(
                    converter: (store) => FavouriteViewModel.fromStore(store),
                    builder: (_, viewModel) =>
                        getBody(context, viewModel, snapshot)));
      },
    );
  }

  Widget getBody(BuildContext context, FavouriteViewModel vm,
      AsyncSnapshot<ResultWithValue<ProcessorRecipePageData>> snapshot) {
    Widget? errorWidget = asyncSnapshotHandler(context, snapshot,
        isValidFunction: (ResultWithValue<ProcessorRecipePageData>? data) {
      if (data == null ||
          data.value == null ||
          data.value.inputsDetails == null ||
          data.value.outputDetail == null ||
          data.value.outputDetail.id == null ||
          data.value.outputDetail.name == null ||
          data.value.outputDetail.icon == null ||
          data.value.similarRefiners == null ||
          processor.time == null ||
          processor.operation == null) {
        return false;
      }
      return true;
    });
    if (errorWidget != null) return errorWidget;

    List<Widget> widgets = List.empty(growable: true);
    var output = snapshot.data!.value.outputDetail;

    gestureDetector(Widget child) => GestureDetector(
          child: child,
          onTap: () async => await getNavigation().navigateAsync(
            context,
            navigateTo: (context) => GenericPage(output.id),
          ),
        );

    Color iconColour = getOverlayColour(HexColor(output.colour ?? '#000'));
    widgets.add(Stack(
      children: [
        genericItemImage(context, output.icon, hdAvailable: true),
        getFavouriteStar(
          output.icon,
          snapshot.data!.value.procId,
          vm.favourites,
          iconColour,
          vm.addFavourite,
          vm.removeFavourite,
        )
      ],
    ));
    if (output.quantity > 1) {
      widgets.add(gestureDetector(genericItemNameWithQuantity(
          context, output.name, output.quantity.toString())));
    } else {
      widgets.add(gestureDetector(genericItemName(output.name)));
    }

    widgets.add(gestureDetector(genericItemText(processor.operation)));
    String timeToMake = getTranslations().fromKey(LocaleKey.timeToMake);
    String procInSeconds = getTranslations()
        .fromKey(LocaleKey.seconds)
        .replaceAll('{0}', processor.time);
    widgets.add(gestureDetector(
      genericItemText("$timeToMake $procInSeconds"),
    ));

    widgets.add(Wrap(
      alignment: WrapAlignment.center,
      children: [
        gestureDetector(
          getBaseWidget().appChip(
            label: genericItemTextWithIcon(
              context,
              output.name,
              Icons.chrome_reader_mode,
              colour: Colors.white,
            ),
          ),
        ),
      ],
    ));

    widgets.add(Container(
      margin: const EdgeInsets.all(12.0),
    ));

    var inputsIngredientsLocale = processor.isRefiner
        ? getTranslations().fromKey(LocaleKey.inputs)
        : getTranslations().fromKey(LocaleKey.ingredients);
    widgets.add(genericItemText(inputsIngredientsLocale));

    for (var input in snapshot.data!.value.inputsDetails) {
      widgets.add(
        Card(
          child: genericListTile(
            context,
            leadingImage: input.icon,
            name: input.name,
            quantity: input.quantity,
            borderRadius: NMSUIConstants.gameItemBorderRadius,
            onTap: () async => await getNavigation().navigateAsync(context,
                navigateTo: (context) => GenericPage(input.id)),
          ),
          margin: const EdgeInsets.all(0.0),
        ),
      );
    }

    var otherRefinersArray = snapshot.data!.value.similarRefiners
        .where((sf) => sf.id != processor.id)
        .toList();
    if (otherRefinersArray.isNotEmpty) {
      widgets.add(Container(
        margin: const EdgeInsets.all(12.0),
      ));
      widgets.add(genericItemText(
          getTranslations().fromKey(LocaleKey.similarRefinerRecipes)));

      var presenter = output.id.contains(IdPrefix.nutrient)
          ? nutrientProcessorRecipeWithInputsTilePresentor
          : refinerRecipeTilePresenter;
      widgets.addAll(genericItemWithOverflowButton(
        context,
        otherRefinersArray,
        presenter,
      ));
    }

    widgets.add(emptySpace8x());

    return listWithScrollbar(
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
      scrollController: ScrollController(),
    );
  }
}
