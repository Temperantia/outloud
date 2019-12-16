import 'package:flutter/material.dart';

import 'package:inclusive/screens/Landing/index.dart';
import 'package:inclusive/screens/Register/index.dart';
import 'package:inclusive/screens/app.dart';

var routes = <String, WidgetBuilder>{
  LandingScreen.routeName: (BuildContext context) => LandingScreen(),
  Register1Screen.routeName: (BuildContext context) => Register1Screen(),
  AppScreen.routeName: (BuildContext context) => AppScreen(),
};
