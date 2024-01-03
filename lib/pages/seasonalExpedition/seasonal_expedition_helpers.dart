import '../../constants/app_image.dart';
import '../../contracts/seasonalExpedition/seasonal_expedition_season.dart';
import '../../contracts/seasonalExpedition/seasonal_expedition_title.dart';

SeasonalExpeditionSeasonTitle detailsFromExpeditionId(
  SeasonalExpeditionSeason jsonExp,
) {
  RegExp exp = RegExp(r'(seas-){1}(\d+)(-redux)?(\d+)?');
  RegExpMatch? match = exp.firstMatch(jsonExp.id);

  SeasonalExpeditionSeasonTitle result = SeasonalExpeditionSeasonTitle(
    id: '',
    reduxNum: 0,
    reduxSuffix: '',
    icon: AppImage.expeditionSeasonBackgroundBackup,
  );

  if (match == null) return result;

  if (match.groupCount >= 2) {
    String? seasIdGrp2 = match.group(2);
    if (seasIdGrp2 != null) {
      result.id = seasIdGrp2;
    }
  }

  if (match.groupCount == 4) {
    String? reduxNum = match.group(4);
    if (reduxNum != null) {
      result.reduxNum = int.tryParse(reduxNum) ?? 0;
    }
  }

  if (jsonExp.isRedux) {
    result.reduxSuffix = ' (Redux)';

    if (result.reduxNum > 1) {
      result.reduxSuffix = ' (Redux #${result.reduxNum})';
    }
  }

  result.icon =
      AppImage.expeditionSeasonBackgroundPrefix + 'seas-${result.id}.jpg';

  return result;
}
