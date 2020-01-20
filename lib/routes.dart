import 'package:flutter/cupertino.dart';

import 'package:inclusive/classes/conversation.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/screens/Messaging/conversation.dart';
import 'package:inclusive/screens/Profile/profile_information.dart';
import 'package:inclusive/screens/Register/register_1.dart';
import 'package:inclusive/screens/Register/register_2.dart';
import 'package:inclusive/screens/Register/register_3.dart';
import 'package:inclusive/screens/home.dart';
import 'package:inclusive/screens/Profile/profile.dart';

final Map<String, Widget Function(dynamic)> routes =
    <String, Widget Function(dynamic)>{
  Register1Screen.id: (dynamic arguments) => Register1Screen(),
  Register2Screen.id: (dynamic arguments) =>
      Register2Screen(arguments as String),
  Register3Screen.id: (dynamic arguments) =>
      Register3Screen(arguments as Map<String, String>),
  HomeScreen.id: (dynamic arguments) => HomeScreen(),
  ConversationScreen.id: (dynamic arguments) =>
      ConversationScreen(conversation: arguments as Conversation),
  ProfileScreen.id: (dynamic arguments) =>
      ProfileScreen(user: arguments as User),
  ProfileInformationScreen.id: (dynamic arguments) =>
      ProfileInformationScreen(),
};
