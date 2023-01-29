import '../contracts/processor.dart';
import '../contracts/processor_required_item.dart';
import '../contracts/required_item.dart';

List<RequiredItem> mapRefinersToRequiredItemsWithDescrip(
    List<Processor> usedInRefiners) {
  if (usedInRefiners.isEmpty) {
    return List.empty();
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
