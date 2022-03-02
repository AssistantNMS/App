import '../../contracts/redux/appState.dart';
import 'cart/reducer.dart';
import 'expedition/reducer.dart';
import 'favourite/reducer.dart';
import 'inventory/reducer.dart';
import 'journeyMilestone/reducer.dart';
import 'portal/reducer.dart';
import 'setting/reducer.dart';
import 'timer/reducer.dart';
import 'titles/reducer.dart';

AppState appReducer(AppState state, dynamic action) => AppState(
      cartState: cartReducer(state.cartState, action),
      portalState: portalReducer(state.portalState, action),
      settingState: settingReducer(state.settingState, action),
      inventoryState: inventoryReducer(state.inventoryState, action),
      favouriteState: favouriteReducer(state.favouriteState, action),
      timerState: timerReducer(state.timerState, action),
      titleState: titleReducer(state.titleState, action),
      expeditionState: expeditionReducer(state.expeditionState, action),
      journeyMilestoneState:
          journeyMilestoneReducer(state.journeyMilestoneState, action),
    );
