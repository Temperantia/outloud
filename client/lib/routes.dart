import 'package:flutter/cupertino.dart';
import 'package:inclusive/register/login.dart';

import 'package:inclusive/register/register.dart';
import 'package:inclusive/register/register_1.dart';
import 'package:inclusive/register/register_2.dart';
import 'package:inclusive/register/register_3.dart';
import 'package:inclusive/home.dart';

final Map<String, Widget Function(dynamic)> routes =
    <String, Widget Function(dynamic)>{
  LoginScreen.id: (dynamic arguments) => LoginScreen(),
  RegisterScreen.id: (dynamic arguments) => RegisterScreen(),
  Register1Screen.id: (dynamic arguments) => Register1Screen(),
  Register2Screen.id: (dynamic arguments) =>
      Register2Screen(arguments as String),
  Register3Screen.id: (dynamic arguments) =>
      Register3Screen(arguments as Map<String, String>),
  HomeScreen.id: (dynamic arguments) => HomeScreen(),
};
