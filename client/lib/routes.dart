import 'package:flutter/cupertino.dart';
import 'package:inclusive/events/event_create.dart';
import 'package:inclusive/events/event_groups_screen.dart';
import 'package:inclusive/events/event_screen.dart';
import 'package:inclusive/register/login.dart';

import 'package:inclusive/home_screen.dart';

final Map<String, Widget> routes = <String, Widget>{
  LoginScreen.id: LoginScreen(),
  HomeScreen.id: HomeScreen(),
  EventScreen.id: EventScreen(),
  EventGroupsScreen.id: EventGroupsScreen(),
  EventCreateScreen.id: EventCreateScreen(),
};
