import 'package:meta/meta.dart';

import 'cart_state.dart';
import 'expedition_state.dart';
import 'favourite_state.dart';
import 'inventory_state.dart';
import 'journey_milestone_state.dart';
import 'portal_state.dart';
import 'setting_state.dart';
import 'timer_state.dart';
import 'title_state.dart';

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
    required this.cartState,
    required this.portalState,
    required this.settingState,
    required this.inventoryState,
    required this.favouriteState,
    required this.timerState,
    required this.titleState,
    required this.expeditionState,
    required this.journeyMilestoneState,
  });

  factory AppState.fromJson(Map<String, dynamic>? json) {
    var cartState = CartState.fromJson(json?['cartState']);
    var portalState = PortalState.fromJson(json?['portalState']);
    var settingState = SettingState.fromJson(json?['settingState']);
    var inventoryState = InventoryState.fromJson(json?['inventoryState']);
    var favouriteState = FavouriteState.fromJson(json?['favouriteState']);
    var timerState = TimerState.fromJson(json?['timerState']);
    var titleState = TitleState.fromJson(json?['titleState']);
    var expeditionState = ExpeditionState.fromJson(json?['expeditionState']);
    var jmState =
        JourneyMilestoneState.fromJson(json?['journeyMilestoneState']);

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
    CartState? cartState,
    PortalState? portalState,
    SettingState? settingState,
    InventoryState? inventoryState,
    FavouriteState? favouriteState,
    TimerState? timerState,
    TitleState? titleState,
    ExpeditionState? expeditionState,
    JourneyMilestoneState? journeyMilestoneState,
  }) {
    return AppState(
      cartState: cartState ?? this.cartState,
      portalState: portalState ?? this.portalState,
      settingState: settingState ?? this.settingState,
      inventoryState: inventoryState ?? this.inventoryState,
      favouriteState: favouriteState ?? this.favouriteState,
      timerState: timerState ?? this.timerState,
      titleState: titleState ?? this.titleState,
      expeditionState: expeditionState ?? this.expeditionState,
      journeyMilestoneState:
          journeyMilestoneState ?? this.journeyMilestoneState,
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
