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

// TextStyle(fontSize: 10)
// TextStyle(fontSize: 13)
// TextStyle(fontSize: 14)
// TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
// TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
// TextStyle(fontSize: 16)
// TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
// TextStyle(fontSize: 20)
// TextStyle(fontSize: 26)
// TextStyle(color: blue, fontSize: 12)
// TextStyle(color: orange, fontSize: 10, fontWeight: FontWeight.bold)
// TextStyle(color: orange, fontSize: 12, fontWeight: FontWeight.bold)
// TextStyle(color: orange, fontSize: 14)
// TextStyle(color: orange, fontSize: 14, fontWeight: FontWeight.bold)
// TextStyle(color: orange, fontSize: 16)
// TextStyle(color: orange, fontSize: 20)
// TextStyle(color: orange, fontSize: 26, fontWeight: FontWeight.bold)
// TextStyle(color: white, fontSize: 10, fontWeight: FontWeight.bold)
// TextStyle(color: white, fontSize: 12)
// TextStyle(color: white, fontSize: 14)
// TextStyle(color: white, fontSize: 14, fontWeight: FontWeight.bold)
// TextStyle(color: white, fontSize: 15, fontWeight: FontWeight.bold)
// TextStyle(color: white, fontSize: 16)
// TextStyle(color: white, fontSize: 20,  fontWeight: FontWeight.bold)
// TextStyle(color: white, fontSize: 24, fontWeight: FontWeight.bold)
// TextStyle(color: pink, fontSize: 14)
// TextStyle(color: pink, fontSize: 14, fontWeight: FontWeight.bold)
// TextStyle(color: pinkBright, fontSize: 12)
// TextStyle(color: pinkBright, fontSize: 14)
// TextStyle(color: pinkBright, fontSize: 20)
// TextStyle(color: grey, fontSize: 14)
// TextStyle(color: grey, fontSize: 20)
// TextStyle(color: Theme.of(context).errorColor, fontSize: 12)
ThemeData theme(ThemeStyle themeStyle) => ThemeData(fontFamily: 'Raleway');
