import 'package:business/app_state.dart';
import 'package:flutter/material.dart';

const Color yellow = Color(0xFFFFEF00);
//Color orange = const Color(0xFFFF8C00);
const Color orangeLight = Color(0xFFFFD3B1);
const Color orangeAlt = Color(0xFFFFA067);
const Color blue = Color(0xFF185782);
const Color blueLight = Color(0xFFBCE0FD);
const Color blueAlt = Color(0xFF28D6C0);
const Color white = Color(0xFFF9F5F5);
Color whiteAlt = const Color(0xFFFF764C).withOpacity(0.1);
const Color black = Color(0xFF000000);
const Color grey = Color(0xFF898989);
const Color red = Color(0xFFFF0000);
const Color pinkBright = Color(0xFFFF6260);
const Color pink = Color(0xFFFF706F);

const Color pinkLight = Color(0xCCF38181);
const Color orange = Color(0xFFFF6000);
const Color purple = Color(0xFF6324CA);

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

Color primary(ThemeStyle themeStyle) =>
    themeStyle == ThemeStyle.Orange ? orange : purple;

Color secondary(ThemeStyle themeStyle) =>
    themeStyle == ThemeStyle.Orange ? orangeLight : blueLight;

TextStyle textStyleTitle(ThemeStyle themeStyle) => TextStyle(
    color: primary(themeStyle), fontSize: 24.0, fontWeight: FontWeight.bold);
const TextStyle textStyleTitleAlt =
    TextStyle(color: white, fontSize: 16.0, fontWeight: FontWeight.bold);

TextStyle textStyleCardTitle(ThemeStyle themeStyle) => TextStyle(
    color: primary(themeStyle), fontSize: 20.0, fontWeight: FontWeight.bold);
const TextStyle textStyleCardTitleAlt =
    TextStyle(color: white, fontSize: 20.0, fontWeight: FontWeight.bold);
const TextStyle textStyleCardDescription = TextStyle(color: white);
const TextStyle textStyleCardItemTitle = TextStyle(fontWeight: FontWeight.bold);
TextStyle textStyleCardItemContent(ThemeStyle themeStyle) =>
    TextStyle(fontWeight: FontWeight.bold, color: primary(themeStyle));

const TextStyle textStyleListItemTitle =
    TextStyle(color: white, fontSize: 20.0, fontWeight: FontWeight.bold);
const TextStyle textStyleListItemSubtitle =
    TextStyle(color: grey, fontWeight: FontWeight.bold);

const TextStyle textStyleButton =
    TextStyle(color: white, fontWeight: FontWeight.bold);
const TextStyle textStyleButtonAlt =
    TextStyle(color: grey, fontWeight: FontWeight.bold);

ThemeData theme(ThemeStyle themeStyle) => ThemeData(
      accentColor: white,
      /*  buttonTheme: ButtonThemeData(
    buttonColor: primary,
    minWidth: 200.0,
    padding: const EdgeInsets.all(15.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
  ), */
      fontFamily: 'Hiragino',
      primaryColor: primary(themeStyle),
      sliderTheme: const SliderThemeData(
        showValueIndicator: ShowValueIndicator.always,
      ),
    );
