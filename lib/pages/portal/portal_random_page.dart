import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:roll_slot_machine/roll_slot.dart';
import 'package:roll_slot_machine/roll_slot_controller.dart';

import '../../components/floatingActionButton/randomPortalFloatingActionButton.dart';
import '../../components/portal/portalGlyphList.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/youtubersTilePresenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../constants/NmsExternalUrls.dart';
import '../../constants/Routes.dart';
import '../../contracts/redux/appState.dart';
import '../../redux/modules/portal/portalViewModel.dart';

const double horizontalPadding = 32;

class RandomPortalPage extends StatefulWidget {
  const RandomPortalPage({Key? key}) : super(key: key);

  @override
  createState() => _RandomPortalPageState();
}

class _RandomPortalPageState extends State<RandomPortalPage> {
  bool fabIsDisabled = true;
  List<int> currentCode = [];

  final _rollSlotController0 = RollSlotController();
  final _rollSlotController1 = RollSlotController();
  final _rollSlotController2 = RollSlotController();
  final _rollSlotController3 = RollSlotController();
  final _rollSlotController4 = RollSlotController();
  final _rollSlotController5 = RollSlotController();
  final _rollSlotController6 = RollSlotController();
  final _rollSlotController7 = RollSlotController();
  final _rollSlotController8 = RollSlotController();
  final _rollSlotController9 = RollSlotController();
  final _rollSlotControllerA = RollSlotController();
  final _rollSlotControllerB = RollSlotController();

  _RandomPortalPageState() {
    getAnalytics().trackEvent(AnalyticsEvent.randomPortalPage);
  }

  @override
  void initState() {
    super.initState();

    _rollSlotControllerA.addListener(() {
      setState(() {
        if (fabIsDisabled) return;
        currentCode = [
          _rollSlotController0.currentIndex,
          _rollSlotController1.currentIndex,
          _rollSlotController2.currentIndex,
          _rollSlotController3.currentIndex,
          _rollSlotController4.currentIndex,
          _rollSlotController5.currentIndex,
          _rollSlotController6.currentIndex,
          _rollSlotController7.currentIndex,
          _rollSlotController8.currentIndex,
          _rollSlotController9.currentIndex,
          _rollSlotControllerA.currentIndex,
          _rollSlotControllerB.currentIndex,
        ];
        fabIsDisabled = false;
      });
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      // Really bad - I did it for the animations!
      startRoll();
    });
  }

