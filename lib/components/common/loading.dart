import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';

Widget oldLoadingSpinner() => isApple
    ? const CupertinoActivityIndicator()
    : const CircularProgressIndicator();

class CustomSpinner extends StatefulWidget {
  final double height;
  final double width;
  final Duration spinDuration;
  const CustomSpinner({
    Key key,
    this.height = 100.0,
    this.width = 100.0,
    this.spinDuration = const Duration(milliseconds: 1000),
  }) : super(key: key);

  @override
  _CustomSpinnerWidget createState() => _CustomSpinnerWidget();
}

class _CustomSpinnerWidget extends State<CustomSpinner>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: widget.spinDuration,
      vsync: this,
    );

    _controller.addListener(() {
      if (_controller.isCompleted) {
        _controller.repeat(reverse: true);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, -0.1),
        end: const Offset(0.0, 0.1),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      )),
      child: Image.asset(
        'assets/images/loader.png',
        height: widget.height,
        width: widget.width,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
