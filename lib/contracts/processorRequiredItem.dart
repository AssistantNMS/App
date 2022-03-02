import '../contracts/processor.dart';
import '../contracts/requiredItem.dart';

class ProcessorRequiredItem extends RequiredItem {
  Processor processor;

  ProcessorRequiredItem({id, quantity, description, processor}) {
    this.id = id;
    this.quantity = quantity;
    this.processor = processor;
  }
}
