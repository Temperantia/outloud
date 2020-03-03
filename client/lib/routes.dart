import 'package:business/classes/chat.dart';
import 'package:business/classes/user.dart';
import 'package:inclusive/chats/chat_screen.dart';
import 'package:inclusive/events/event_create_screen.dart';
import 'package:inclusive/events/event_groups_screen.dart';
import 'package:inclusive/events/event_screen.dart';
import 'package:inclusive/people/people_search_screen.dart';
import 'package:inclusive/profile/profile_screen.dart';
import 'package:inclusive/profile/profile_edition_screen.dart';
import 'package:inclusive/register/login.dart';

import 'package:inclusive/home_screen.dart';

final routes = {
  LoginScreen.id: (arguments) => LoginScreen(),
  HomeScreen.id: (arguments) => HomeScreen(),
  ProfileEditionScreen.id: (arguments) => ProfileEditionScreen(),
  EventScreen.id: (arguments) => EventScreen(),
  EventGroupsScreen.id: (arguments) => EventGroupsScreen(),
  ProfileScreen.id: (arguments) => ProfileScreen(arguments as User),
  EventCreateScreen.id: (arguments) => EventCreateScreen(),
  ChatScreen.id: (arguments) => ChatScreen(arguments as Chat),
  PeopleSearchScreen.id: (arguments) => PeopleSearchScreen(),
};
