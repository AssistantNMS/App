import 'package:redux/redux.dart';

import '../../../contracts/portal/portalRecord.dart';
import '../../../contracts/redux/portalState.dart';
import 'actions.dart';

final portalReducer = combineReducers<PortalState>([
  TypedReducer<PortalState, AddPortalAction>(_addPortal),
  TypedReducer<PortalState, EditPortalAction>(_editPortal),
  TypedReducer<PortalState, RemovePortalAction>(_removePortal),
  TypedReducer<PortalState, RemoveAllPortalsAction>(_removeAllPortals),
  TypedReducer<PortalState, AddPortalTagAction>(_addPortalTag),
  TypedReducer<PortalState, RemovePortalTagAction>(_removePortalTag),
  TypedReducer<PortalState, RestorePortalsAction>(_restorePortalState),
]);

PortalState _addPortal(PortalState state, AddPortalAction action) {
  List<PortalRecord> newList = state.portals;
  newList.add(action.portalRecord);
  return state.copyWith(portals: newList);
}

PortalState _editPortal(PortalState state, EditPortalAction action) {
  List<PortalRecord> newList = List.empty(growable: true);
  for (var portalIndex = 0; portalIndex < state.portals.length; portalIndex++) {
    var temp = state.portals[portalIndex];
    if (temp.uuid != action.portalRecord.uuid) {
      newList.add(temp);
    } else {
      newList.add(action.portalRecord);
    }
  }
  return state.copyWith(portals: newList);
}

PortalState _removePortal(PortalState state, RemovePortalAction action) {
  List<PortalRecord> newList = List.empty(growable: true);
  for (var portalIndex = 0; portalIndex < state.portals.length; portalIndex++) {
    var temp = state.portals[portalIndex];
    if (temp.uuid != action.uuid) {
      newList.add(temp);
    }
  }
  return state.copyWith(portals: newList);
}

PortalState _removeAllPortals(
    PortalState state, RemoveAllPortalsAction action) {
  return state.copyWith(portals: List.empty(growable: true));
}

PortalState _addPortalTag(PortalState state, AddPortalTagAction action) {
  List<String> newList = state.availableTags;
  newList.add(action.newTag);
  return state.copyWith(availableTags: newList);
}

PortalState _removePortalTag(PortalState state, RemovePortalTagAction action) {
  List<String> newList = List.empty(growable: true);
  for (var tagIndex = 0; tagIndex < state.availableTags.length; tagIndex++) {
    var temp = state.availableTags[tagIndex];
    if (temp != action.oldTag) {
      newList.add(temp);
    }
  }
  return state.copyWith(availableTags: newList);
}

PortalState _restorePortalState(
        PortalState state, RestorePortalsAction action) =>
    state.copyWith(
      portals: action.newState.portals,
      availableTags: action.newState.availableTags,
    );
