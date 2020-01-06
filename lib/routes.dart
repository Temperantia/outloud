import 'package:inclusive/screens/Landing/index.dart';
import 'package:inclusive/screens/Landing/register-1.dart';
import 'package:inclusive/screens/Landing/register-2.dart';
import 'package:inclusive/screens/Landing/register-3.dart';
import 'package:inclusive/screens/Search/results.dart';

import 'package:inclusive/screens/home.dart';
import 'package:inclusive/screens/loading.dart';

final Map<String, Function> routes = <String, Function>{
  LandingScreen.id: (arguments) => LandingScreen(),
  LoadingScreen.id: (arguments) => LoadingScreen(),
  Register1Screen.id: (arguments) => Register1Screen(),
  Register2Screen.id: (arguments) => Register2Screen(arguments),
  Register3Screen.id: (arguments) => Register3Screen(arguments),
  HomeScreen.id: (arguments) => HomeScreen(),
  ResultsScreen.id: (arguments) => ResultsScreen(arguments),
};
