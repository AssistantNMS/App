import '../contracts/processor.dart';
import '../contracts/required_item.dart';

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
