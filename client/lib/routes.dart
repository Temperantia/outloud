import 'package:flutter/cupertino.dart';
import 'package:inclusive/events/event_groups_screen.dart';
import 'package:inclusive/events/event_screen.dart';
import 'package:inclusive/profile/profile_screen.dart';
import 'package:inclusive/register/login.dart';

import 'package:inclusive/home_screen.dart';

final Map<String, Widget> routes = <String, Widget>{
  '/': HomeScreen(),
  LoginScreen.id: LoginScreen(),
  HomeScreen.id: HomeScreen(),
  EventScreen.id: EventScreen(),
  EventGroupsScreen.id: EventGroupsScreen(),
  ProfileScreen.id: ProfileScreen(),
};
