import 'package:business/chats/chats_state.dart';
import 'package:business/events/events_state.dart';
import 'package:business/login/login_state.dart';
import 'package:business/lounges/lounges_state.dart';
import 'package:business/people/people_state.dart';
import 'package:business/user/user_state.dart';

enum ThemeStyle {
  Orange,
  Purple,
}

class AppState {
  AppState(
      {this.loginState,
      this.userState,
      this.eventsState,
      this.loungesState,
      this.peopleState,
      this.chatsState,
      this.loading,
      this.homePageIndex,
      this.eventsTabIndex,
      this.theme});

  AppState copy({
    LoginState loginState,
    UserState userState,
    EventsState eventsState,
    LoungesState loungesState,
    PeopleState peopleState,
    ChatsState chatsState,
    bool loading,
    int homePageIndex,
    int eventsTabIndex,
    ThemeStyle theme,
  }) =>
      AppState(
          loginState: loginState ?? this.loginState,
          userState: userState ?? this.userState,
          eventsState: eventsState ?? this.eventsState,
          loungesState: loungesState ?? this.loungesState,
          peopleState: peopleState ?? this.peopleState,
          chatsState: chatsState ?? this.chatsState,
          loading: loading ?? this.loading,
          homePageIndex: homePageIndex ?? this.homePageIndex,
          eventsTabIndex: eventsTabIndex ?? this.eventsTabIndex,
          theme: theme ?? this.theme);

  final LoginState loginState;
  final UserState userState;
  final EventsState eventsState;
  final LoungesState loungesState;
  final PeopleState peopleState;
  final ChatsState chatsState;
  final bool loading;
  final int homePageIndex;
  final int eventsTabIndex;
  final ThemeStyle theme;

  static AppState initialState({ChatsState chatsState, ThemeStyle theme}) =>
      AppState(
          loginState: LoginState.initialState(),
          userState: UserState.initialState(),
          eventsState: EventsState.initialState(),
          loungesState: LoungesState.initialState(),
          peopleState: PeopleState.initialState(),
          chatsState: chatsState ?? ChatsState.initialState(),
          loading: true,
          homePageIndex: 0,
          eventsTabIndex: 0,
          theme: theme ?? ThemeStyle.Orange);
}
