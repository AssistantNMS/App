import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart'
    hide GuideApiService;
import 'package:get_it/get_it.dart';

import '../../services/base/languageService.dart';
import '../env/environmentSettings.dart';
import '../services/api/communityApiService.dart';
import '../services/api/contributorApiService.dart';
import '../services/api/guideApiService.dart';
import '../services/api/helloGamesApiService.dart';
import '../services/base/analyticsService.dart';
import '../services/base/audioPlayerService.Windows.dart';
import '../services/base/audioPlayerService.dart';
import '../services/base/baseWidgetService.dart';
import '../services/base/dialogService.dart';
import '../services/base/firebaseService.dart';
import '../services/base/interface/IAudioPlayerService.dart';
import '../services/base/loadingWidgetService.dart';
import '../services/base/localNotificationService.dart';
import '../services/base/notificationService.dart';
import '../services/base/pathService.dart';
import '../services/base/themeService.dart';
import '../services/json/AlienPuzzleRepository.dart';
import '../services/json/AlienPuzzleRewardsJsonRepository.dart';
import '../services/json/CreatureHarvestJsonRepository.dart';
import '../services/json/DataJsonRepository.dart';
import '../services/json/ExploitJsonRepository.dart';
import '../services/json/FactionJsonRepository.dart';
import '../services/json/GenericJsonRepository.dart';
import '../services/json/RechargeJsonRepository.dart';
import '../services/json/RefineryJsonRepository.dart';
import '../services/json/SeasonalExpeditionJsonRepository.dart';
import '../services/json/TechTreeJsonRepository.dart';
import '../services/json/TitleJsonRepository.dart';
import '../services/json/interface/IAlienPuzzleJsonRepository.dart';
import '../services/json/interface/IAlienPuzzleRewardsJsonRepository.dart';
import '../services/json/interface/ICreatureHarvestJsonRepository.dart';
import '../services/json/interface/IDataJsonRepository.dart';
import '../services/json/interface/IExploitRepository.dart';
import '../services/json/interface/IFactionJsonRepository.dart';
import '../services/json/interface/IGenericRepository.dart';
import '../services/json/interface/IRechargeJsonRepository.dart';
import '../services/json/interface/IRefineryRepository.dart';
import '../services/json/interface/ISeasonalExpeditionJsonRepository.dart';
import '../services/json/interface/ITechTreeJsonRepository.dart';
import '../services/json/interface/ITitleJsonRepository.dart';
import 'appApi.dart';

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
  getIt.registerSingleton<IExploitRepository>(ExploitJsonRepository());
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
}

EnvironmentSettings getEnv() => getIt<EnvironmentSettings>();

IGenericRepository getGenericRepo(LocaleKey key) =>
    getIt<IGenericRepository>(param1: key, param2: 'di');

IRefineryRepository getProcessorRepo(bool isRefiner) =>
    isRefiner ? getRefinerRepo() : getNutrientRepo();
IRefineryRepository getRefinerRepo() =>
    getIt<IRefineryRepository>(param1: LocaleKey.refineryJson, param2: true);
IRefineryRepository getNutrientRepo() => getIt<IRefineryRepository>(
    param1: LocaleKey.nutrientProcessorJson, param2: false);

IExploitRepository getExploitRepo() => getIt<IExploitRepository>();
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
