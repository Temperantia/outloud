import 'package:flutter/material.dart';

Color orange = const Color(0xFFFF8D00);
Color white = const Color(0xFFF9F5F5);

ThemeData theme = new ThemeData(
  accentColor: white,
  buttonTheme: ButtonThemeData(
    buttonColor: orange,
    minWidth: 200.0,
    padding: EdgeInsets.all(15.0),
    shape: RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(20.0),
    ),
  ),
  primaryColor: orange,
  textTheme: TextTheme(
    subhead: TextStyle(
      color: white,
    ),
    title: TextStyle(
      fontSize: 24.0,
      color: white,
    ),
  ),
);
