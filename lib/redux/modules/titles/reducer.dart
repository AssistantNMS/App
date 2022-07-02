import 'package:redux/redux.dart';

import '../../../contracts/redux/titleState.dart';
import 'actions.dart';

final titleReducer = combineReducers<TitleState>([
  TypedReducer<TitleState, AddTitleAction>(_addTitle),
  TypedReducer<TitleState, RemoveTitleAction>(_removeTitle),
  TypedReducer<TitleState, RemoveAllTitlesAction>(_removeAllTitles),
  TypedReducer<TitleState, SetHideCompletedAction>(_setHideCompletedAction),
]);

TitleState _addTitle(TitleState state, AddTitleAction action) {
  if (state.owned.any((own) => own == action.itemId)) return state;

  List<String> newItems = state.owned;
  newItems.add(action.itemId);

  return state.copyWith(owned: newItems);
}

TitleState _removeTitle(TitleState state, RemoveTitleAction action) {
  var itemToDelete =
      state.owned.firstWhere((ci) => ci == action.itemId, orElse: () => null);
  if (itemToDelete == null) {
    return state;
  }

  return state.copyWith(owned: List.from(state.owned)..remove(itemToDelete));
}

TitleState _removeAllTitles(TitleState state, RemoveAllTitlesAction action) {
  return state.copyWith(owned: List.empty(growable: true));
}

TitleState _setHideCompletedAction(
    TitleState state, SetHideCompletedAction action) {
  return state.copyWith(hideCompleted: action.hideCompleted);
}
