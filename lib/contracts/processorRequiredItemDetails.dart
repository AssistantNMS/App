import '../contracts/processor.dart';
import '../contracts/requiredItemDetails.dart';

class ProcessorRequiredItemDetails extends RequiredItemDetails {
  Processor processor;

  ProcessorRequiredItemDetails({
    id,
    icon,
    name,
    colour,
    quantity,
    required this.processor,
  }) : super(
          id: id,
          name: name,
          icon: icon,
          colour: colour,
          quantity: quantity,
        );
}
