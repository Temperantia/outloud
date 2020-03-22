import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';

class Button extends StatelessWidget {
  const Button(
      {@required this.text,
      this.onPressed,
      this.width,
      this.height,
      this.icon,
      this.backgroundColor = orangeLight,
      this.backgroundOpacity = 0.5,
      this.colorText = white,
      this.fontSize = 15,
      this.fontWeight = FontWeight.normal,
      this.paddingLeft = 0,
      this.paddingRight = 0,
      this.paddingBottom = 0,
      this.paddingTop = 0});

  final String text;
  final Function onPressed;
  final double width;
  final double height;
  final Icon icon;
  final Color backgroundColor;
  final double backgroundOpacity;
  final Color colorText;
  final double fontSize;
  final FontWeight fontWeight;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            left: paddingLeft,
            right: paddingRight,
            top: paddingTop,
            bottom: paddingBottom),
        width: width,
        height: height ?? 50,
        child: RaisedButton.icon(
            elevation: 0.0,
            color: backgroundColor.withOpacity(backgroundOpacity),
            textColor: colorText,
            onPressed: onPressed == null ? () {} : () => onPressed(),
            icon: icon ?? Container(),
            label: RichText(
                text: TextSpan(
                    text: text,
                    style: TextStyle(
                        color: colorText,
                        fontSize: 20.0,
                        fontWeight: fontWeight)))));
  }
}
