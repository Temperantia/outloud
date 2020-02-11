import 'package:flutter/material.dart';

Color yellow = const Color(0xFFFFEF00);
//Color orange = const Color(0xFFFF8C00);
Color orangeLight = const Color(0x66FF8C00);
Color blue = const Color(0xFF185782);
Color blueLight = const Color(0xFFBCE0FD);
Color blueAlt = const Color(0xFF28D6C0);
Color white = const Color(0xFFF9F5F5);
Color black = const Color(0xFF000000);

const Color grey = Color(0xFF898989);
const Color red = Color(0xFFFF0000);
const Color pink = Color(0xFFF38181);
const Color pinkLight = Color(0xCCF38181);
const Color orange = Color(0xFFFCE38A);

const LinearGradient gradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[
      pinkLight,
      orange,
    ]);

ThemeData theme = ThemeData(
    //accentColor: white,
    buttonTheme: ButtonThemeData(
      buttonColor: pink,
      minWidth: 200.0,
      padding: const EdgeInsets.all(15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
    fontFamily: 'Hiragino',
    primaryColor: pink,
    sliderTheme: const SliderThemeData(
      showValueIndicator: ShowValueIndicator.always,
    ),
    textTheme: const TextTheme(body1: TextStyle(fontSize: 16.0)));
