import '../contracts/processorRequiredItem.dart';
import '../contracts/processor.dart';
import '../contracts/requiredItem.dart';

List<RequiredItem> mapCookingToRequiredItemsWithDescrip(
    List<Processor> nutrientProcs) {
  if (nutrientProcs.isNotEmpty) {
    return nutrientProcs
        .map(
          (nutP) => ProcessorRequiredItem(
              id: nutP.output.id, processor: nutP, quantity: 0),
        )
        .toList();
  }
  return List.empty();
}
