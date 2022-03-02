import '../contracts/processorRequiredItem.dart';
import '../contracts/processor.dart';
import '../contracts/requiredItem.dart';

List<RequiredItem> mapCookingToRequiredItemsWithDescrip(
        List<Processor> nutrientProcs) =>
    (nutrientProcs == null || nutrientProcs.length < 1)
        ? List.empty(growable: true)
        : nutrientProcs
            .map(
              (nutP) => ProcessorRequiredItem(
                  id: nutP.output.id, processor: nutP, quantity: 0),
            )
            .toList();
