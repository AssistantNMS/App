import 'processor.dart';
import 'requiredItemDetails.dart';

class ProcessorRecipePageData {
  String procId;
  RequiredItemDetails outputDetail;
  List<RequiredItemDetails> inputsDetails;
  List<Processor> similarRefiners;

  ProcessorRecipePageData({
    required this.procId,
    required this.outputDetail,
    required this.inputsDetails,
    required this.similarRefiners,
  });
}
