import 'processor.dart';
import 'requiredItemDetails.dart';

class RefinerRecipePageData {
  RequiredItemDetails outputDetail;
  List<RequiredItemDetails> inputsDetails;
  List<Processor> similarRefiners;

  RefinerRecipePageData({
    required this.outputDetail,
    required this.inputsDetails,
    required this.similarRefiners,
  });
}
