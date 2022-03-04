import '../../../constants/Fonts.dart';
import 'package:redux/redux.dart';

import '../../../contracts/enum/homepageType.dart';
import '../../../contracts/redux/appState.dart';
import 'actions.dart';
import 'selector.dart';

class IntroViewModel {
  final bool isRelease118IntroHidden;
  final bool isValentines2020IntroHidden;
  final bool isValentines2021IntroHidden;
  final String fontFamily;
  final bool introComplete;
  final bool onlineMeetup2020;
  final HomepageType homepageType;
  final String currentLanguage;

  final Function() hideRelease118Intro;
  final Function() hideValentines2020Intro;
  final Function() hideValentines2021Intro;
  final Function() toggleIntroComplete;
  final Function() hideOnlineMeetup2020;

  IntroViewModel({
    this.isRelease118IntroHidden,
    this.isValentines2020IntroHidden,
    this.isValentines2021IntroHidden,
    this.fontFamily,
    this.introComplete,
    this.onlineMeetup2020,
    this.homepageType,
    this.currentLanguage,
    //
    this.hideRelease118Intro,
    this.hideValentines2020Intro,
    this.hideValentines2021Intro,
    this.toggleIntroComplete,
    this.hideOnlineMeetup2020,
  });

  static IntroViewModel fromStore(Store<AppState> store) {
    Function hideRelease118Intro;
    hideRelease118Intro = () => store.dispatch(HideRelease118Intro());
    Function hideValentines2020Intro;
    hideValentines2020Intro = () => store.dispatch(HideValentines2020Intro());
    Function hideValentines2021Intro;
    hideValentines2021Intro = () => store.dispatch(HideValentines2021Intro());
    Function toggleIntroComplete;
    toggleIntroComplete = () => store.dispatch(ToggleIntroComplete());
    Function hideOnlineMeetup2020;
    hideOnlineMeetup2020 = () => store.dispatch(HideOnlineMeetup2020());
    try {
      return IntroViewModel(
        isRelease118IntroHidden: getIsRelease118IntroHidden(store.state),
        hideRelease118Intro: hideRelease118Intro,
        isValentines2020IntroHidden:
            getIsValentines2020IntroHidden(store.state),
        isValentines2021IntroHidden:
            getIsValentines2021IntroHidden(store.state),
        hideValentines2020Intro: hideValentines2020Intro,
        hideValentines2021Intro: hideValentines2021Intro,
        fontFamily: getFontFamily(store.state),
        introComplete: getIntroComplete(store.state),
        onlineMeetup2020: getOnlineMeetup2020(store.state),
        toggleIntroComplete: toggleIntroComplete,
        hideOnlineMeetup2020: hideOnlineMeetup2020,
        homepageType: getHomepageType(store.state),
        currentLanguage: getSelectedLanguage(store.state),
      );
    } catch (exception) {
      return IntroViewModel(
        isRelease118IntroHidden: false,
        hideRelease118Intro: hideRelease118Intro,
        isValentines2020IntroHidden: false,
        hideValentines2020Intro: hideValentines2020Intro,
        hideValentines2021Intro: hideValentines2021Intro,
        fontFamily: defaultFontFamily,
        introComplete: false,
        onlineMeetup2020: false,
        toggleIntroComplete: toggleIntroComplete,
        hideOnlineMeetup2020: hideOnlineMeetup2020,
        homepageType: HomepageType.allItemsList,
      );
    }
  }
}
