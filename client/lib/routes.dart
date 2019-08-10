import 'package:flutter/material.dart';

import 'package:inclusive/screens/Landing/index.dart';
import 'package:inclusive/screens/Register/index.dart';

var routes = <String, WidgetBuilder>{
  '/Landing': (BuildContext context) => LandingScreen(),
  '/Register1': (BuildContext context) => Register1Screen(),
};