  void startRoll() {
    setState(() {
      currentCode = [];
      fabIsDisabled = true;
    });

    // _rollSlotController0.animateRandomly();
    _rollSlotController1.animateRandomly();
    _rollSlotController2.animateRandomly();
    _rollSlotController3.animateRandomly();
    _rollSlotController4.animateRandomly();
    _rollSlotController5.animateRandomly();
    _rollSlotController6.animateRandomly();
    _rollSlotController7.animateRandomly();
    _rollSlotController8.animateRandomly();
    _rollSlotController9.animateRandomly();
    _rollSlotControllerA.animateRandomly();
    _rollSlotControllerB.animateRandomly();

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        fabIsDisabled = false;
      });
    });
  }

  void copyCode(BuildContext copyCtx) {
    String hexString = currentCode.map((e) => e.toRadixString(16)).join('');
    Clipboard.setData(ClipboardData(text: hexString.toUpperCase()));
    getSnackbar().showSnackbar(
      copyCtx,
      LocaleKey.portalCodeCopied,
      description: hexString.toUpperCase(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PortalViewModel>(
      converter: (store) => PortalViewModel.fromStore(store),
      builder: (_, viewModel) => basicGenericPageScaffold(
        context,
        title: getTranslations().fromKey(LocaleKey.randomPortal),
        actions: [
          ActionItem(
            icon: Icons.screen_rotation_alt_rounded,
            onPressed: () => getNavigation().navigateAwayFromHomeAsync(
              context,
              navigateToNamed: Routes.portalConverter,
            ),
          )
        ],
        body: LayoutBuilder(
          builder: (layoutCtx, BoxConstraints constraints) {
            return getBody(layoutCtx, viewModel, constraints);
          },
        ),
        fab: randomPortalFAB(
          context,
          isDisabled: fabIsDisabled || currentCode.isEmpty,
          startRoll: () => startRoll(),
          copyCode: () => copyCode(context),
        ),
      ),
    );
  }

  Widget getBody(
    BuildContext bodyCtx,
    PortalViewModel portalViewModel,
    BoxConstraints constraints,
  ) {
    bool useAltGlyphs = portalViewModel.useAltGlyphs;
    final size = Size(constraints.maxWidth, constraints.maxHeight);
    List<String> portalList = List.generate(
      16,
      (index) => index.toRadixString(16),
    );
    List<String> secondReel = ['0', '1', '2'].toList();

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FlatCard(
          child: captainSteveYoutubeVideoTile(
            bodyCtx,
            NmsExternalUrls.captainSteveYoutubeDiceRollPlaylist,
            subtitle: 'Dice Exploration Playlist',
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RollSlotWidget(
                pageSize: size,
                portalList: portalList,
                useAltGlyphs: useAltGlyphs,
                rollSlotController: _rollSlotController0,
              ),
              RollSlotWidget(
                pageSize: size,
                portalList: secondReel,
                useAltGlyphs: useAltGlyphs,
                rollSlotController: _rollSlotController1,
              ),
              RollSlotWidget(
                pageSize: size,
                portalList: portalList,
                useAltGlyphs: useAltGlyphs,
                rollSlotController: _rollSlotController2,
              ),
              RollSlotWidget(
                pageSize: size,
                portalList: portalList,
                useAltGlyphs: useAltGlyphs,
                rollSlotController: _rollSlotController3,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RollSlotWidget(
                pageSize: size,
                portalList: portalList,
                useAltGlyphs: useAltGlyphs,
                rollSlotController: _rollSlotController4,
              ),
              RollSlotWidget(
                pageSize: size,
                portalList: portalList,
                useAltGlyphs: useAltGlyphs,
                rollSlotController: _rollSlotController5,
              ),
              RollSlotWidget(
                pageSize: size,
                portalList: portalList,
                useAltGlyphs: useAltGlyphs,
                rollSlotController: _rollSlotController6,
              ),
              RollSlotWidget(
                pageSize: size,
                portalList: portalList,
                useAltGlyphs: useAltGlyphs,
                rollSlotController: _rollSlotController7,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RollSlotWidget(
                pageSize: size,
                portalList: portalList,
                useAltGlyphs: useAltGlyphs,
                rollSlotController: _rollSlotController8,
              ),
              RollSlotWidget(
                pageSize: size,
                portalList: portalList,
                useAltGlyphs: useAltGlyphs,
                rollSlotController: _rollSlotController9,
              ),
              RollSlotWidget(
                pageSize: size,
                portalList: portalList,
                useAltGlyphs: useAltGlyphs,
                rollSlotController: _rollSlotControllerA,
              ),
              RollSlotWidget(
                pageSize: size,
                portalList: portalList,
                useAltGlyphs: useAltGlyphs,
                rollSlotController: _rollSlotControllerB,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RollSlotWidget extends StatelessWidget {
  final Size pageSize;
  final List<String> portalList;
  final RollSlotController rollSlotController;
  final bool useAltGlyphs;

  const RollSlotWidget({
    Key? key,
    required this.pageSize,
    required this.portalList,
    required this.rollSlotController,
    required this.useAltGlyphs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var maxHeight = (pageSize.height - 50) / 4;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
        maxWidth: (pageSize.width - (horizontalPadding * 2)) / 4,
      ),
      child: RollSlot(
        duration: const Duration(milliseconds: 6000),
        itemExtend: maxHeight * 0.8,
        shuffleList: false,
        rollSlotController: rollSlotController,
        children: portalList
            .map((portalCode) => BuildItem(
                  portalCode: portalCode,
                  useAltGlyphs: useAltGlyphs,
                ))
            .toList(),
      ),
    );
  }
}

class BuildItem extends StatelessWidget {
  final String portalCode;
  final bool useAltGlyphs;

  const BuildItem({
    Key? key,
    required this.portalCode,
    required this.useAltGlyphs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
              color: getTheme().getSecondaryColour(context).withOpacity(.1)),
        ],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: getTheme().getSecondaryColour(context).withOpacity(.5),
        ),
      ),
      alignment: Alignment.center,
      child: getPortalImage(context, portalCode, useAltGlyphs),
    );
  }
}
