import 'package:flutter/material.dart';

import '../../components/tilePresenters/processor_recipe_tile_presentor.dart';
import '../../contracts/processor.dart';
import '../../pages/generic/generic_page_processor_recipe.dart';

Widget nutrientProcessorRecipeWithInputsTilePresentor(
        BuildContext context, Processor processor,
        {bool showBackgroundColours = false}) =>
    processorRecipeWithInputsTilePresentor(
        context, processor, (p) => GenericPageProcessorRecipe(p),
        showBackgroundColours: showBackgroundColours);
