import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';

class Button extends StatelessWidget {
  const Button({
    this.text,
    this.onPressed,
    this.width,
    this.height,
  });
  final Text text;
  final Function onPressed;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        child: RaisedButton(
            onPressed: onPressed == null ? () {} : () => onPressed(),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80.0)),
            padding: const EdgeInsets.all(0.0),
            child: Ink(
              decoration: const BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.all(Radius.circular(80.0)),
              ),
              child: Container(
                constraints: const BoxConstraints(
                    minWidth: 88.0,
                    minHeight: 36.0), // min sizes for Material buttons
                alignment: Alignment.center,
                child: text,
              ),
            )));
  }
}
