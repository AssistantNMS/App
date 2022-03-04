import '../contracts/processor.dart';
import '../contracts/requiredItemDetails.dart';

class ProcessorRequiredItemDetails extends RequiredItemDetails {
  Processor processor;

  ProcessorRequiredItemDetails(
      {id, icon, name, colour, quantity, this.processor}) {
    this.id = id;
    this.name = name;
    this.icon = icon;
    this.colour = colour;
    this.quantity = quantity;
  }
}
