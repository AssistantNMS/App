import 'package:redux/redux.dart';

import '../../../contracts/redux/appState.dart';
import 'actions.dart';
import 'selector.dart';

class NewsPageViewModel {
  final int selectedNewsPage;
  final Function(int) setSelectedNewsPage;

  NewsPageViewModel({
    required this.selectedNewsPage,
    required this.setSelectedNewsPage,
  });

  static NewsPageViewModel fromStore(Store<AppState> store) =>
      NewsPageViewModel(
        selectedNewsPage: getSelectedNewsPage(store.state),
        setSelectedNewsPage: (int index) => store.dispatch(SetNewsPage(index)),
      );
}
