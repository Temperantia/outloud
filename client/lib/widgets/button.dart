import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:outloud/theme.dart';

class Button extends StatelessWidget {
  const Button(
      {@required this.text,
      this.icon,
      this.onPressed,
      this.width,
      this.height,
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
  final Widget icon;
  final Function onPressed;
  final double width;
  final double height;
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
        child: FlatButton.icon(
            padding: EdgeInsets.only(
                left: paddingLeft,
                right: paddingRight,
                top: paddingTop,
                bottom: paddingBottom),
            icon: icon ?? Container(width: 0.0, height: 0.0),
            color: backgroundColor.withOpacity(backgroundOpacity),
            textColor: colorText,
            onPressed: onPressed == null ? () {} : () => onPressed(),
            label: AutoSizeText(text,
                style: TextStyle(
                    color: colorText,
                    fontSize: fontSize,
                    fontWeight: fontWeight))));
  }
}
