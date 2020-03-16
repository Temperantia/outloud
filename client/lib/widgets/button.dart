import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';

class Button extends StatelessWidget {
  const Button({
    @required this.text,
    this.onPressed,
    this.width,
    this.height,
    this.icon,
  });

  final String text;
  final Function onPressed;
  final double width;
  final double height;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 50,
      child: RaisedButton.icon(
          elevation: 0.0,
          color: orangeLight.withOpacity(0.5),
          textColor: white,
          onPressed: onPressed == null ? () {} : () => onPressed(),
          icon: icon ?? Container(),
          label: Text(text)),
    );
  }
}
