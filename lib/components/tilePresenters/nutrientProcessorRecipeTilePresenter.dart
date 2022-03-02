import 'package:flutter/material.dart';

import '../../components/tilePresenters/processorRecipeTilePresentor.dart';
import '../../contracts/processor.dart';
import '../../pages/generic/genericPageProcessorRecipe.dart';

Widget nutrientProcessorRecipeWithInputsTilePresentor(
        BuildContext context, Processor processor,
        {bool showBackgroundColours = false}) =>
    processorRecipeWithInputsTilePresentor(
        context, processor, (p) => GenericPageProcessorRecipe(p),
        showBackgroundColours: showBackgroundColours);
