import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class Button extends StatelessWidget {
  const Button({
    this.text,
    this.onPressed,
    this.width,
    this.height,
    this.alt = false,
  });
  final String text;
  final Function onPressed;
  final double width;
  final double height;
  final bool alt;
  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<AppState>) dispatch,
        Widget child) {
      final BoxDecoration decoration = alt
          ? const BoxDecoration(
              color: white,
              borderRadius: BorderRadius.all(Radius.circular(80.0)))
          : BoxDecoration(
              color: primary(state.theme),
              borderRadius: BorderRadius.all(Radius.circular(80.0)));
      return Container(
          width: width,
          height: height,
          child: RaisedButton(
              onPressed: onPressed == null ? () {} : () => onPressed(),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: const EdgeInsets.all(0.0),
              child: Ink(
                decoration: decoration,
                child: Container(
                    constraints:
                        const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
                    alignment: Alignment.center,
                    child: Text(text,
                        style: alt ? textStyleButtonAlt : textStyleButton)),
              )));
    });
  }
}
