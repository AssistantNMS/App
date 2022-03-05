import '../contracts/processor.dart';
import '../contracts/processorRequiredItem.dart';
import '../contracts/requiredItem.dart';

List<RequiredItem> mapRefinersToRequiredItemsWithDescrip(
    List<Processor> usedInRefiners) {
  if (usedInRefiners == null || usedInRefiners.isEmpty) {
    return List.empty(growable: true);
  }
  List<RequiredItem> requiredItems = List.empty(growable: true);
  for (var refiner in usedInRefiners) {
    requiredItems.add(
      ProcessorRequiredItem(
          id: refiner.output.id,
          description: refiner.operation,
          processor: refiner,
          quantity: 0),
    );
  }
  return requiredItems;
}
