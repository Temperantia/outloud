import 'package:flutter/material.dart';
import 'package:inclusive/screens/Search/results.dart';
import 'package:inclusive/screens/app.dart';

import 'package:inclusive/screens/home.dart';

var routes = <String, WidgetBuilder>{
  '/': (BuildContext context) => HomeScreen(),
  AppScreen.id: (BuildContext content) => AppScreen(),
  '/Results': (BuildContext context) => ResultsScreen(),
};