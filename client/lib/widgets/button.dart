import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';

class Button extends StatelessWidget {
  const Button({
    this.text,
    this.onPressed,
    this.width = double.infinity,
    this.height = double.infinity,
  });
  final String text;
  final Function onPressed;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        onPressed: () => onPressed(),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: const EdgeInsets.all(0.0),
        child: Ink(
          decoration: const BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.all(Radius.circular(80.0)),
          ),
          child: Container(
            constraints: BoxConstraints(
                maxWidth: width,
                maxHeight: height,
                minWidth: 88.0,
                minHeight: 36.0), // min sizes for Material buttons
            alignment: Alignment.center,
            child: Text(
              text,
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }
}
