import '../contracts/processor.dart';
import '../contracts/requiredItem.dart';

class ProcessorRequiredItem extends RequiredItem {
  Processor processor;

  ProcessorRequiredItem({
    id,
    quantity,
    description,
    required this.processor,
  }) : super(
          id: id,
          quantity: quantity,
        );
}
