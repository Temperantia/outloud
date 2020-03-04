import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';

class Button extends StatelessWidget {
  const Button({
    this.text,
    this.onPressed,
    this.width,
    this.height,
  });
  final String text;
  final Function onPressed;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        child: GestureDetector(
            onTap: onPressed == null ? () {} : () => onPressed(),
            child: Container(
              decoration: BoxDecoration(
                  color: white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5.0)),
              child: Container(
                  constraints:
                      const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
                  alignment: Alignment.center,
                  child: Text(text, style: textStyleButton)),
            )));
  }
}
