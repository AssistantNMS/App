import 'processor.dart';
import 'required_item_details.dart';

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
