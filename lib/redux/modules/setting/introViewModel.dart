import '../../../constants/Fonts.dart';
import 'package:redux/redux.dart';

import '../../../contracts/enum/homepageType.dart';
import '../../../contracts/redux/appState.dart';
import 'actions.dart';
import 'selector.dart';

class IntroViewModel {
  final bool isValentines2020IntroHidden;
  final bool isValentines2021IntroHidden;
  final String fontFamily;
  final bool introComplete;
  final bool isPatron;
  final HomepageType homepageType;
  final String currentLanguage;

  final Function() hideValentines2020Intro;
  final Function() hideValentines2021Intro;
  final Function() toggleIntroComplete;

  IntroViewModel({
    required this.isValentines2020IntroHidden,
    required this.isValentines2021IntroHidden,
    required this.fontFamily,
    required this.introComplete,
    required this.isPatron,
    required this.homepageType,
    required this.currentLanguage,
    //
    required this.hideValentines2020Intro,
    required this.hideValentines2021Intro,
    required this.toggleIntroComplete,
  });

  static IntroViewModel fromStore(Store<AppState> store) {
    void Function() hideValentines2020Intro;
    hideValentines2020Intro = () => store.dispatch(HideValentines2020Intro());
    void Function() hideValentines2021Intro;
    hideValentines2021Intro = () => store.dispatch(HideValentines2021Intro());
    void Function() toggleIntroComplete;
    toggleIntroComplete = () => store.dispatch(ToggleIntroComplete());
    try {
      return IntroViewModel(
        isValentines2020IntroHidden:
            getIsValentines2020IntroHidden(store.state),
        isValentines2021IntroHidden:
            getIsValentines2021IntroHidden(store.state),
        hideValentines2020Intro: hideValentines2020Intro,
        hideValentines2021Intro: hideValentines2021Intro,
        fontFamily: getFontFamily(store.state),
        introComplete: getIntroComplete(store.state),
        isPatron: getIsPatron(store.state),
        toggleIntroComplete: toggleIntroComplete,
        homepageType: getHomepageType(store.state),
        currentLanguage: getSelectedLanguage(store.state),
      );
    } catch (exception) {
      return IntroViewModel(
        isValentines2020IntroHidden: false,
        hideValentines2020Intro: hideValentines2020Intro,
        isValentines2021IntroHidden: false,
        hideValentines2021Intro: hideValentines2021Intro,
        fontFamily: defaultFontFamily,
        introComplete: false,
        isPatron: false,
        toggleIntroComplete: toggleIntroComplete,
        homepageType: HomepageType.allItemsList,
        currentLanguage: 'en',
      );
    }
  }
}
