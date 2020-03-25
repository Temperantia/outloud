import 'dart:math';

import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

void showLoaderAnimation(BuildContext context, TickerProvider tickerProvider, void Function(ReduxAction<AppState>) dispatch, ReduxAction<AppState> callback){
 
  final AnimationController _animationController = AnimationController(
        duration: const Duration(milliseconds: 600),
        upperBound: pi * 2,
        vsync: tickerProvider);

  final Animation<double> _angleAnimation =
                Tween<double>(begin: 0.0, end: 0.1)
                    .animate(_animationController);

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  child: RotationTransition(
                    turns: _angleAnimation,
                    child: Container(
                        width: 100,
                        height: 100,
                        child: Image.asset('images/iconLoader.png')),
                  ),
                );
              },
            );

            final void Function(AnimationStatus) _listener =
                (AnimationStatus status) {
              if (status == AnimationStatus.completed) {
                _animationController.reverse();
              } else if (status == AnimationStatus.dismissed) {
                _animationController.forward();
              }
            };

            _angleAnimation.addStatusListener(_listener);
            _animationController.forward(from: 0.0);

            Future<void>.delayed(const Duration(milliseconds: 800), () {
              _angleAnimation.removeStatusListener(_listener);
              Navigator.pop(context);
              dispatch(callback);
            });
}
