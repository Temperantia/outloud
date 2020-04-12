import 'package:business/app_state.dart';
import 'package:flutter/material.dart';

const Color yellow = Color(0xFFFFEF00);
const Color orangeLight = Color(0xFFFFD3B1);
const Color orangeAlt = Color(0xFFFFA067);
const Color blue = Color(0xFF01B5D6);
const Color blueDark = Color(0xFF0C2F61);

const Color white = Color(0xFFF9F5F5);
Color whiteAlt = const Color(0xFFFF764C).withOpacity(0.1);
const Color black = Color(0xFF292929);
const Color grey = Color(0xFF898989);
const Color red = Color(0xFFFF0000);
const Color pinkBright = Color(0xFFFF5437);
const Color pink = Color(0xFFFF706F);

const Color pinkLight = Color(0xFFFA9465);
const Color orange = Color(0xFFFF8431);
const Color purple = Color(0xFF6324CA);

Color primary(ThemeStyle themeStyle) =>
    themeStyle == ThemeStyle.Orange ? orange : purple;

Color secondary(ThemeStyle themeStyle) =>
    themeStyle == ThemeStyle.Orange ? orangeLight : blue;

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

ThemeData theme(ThemeStyle themeStyle) => ThemeData(fontFamily: 'Hiragino');
