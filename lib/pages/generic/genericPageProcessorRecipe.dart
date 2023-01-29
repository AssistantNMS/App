// ignore_for_file: unnecessary_null_comparison

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/contracts/required_item_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/common/image.dart';
import '../../components/common/text.dart';
import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/nutrient_processor_recipe_tile_presenter.dart';
import '../../components/tilePresenters/refiner_recipe_tile_presenter.dart';
import '../../constants/analytics_event.dart';
import '../../constants/id_prefix.dart';
import '../../constants/nms_ui_constants.dart';
import '../../contracts/processor.dart';
import '../../contracts/processor_recipe_page_data.dart';
import '../../contracts/redux/app_state.dart';
import '../../helpers/future_helper.dart';
import '../../helpers/generic_helper.dart';
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
    String title = processor.isRefiner
        ? getTranslations().fromKey(LocaleKey.refinedUsing)
        : getTranslations().fromKey(LocaleKey.cooking);
    return FutureBuilder<ResultWithValue<ProcessorRecipePageData>>(
      future: processorPageDetails(context, processor),
      builder: (processFutureCtx, snapshot) {
        return genericPageScaffold<ResultWithValue<ProcessorRecipePageData>>(
          processFutureCtx,
          title,
          snapshot,
          body: (bodyCtx, _) => StoreConnector<AppState, FavouriteViewModel>(
            converter: (store) => FavouriteViewModel.fromStore(store),
            builder: (buildCtx, viewModel) => getBody(
              buildCtx,
              viewModel,
              snapshot,
            ),
          ),
        );
      },
    );
  }

  Widget getBody(
    BuildContext bodyCtx,
    FavouriteViewModel vm,
    AsyncSnapshot<ResultWithValue<ProcessorRecipePageData>> snapshot,
  ) {
    Widget? errorWidget = asyncSnapshotHandler(bodyCtx, snapshot,
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

    commonOnTap(Widget child) => GestureDetector(
          child: child,
          onTap: () async => await getNavigation().navigateAsync(
            bodyCtx,
            navigateTo: (navCtx) => GenericPage(output.id),
          ),
        );

    Color iconColour = getOverlayColour(HexColor(output.colour ?? '#000'));
    widgets.add(Stack(
      children: [
        genericItemImage(bodyCtx, output.icon, hdAvailable: true),
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
      widgets.add(
        commonOnTap(
          genericItemNameWithQuantity(
            bodyCtx,
            output.name,
            output.quantity.toString(),
          ),
        ),
      );
    } else {
      widgets.add(commonOnTap(GenericItemName(output.name)));
    }

    widgets.add(commonOnTap(GenericItemText(processor.operation)));
    String timeToMake = getTranslations().fromKey(LocaleKey.timeToMake);
    String procInSeconds = getTranslations()
        .fromKey(LocaleKey.seconds)
        .replaceAll('{0}', processor.time);
    widgets.add(commonOnTap(
      GenericItemText("$timeToMake $procInSeconds"),
    ));

    widgets.add(Wrap(
      alignment: WrapAlignment.center,
      children: [
        commonOnTap(
          getBaseWidget().appChip(
            label: genericItemTextWithIcon(
              bodyCtx,
              output.name,
              Icons.chrome_reader_mode,
              colour: Colors.white,
            ),
          ),
        ),
      ],
    ));

    widgets.add(Container(margin: const EdgeInsets.all(12.0)));

    String inputsIngredientsLocale = processor.isRefiner
        ? getTranslations().fromKey(LocaleKey.inputs)
        : getTranslations().fromKey(LocaleKey.ingredients);
    widgets.add(GenericItemText(inputsIngredientsLocale));

    for (RequiredItemDetails input in snapshot.data!.value.inputsDetails) {
      widgets.add(
        FlatCard(
          child: genericListTile(
            bodyCtx,
            leadingImage: input.icon,
            name: input.name,
            quantity: input.quantity,
            borderRadius: NMSUIConstants.gameItemBorderRadius,
            onTap: () async => await getNavigation().navigateAsync(bodyCtx,
                navigateTo: (navCtx) => GenericPage(input.id)),
          ),
        ),
      );
    }

    List<Processor> otherRefinersArray = snapshot.data!.value.similarRefiners
        .where((sf) => sf.id != processor.id)
        .toList();
    if (otherRefinersArray.isNotEmpty) {
      widgets.add(Container(
        margin: const EdgeInsets.all(12.0),
      ));
      widgets.add(GenericItemText(
        getTranslations().fromKey(LocaleKey.similarRefinerRecipes),
      ));

      var presenter = output.id.contains(IdPrefix.nutrient)
          ? nutrientProcessorRecipeWithInputsTilePresentor
          : refinerRecipeTilePresenter;
      widgets.addAll(genericItemWithOverflowButton(
        bodyCtx,
        otherRefinersArray,
        presenter,
      ));
    }

    widgets.add(const EmptySpace8x());

    return listWithScrollbar(
      itemCount: widgets.length,
      itemBuilder: (listCtx, index) => widgets[index],
      scrollController: ScrollController(),
    );
  }
}
