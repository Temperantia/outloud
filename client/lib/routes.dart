import 'package:business/classes/chat.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';
import 'package:inclusive/chats/chat_screen.dart';
import 'package:inclusive/events/event_create_screen.dart';
import 'package:inclusive/events/event_groups_screen.dart';
import 'package:inclusive/events/event_screen.dart';
import 'package:inclusive/lounges/lounge_create_detail_screen.dart';
import 'package:inclusive/lounges/lounge_create_meetup_screen.dart';
import 'package:inclusive/lounges/lounge_create_screen.dart';
import 'package:inclusive/lounges/lounge_screen.dart';
import 'package:inclusive/lounges/lounges_screen.dart';
import 'package:inclusive/people/people_search_screen.dart';
import 'package:inclusive/profile/profile_screen.dart';
import 'package:inclusive/profile/profile_edition_screen.dart';
import 'package:inclusive/register/login.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/home_screen.dart';

final Map<String, Widget Function(Object)> routes =
    <String, Widget Function(Object)>{
  LoginScreen.id: (_) => LoginScreen(),
  HomeScreen.id: (_) => HomeScreen(),
  ProfileEditionScreen.id: (_) => ProfileEditionScreen(),
  EventScreen.id: (_) => EventScreen(),
  EventGroupsScreen.id: (_) => EventGroupsScreen(),
  LoungesScreen.id: (dynamic event) => LoungesScreen(event as Event),
  LoungeScreen.id: (dynamic lounge) => LoungeScreen(lounge as Lounge),
  LoungeCreateScreen.id: (_) => LoungeCreateScreen(),
  LoungeCreateDetailScreen.id: (_) => LoungeCreateDetailScreen(),
  LoungeCreateMeetupScreen.id: (_) => LoungeCreateMeetupScreen(),
  ProfileScreen.id: (dynamic user) => ProfileScreen(user as User),
  EventCreateScreen.id: (_) => EventCreateScreen(),
  ChatScreen.id: (dynamic chat) => ChatScreen(chat as Chat),
  PeopleSearchScreen.id: (_) => PeopleSearchScreen(),
};
