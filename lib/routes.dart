import 'package:flutter/material.dart';

import 'package:inclusive/screens/Landing/index.dart';
import 'package:inclusive/screens/Register/index.dart';
import 'package:inclusive/screens/app.dart';

var routes = <String, WidgetBuilder>{
  '/Landing': (BuildContext context) => LandingScreen(),
  '/Register': (BuildContext context) => RegisterScreen(),
  '/Home': (BuildContext context) => AppScreen(),
};
