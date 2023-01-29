import 'package:flutter/material.dart';

import '../../components/tilePresenters/processor_recipe_tile_presentor.dart';
import '../../contracts/processor.dart';
import '../../pages/generic/genericPageProcessorRecipe.dart';

Widget refinerRecipeTilePresenter(BuildContext context, Processor processor,
    {bool showBackgroundColours = false}) {
  return processorRecipeWithInputsTilePresentor(
    context,
    processor,
    (r) => GenericPageProcessorRecipe(r),
    showBackgroundColours: showBackgroundColours,
  );
}
