import 'package:flutter/cupertino.dart';
import 'package:inclusive/classes/conversation.dart';

import 'package:inclusive/classes/user.dart';
import 'package:inclusive/screens/Messaging/conversation.dart';
import 'package:inclusive/screens/Register/register_1.dart';
import 'package:inclusive/screens/Register/register_2.dart';
import 'package:inclusive/screens/Register/register_3.dart';
import 'package:inclusive/screens/Search/results.dart';
import 'package:inclusive/screens/home.dart';
import 'package:inclusive/screens/landing.dart';

final Map<String, Widget Function(dynamic)> routes =
    <String, Widget Function(dynamic)>{
  LandingScreen.id: (dynamic arguments) => const LandingScreen(),
  Register1Screen.id: (dynamic arguments) => Register1Screen(),
  Register2Screen.id: (dynamic arguments) =>
      Register2Screen(arguments as String),
  Register3Screen.id: (dynamic arguments) =>
      Register3Screen(arguments as Map<String, String>),
  HomeScreen.id: (dynamic arguments) => HomeScreen(),
  ResultsScreen.id: (dynamic arguments) =>
      ResultsScreen(arguments as List<User>),
  ConversationScreen.id: (dynamic arguments) =>
      ConversationScreen(conversation: arguments as Conversation),
};
