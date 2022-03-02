import 'processor.dart';
import 'requiredItemDetails.dart';

class RefinerRecipePageData {
  RequiredItemDetails outputDetail;
  List<RequiredItemDetails> inputsDetails;
  List<Processor> similarRefiners;

  RefinerRecipePageData(
      {this.outputDetail, this.inputsDetails, this.similarRefiners});
}
