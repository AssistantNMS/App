import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart'
    hide GuideApiService;
import 'package:get_it/get_it.dart';

import '../../services/base/language_service.dart';
import '../env/environment_settings.dart';
import '../services/api/community_api_service.dart';
import '../services/api/community_mission_progress_api_service.dart';
import '../services/api/contributor_api_service.dart';
import '../services/api/guide_api_service.dart';
import '../services/api/hello_games_api_service.dart';
import '../services/base/analytics_service.dart';
import '../services/base/audio_player_service._windows.dart';
import '../services/base/audio_player_service.dart';
import '../services/base/base_widget_service.dart';
import '../services/base/dialog_service.dart';
import '../services/base/firebase_service.dart';
import '../services/base/interface/i_audio_player_service.dart';
import '../services/base/loading_widget_service.dart';
import '../services/base/local_notification_service.dart';
import '../services/base/notification_service.dart';
import '../services/base/path_service.dart';
import '../services/base/theme_service.dart';
import '../services/json/alien_puzzle_repository.dart';
import '../services/json/alien_puzzle_rewards_json_repository.dart';
import '../services/json/creature_harvest_json_repository.dart';
import '../services/json/data_json_repository.dart';
import '../services/json/faction_json_repository.dart';
import '../services/json/generic_json_repository.dart';
import '../services/json/recharge_json_repository.dart';
import '../services/json/refinery_json_repository.dart';
import '../services/json/seasonal_expedition_json_repository.dart';
import '../services/json/tech_tree_json_repository.dart';
import '../services/json/title_json_repository.dart';
import '../services/json/interface/IAlienPuzzleJsonRepository.dart';
import '../services/json/interface/IAlienPuzzleRewardsJsonRepository.dart';
import '../services/json/interface/ICreatureHarvestJsonRepository.dart';
import '../services/json/interface/IDataJsonRepository.dart';
import '../services/json/interface/IFactionJsonRepository.dart';
import '../services/json/interface/IGenericRepository.dart';
import '../services/json/interface/IRechargeJsonRepository.dart';
import '../services/json/interface/IRefineryRepository.dart';
import '../services/json/interface/ISeasonalExpeditionJsonRepository.dart';
import '../services/json/interface/ITechTreeJsonRepository.dart';
import '../services/json/interface/ITitleJsonRepository.dart';
import 'app_api.dart';

final getIt = GetIt.instance;

void initDependencyInjection(EnvironmentSettings _env) {
  getIt.registerSingleton<EnvironmentSettings>(_env);

  // AssistantApps
  initAssistantAppsDependencyInjection(
    _env.toAssistantApps(),
    analytics: AnalyticsService(),
    theme: ThemeService(),
    notification: NotificationService(),
    path: PathService(),
    baseWidget: BaseWidgetService(),
    dialog: DialogService(),
    loading: LoadingWidgetService(),
    language: LanguageService(),
    // snackbar: SnackbarService(),
  );

  getIt.registerFactoryParam<IGenericRepository, LocaleKey, String>(
    (LocaleKey key, String unused) => GenericJsonRepository(key),
  );
  getIt.registerFactoryParam<IRefineryRepository, LocaleKey, bool>(
    (LocaleKey key, bool isRefiner) => RefineryJsonRepository(key, isRefiner),
  );
  getIt.registerSingleton<IDataJsonRepository>(DataJsonRepository());
  getIt.registerSingleton<ITechTreeJsonRepository>(TechTreeJsonRepository());
  getIt.registerSingleton<IRechargeJsonRepository>(RechargeJsonRepository());
  getIt.registerSingleton<ITitleJsonRepository>(TitleJsonRepository());
  getIt.registerSingleton<IAlienPuzzleJsonRepository>(
      AlienPuzzleJsonRepository());
  getIt.registerSingleton<IAlienPuzzleRewardsJsonRepository>(
      AlienPuzzleRewardsJsonRepository());
  getIt.registerSingleton<ISeasonalExpeditionJsonRepository>(
      SeasonalExpeditionJsonRepository());
  getIt.registerSingleton<IFactionJsonRepository>(FactionJsonRepository());
  getIt.registerSingleton<ICreatureHarvestJsonRepository>(
      CreatureHarvestJsonRepository());

  getIt.registerSingleton<IAudioPlayerService>(
    isWindows ? WindowsAudioPlayerService() : AudioPlayerService(),
  );
  getIt.registerSingleton<LocalNotificationService>(LocalNotificationService());
  getIt.registerSingleton<FirebaseService>(FirebaseService());

  getIt.registerSingleton<AppApi>(AppApi());
  getIt.registerSingleton<GuideApiService>(GuideApiService());
  getIt.registerSingleton<CommunityApiService>(CommunityApiService());
  getIt.registerSingleton<HelloGamesApiService>(HelloGamesApiService());
  getIt.registerSingleton<ContributorApiService>(ContributorApiService());
  getIt.registerSingleton<CommunityMissionProgressApiService>(
      CommunityMissionProgressApiService());
}

EnvironmentSettings getEnv() => getIt<EnvironmentSettings>();

IGenericRepository getGenericRepo(LocaleKey? key) =>
    getIt<IGenericRepository>(param1: key, param2: 'di');

IRefineryRepository getProcessorRepo(bool isRefiner) =>
    isRefiner ? getRefinerRepo() : getNutrientRepo();
IRefineryRepository getRefinerRepo() =>
    getIt<IRefineryRepository>(param1: LocaleKey.refineryJson, param2: true);
IRefineryRepository getNutrientRepo() => getIt<IRefineryRepository>(
    param1: LocaleKey.nutrientProcessorJson, param2: false);

IDataJsonRepository getDataRepo() => getIt<IDataJsonRepository>();
ITechTreeJsonRepository getTechTreeRepo() => getIt<ITechTreeJsonRepository>();
IRechargeJsonRepository getRechargeRepo() => getIt<IRechargeJsonRepository>();
ITitleJsonRepository getTitleRepo() => getIt<ITitleJsonRepository>();
IAlienPuzzleJsonRepository getAlienPuzzleRepo() =>
    getIt<IAlienPuzzleJsonRepository>();
IAlienPuzzleRewardsJsonRepository getAlienPuzzleRewardsRepo() =>
    getIt<IAlienPuzzleRewardsJsonRepository>();
ISeasonalExpeditionJsonRepository getSeasonalExpeditionRepo() =>
    getIt<ISeasonalExpeditionJsonRepository>();
IFactionJsonRepository getFactionRepo() => getIt<IFactionJsonRepository>();
ICreatureHarvestJsonRepository getCreatureHarvestRepo() =>
    getIt<ICreatureHarvestJsonRepository>();

IAudioPlayerService getAudioPlayer() => getIt<IAudioPlayerService>();
LocalNotificationService getLocalNotification() =>
    getIt<LocalNotificationService>();
FirebaseService getFirebase() => getIt<FirebaseService>();

AppApi getApiRepo() => getIt<AppApi>();
GuideApiService getGuideApiService() => getIt<GuideApiService>();
CommunityApiService getCommunityApiService() => getIt<CommunityApiService>();
HelloGamesApiService getHelloGamesApiService() => getIt<HelloGamesApiService>();
ContributorApiService getContributorApiService() =>
    getIt<ContributorApiService>();
CommunityMissionProgressApiService getCommunityMissionProgressApiService() =>
    getIt<CommunityMissionProgressApiService>();
