import 'dart:math';

import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

Future<void> showLoaderAnimation(
    BuildContext context, TickerProvider tickerProvider,
    {bool executeCallback = false,
    int animationDuration = 600,
    void Function(ReduxAction<AppState>) dispatch,
    ReduxAction<AppState> callback}) async {
  final AnimationController _animationController = AnimationController(
      duration: Duration(milliseconds: animationDuration),
      upperBound: pi * 2,
      vsync: tickerProvider);

  final Animation<double> _angleAnimation =
      Tween<double>(begin: 0.0, end: 0.1).animate(_animationController);

  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: RotationTransition(
                turns: _angleAnimation,
                child: Image.asset('images/iconLoader.png',
                    width: 100.0, height: 100.0)));
      });

  final void Function(AnimationStatus) _listener = (AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _animationController.reverse();
    } else if (status == AnimationStatus.dismissed) {
      _animationController.forward();
    }
  };

  _angleAnimation.addStatusListener(_listener);
  _animationController.forward(from: 0.0);

  return Future<void>.delayed(Duration(milliseconds: animationDuration * 2),
      () {
    _angleAnimation.removeStatusListener(_listener);
    _animationController.dispose();
    Navigator.pop(context);
    if (executeCallback) {
      dispatch(callback);
    }
  });
}
