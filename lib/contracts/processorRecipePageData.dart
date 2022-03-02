import 'processor.dart';
import 'requiredItemDetails.dart';

class ProcessorRecipePageData {
  String procId;
  RequiredItemDetails outputDetail;
  List<RequiredItemDetails> inputsDetails;
  List<Processor> similarRefiners;

  ProcessorRecipePageData(
      {this.procId,
      this.outputDetail,
      this.inputsDetails,
      this.similarRefiners});
}
