import 'package:meta/meta.dart';

import 'cartState.dart';
import 'expeditionState.dart';
import 'favouriteState.dart';
import 'inventoryState.dart';
import 'journeyMilestoneState.dart';
import 'portalState.dart';
import 'settingState.dart';
import 'timerState.dart';
import 'titleState.dart';

@immutable
class AppState {
  final CartState cartState;
  final PortalState portalState;
  final SettingState settingState;
  final InventoryState inventoryState;
  final FavouriteState favouriteState;
  final TimerState timerState;
  final TitleState titleState;
  final ExpeditionState expeditionState;
  final JourneyMilestoneState journeyMilestoneState;

  const AppState({
    this.cartState,
    this.portalState,
    this.settingState,
    this.inventoryState,
    this.favouriteState,
    this.timerState,
    this.titleState,
    this.expeditionState,
    this.journeyMilestoneState,
  });

  factory AppState.fromJson(Map<String, dynamic> json) {
    CartState cartState = //
        CartState.fromJson(json['cartState']);
    PortalState portalState = //
        PortalState.fromJson(json['portalState']);
    SettingState settingState = //
        SettingState.fromJson(json['settingState']);
    InventoryState inventoryState = //
        InventoryState.fromJson(json['inventoryState']);
    FavouriteState favouriteState = //
        FavouriteState.fromJson(json['favouriteState']);
    TimerState timerState = //
        TimerState.fromJson(json['timerState']);
    TitleState titleState = //
        TitleState.fromJson(json['titleState']);
    ExpeditionState expeditionState = //
        ExpeditionState.fromJson(json['expeditionState']);
    JourneyMilestoneState jmState = //
        JourneyMilestoneState.fromJson(json['journeyMilestoneState']);

    return AppState(
      cartState: cartState,
      portalState: portalState,
      settingState: settingState,
      inventoryState: inventoryState,
      favouriteState: favouriteState,
      timerState: timerState,
      titleState: titleState,
      expeditionState: expeditionState,
      journeyMilestoneState: jmState,
    );
  }

  factory AppState.initial() {
    return AppState(
      cartState: CartState.initial(),
      portalState: PortalState.initial(),
      settingState: SettingState.initial(),
      inventoryState: InventoryState.initial(),
      favouriteState: FavouriteState.initial(),
      timerState: TimerState.initial(),
      titleState: TitleState.initial(),
      expeditionState: ExpeditionState.initial(),
      journeyMilestoneState: JourneyMilestoneState.initial(),
    );
  }

  AppState copyWith({
    CartState cartState,
    PortalState portalState,
    SettingState settingState,
    InventoryState inventoryState,
    FavouriteState favouriteState,
    TimerState timerState,
    TitleState titleState,
    ExpeditionState expeditionState,
    JourneyMilestoneState journeyMState,
  }) {
    return AppState(
      cartState: cartState ?? cartState,
      portalState: portalState ?? portalState,
      settingState: settingState ?? settingState,
      inventoryState: inventoryState ?? inventoryState,
      favouriteState: favouriteState ?? favouriteState,
      timerState: timerState ?? timerState,
      titleState: titleState ?? titleState,
      expeditionState: expeditionState ?? expeditionState,
      journeyMilestoneState: journeyMState ?? journeyMilestoneState,
    );
  }

  Map<String, dynamic> toJson() => {
        'cartState': cartState.toJson(),
        'portalState': portalState.toJson(),
        'settingState': settingState.toJson(),
        'inventoryState': inventoryState.toJson(),
        'favouriteState': favouriteState.toJson(),
        'timerState': timerState.toJson(),
        'titleState': titleState.toJson(),
        'expeditionState': expeditionState.toJson(),
        'journeyMilestoneState': journeyMilestoneState.toJson(),
      };
}
