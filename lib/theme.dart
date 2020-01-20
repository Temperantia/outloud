import 'package:flutter/material.dart';

Color yellow = const Color(0xFFFFEF00);
Color orange = const Color(0xFFFF8C00);
Color orangeLight = const Color(0x66FF8C00);
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
  sliderTheme: const SliderThemeData(
    showValueIndicator: ShowValueIndicator.always,
  ),
);
