// ignore_for_file: no_logic_in_create_state

import 'dart:math';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../constants/AppDuration.dart';

import '../../contracts/misc/customMenu.dart';

class EditingHomepageItem extends StatefulWidget {
  final CustomMenu menuItem;
  final double tileSize;
  const EditingHomepageItem(this.menuItem, this.tileSize, {Key key})
      : super(key: key);

  @override
  _EditingHomepageWidget createState() => _EditingHomepageWidget(
        menuItem,
        tileSize,
      );
}

class _EditingHomepageWidget extends State<EditingHomepageItem>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  final CustomMenu menuItem;
  final double tileSize;
  _EditingHomepageWidget(this.menuItem, this.tileSize);

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: AppDuration.homescreenWiggle,
      reverseDuration: AppDuration.homescreenWiggle,
    )..addListener(() => setState(() {}));

    animationController.repeat(reverse: true);
  }

  double _shake() {
    double progress = animationController.value;
    return cos(progress * pi * 10.0);
  }

  @override
  Widget build(BuildContext context) {
    return editCustomMenuItemGridPresenter(context, menuItem, tileSize,
        position: _shake());
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

Widget editCustomMenuItemGridPresenter(
    BuildContext context, CustomMenu menuItem, double tileSize,
    {double position = 0, bool isBeingDragged = false}) {
  var childWidget = Card(
    shadowColor: Colors.transparent,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        menuItem.icon,
        Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            getTranslations().fromKey(menuItem.title),
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
      ],
    ),
  );
  return SizedBox(
    child: isBeingDragged
        ? childWidget
        : RotationTransition(
            turns: AlwaysStoppedAnimation((1 * position) / 360),
            child: childWidget,
          ),
    height: tileSize.floorToDouble(),
    width: tileSize.floorToDouble(),
  );
}

Widget customMenuItemGridPresenter(BuildContext context, CustomMenu menuItem) {
  Widget card = Card(
    child: InkWell(
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (menuItem.isLocked) ...[
            Positioned(
              top: 5,
              left: 7,
              child: Icon(
                Icons.lock_clock,
                size: 32,
                color: getTheme().getDarkModeSecondaryColour(),
              ),
            ),
          ],
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              menuItem.icon,
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  getTranslations().fromKey(menuItem.title),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
            ],
          ),
        ],
      ),
      onTap: () => customMenuClickHandler(context, menuItem),
      onLongPress: () =>
          (menuItem.onLongPress != null) ? menuItem.onLongPress(context) : null,
    ),
  );
  if (menuItem.isNew) return wrapInNewBanner(context, LocaleKey.newItem, card);
  return card;
}
