import 'package:flutter/material.dart';

Color orange = const Color(0xFFFF8D00);
Color orangeLight = const Color(0x66FF8D00);
Color blue = const Color(0xFF185782);
Color blueLight = const Color(0xFFBCE0FD);
Color red = const Color(0xFFFF0000);
Color white = const Color(0xFFF9F5F5);

ThemeData theme = ThemeData(
  accentColor: white,
  buttonTheme: ButtonThemeData(
    buttonColor: orange,
    minWidth: 200.0,
    padding: const EdgeInsets.all(15.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
  ),
  primaryColor: orange,
  sliderTheme: SliderThemeData(
    showValueIndicator: ShowValueIndicator.always,
  ),
  textTheme: TextTheme(
    caption: TextStyle(
      fontSize: 18.0,
      color: white,
    ),
    subhead: TextStyle(
      color: white,
    ),
    title: TextStyle(
      fontSize: 24.0,
      color: white,
    ),
  ),
);
