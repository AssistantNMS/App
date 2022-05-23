import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  final Function onTap;
  final void Function(Locale locale) onLocaleChange;
  const IntroPage(this.onLocaleChange, {Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // const iconFgColour = Colors.white;
    // return StoreConnector<AppState, IntroViewModel>(
    //   converter: (store) => IntroViewModel.fromStore(store),
    //   builder: (_, introViewModel) => IntroSlider(
    //     slides: [
    //       genericSlideString(
    //         context,
    //         title: 'Welcome!',
    //         imagePath: '${getPath().imageAssetPathPrefix}/icon.png',
    //         descrip:
    //             'The Assistant for No Man\'s Sky is here to improve your NMS journey',
    //       ),
    //       genericSlideString(
    //         context,
    //         title: '',
    //         imagePath: '${getPath().imageAssetPathPrefix}/timer/classs.png',
    //         descrip: '',
    //       ),
    //     ],
    //     renderSkipBtn: const Icon(Icons.skip_next, color: iconFgColour),
    //     renderNextBtn: const Icon(Icons.navigate_next, color: iconFgColour),
    //     renderDoneBtn: const Icon(Icons.done, color: iconFgColour),
    //     onDonePress: () async {
    //       if (onTap != null) {
    //         onTap();
    //         return;
    //       }
    //       introViewModel.toggleIntroComplete();
    //       await getNavigation().navigateHomeAsync(context);
    //     },
    //     colorDot: Colors.white,
    //     colorActiveDot: getTheme().getSecondaryColour(context),
    //     backgroundColorAllSlides: getTheme().getBackgroundColour(context),
    //   ),
    // );
    return Container();
  }

  // Slide genericSlide(
  //   BuildContext context, {
  //   LocaleKey title,
  //   String imagePath,
  //   LocaleKey descrip,
  // }) =>
  //     genericSlideString(
  //       context,
  //       title: getTranslations().fromKey(title),
  //       imagePath: imagePath,
  //       descrip: getTranslations().fromKey(descrip),
  //     );

  // Slide genericSlideString(
  //   BuildContext context, {
  //   String title,
  //   String imagePath,
  //   String descrip,
  // }) =>
  //     Slide(
  //       title: title,
  //       description: descrip,
  //       pathImage: imagePath,
  //       colorBegin: getTheme().getPrimaryColour(context),
  //       colorEnd: Colors.black,
  //       directionColorBegin: Alignment.topCenter,
  //       directionColorEnd: Alignment.bottomCenter,
  //     );
}
