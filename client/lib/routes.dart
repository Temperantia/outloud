import 'package:business/classes/chat.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';
import 'package:outloud/people/chat_screen.dart';
import 'package:outloud/events/event_attending_screen.dart';
import 'package:outloud/events/event_screen.dart';
import 'package:outloud/lounges/lounge_chat_screen.dart';
import 'package:outloud/lounges/lounge_create_detail_screen.dart';
import 'package:outloud/lounges/lounge_create_meetup_screen.dart';
import 'package:outloud/lounges/lounge_create_screen.dart';
import 'package:outloud/lounges/lounge_edit_screen.dart';
import 'package:outloud/lounges/lounge_view_screen.dart';
import 'package:outloud/lounges/lounges_screen.dart';
import 'package:outloud/people/people_search_screen.dart';
import 'package:outloud/profile/profile_screen.dart';
import 'package:outloud/register/login.dart';
import 'package:flutter/material.dart';
import 'package:outloud/home_screen.dart';
import 'package:outloud/register/register_1.dart';
import 'package:outloud/register/register_2.dart';
import 'package:outloud/register/register_3.dart';
import 'package:outloud/register/register_4.dart';
import 'package:outloud/register/register_5.dart';

final Map<String, Widget Function(Object)> routes =
    <String, Widget Function(Object)>{
  LoginScreen.id: (_) => LoginScreen(),
  Register1Screen.id: (_) => Register1Screen(),
  Register2Screen.id: (_) => Register2Screen(),
  Register3Screen.id: (_) => Register3Screen(),
  Register4Screen.id: (_) => Register4Screen(),
  Register5Screen.id: (_) => Register5Screen(),
  HomeScreen.id: (_) => HomeScreen(),
  EventScreen.id: (dynamic event) => EventScreen(event as Event),
  EventAttendingScreen.id: (dynamic event) =>
      EventAttendingScreen(event as Event),
  LoungesScreen.id: (dynamic event) => LoungesScreen(event as Event),
  LoungeChatScreen.id: (dynamic lounge) => LoungeChatScreen(lounge as Lounge),
  LoungeCreateScreen.id: (_) => LoungeCreateScreen(),
  LoungeCreateDetailScreen.id: (_) => LoungeCreateDetailScreen(),
  LoungeCreateMeetupScreen.id: (_) => LoungeCreateMeetupScreen(),
  LoungeEditScreen.id: (dynamic lounge) => LoungeEditScreen(lounge as Lounge),
  LoungeViewScreen.id: (dynamic lounge) => LoungeViewScreen(lounge as Lounge),
  ProfileScreen.id: (dynamic settings) =>
      ProfileScreen(settings['user'] as User, settings['isEdition'] as bool),
  ChatScreen.id: (dynamic chat) => ChatScreen(chat as Chat),
  PeopleSearchScreen.id: (_) => PeopleSearchScreen(),
};
