import 'package:flutter/material.dart';

class VerticalScrollingText extends StatefulWidget {
  final Duration duration;
  final TextStyle textItemStyle;
  final List<String> textItems;
  final Widget Function(String) textDisplayer;
  const VerticalScrollingText(
    this.textItems, {
    Key key,
    this.duration = const Duration(seconds: 2),
    this.textDisplayer,
    this.textItemStyle,
  }) : super(key: key);
  @override
  _VerticalScrollingTextWidget createState() => _VerticalScrollingTextWidget();
}

class _VerticalScrollingTextWidget extends State<VerticalScrollingText>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  final Curve _animationCurve = const Interval(
    0.3,
    0.7,
    curve: Curves.easeInOut,
  );

  @override
  initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.duration,
    );
    _animationController.addListener(() {
      setState(() {});
    });
    // _animationController.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     _animationController.forward(from: 0.0);
    //   }
    // });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    var animationOffset = _animationCurve.transform(_animationController.value);
    var localTextDisplayer = widget.textDisplayer ??
        (String text) => Center(
              child: Text(
                text,
                style: widget.textItemStyle,
              ),
            );
    var container = SizedBox(
      width: double.infinity,
      height: 30,
      child: Stack(
        children: [
          for (int textItemIndex = 0;
              textItemIndex < (widget.textItems ?? []).length;
              textItemIndex++)
            FractionalTranslation(
              translation: Offset(
                0.0,
                (animationOffset) - textItemIndex,
              ),
              child: localTextDisplayer(widget.textItems[textItemIndex]),
            ),
        ],
      ),
    );
    // var stopLength = 1 / (widget.textItems ?? []).length;
    // for (int textItemIndex = 0;
    //     textItemIndex < (widget.textItems ?? []).length;
    //     textItemIndex++)
    //   textItemIndex * stopLength
    return ClipRect(
      child: ShaderMask(
        shaderCallback: (Rect availableSpace) {
          return LinearGradient(
              colors: [
                Colors.white.withOpacity(0.0),
                Colors.white,
                Colors.white,
                Colors.white.withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [
                0.05,
                0.3,
                0.7,
                0.95,
              ]).createShader(availableSpace);
        },
        child: container,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
