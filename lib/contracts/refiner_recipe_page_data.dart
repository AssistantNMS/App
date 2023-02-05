import 'processor.dart';
import 'required_item_details.dart';

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
