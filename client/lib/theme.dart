import 'package:flutter/material.dart';

const Color yellow = Color(0xFFFFEF00);
//Color orange = const Color(0xFFFF8C00);
const Color orangeLight = Color(0x66FF8C00);
const Color blue = Color(0xFF185782);
const Color blueLight = Color(0xFFBCE0FD);
const Color blueAlt = Color(0xFF28D6C0);
const Color white = Color(0xFFF9F5F5);
const Color black = Color(0xFF000000);

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

const LinearGradient gradientTopDown = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      pinkLight,
      orange,
    ]);

const TextStyle textStyleTitle =
    TextStyle(color: pink, fontSize: 24.0, fontWeight: FontWeight.bold);
const TextStyle textStyleTitleAlt =
    TextStyle(color: white, fontSize: 24.0, fontWeight: FontWeight.bold);
const TextStyle textStyleCardTitle =
    TextStyle(color: pink, fontSize: 20.0, fontWeight: FontWeight.bold);
const TextStyle textStyleCardTitleAlt =
    TextStyle(color: white, fontSize: 20.0, fontWeight: FontWeight.bold);
const TextStyle textStyleCardDescription = TextStyle(color: white);
const TextStyle textStyleListItemTitle = TextStyle(fontWeight: FontWeight.bold);
const TextStyle textStyleCardItemTitle =
    TextStyle(color: grey, fontWeight: FontWeight.bold);
const TextStyle textStyleButton =
    TextStyle(color: white, fontWeight: FontWeight.bold);
const TextStyle textStyleButtonAlt =
    TextStyle(color: grey, fontWeight: FontWeight.bold);

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
);
