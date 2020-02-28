import 'package:business/chats/models/chats_state.dart';
import 'package:business/events/models/events_state.dart';
import 'package:business/login/models/login_state.dart';
import 'package:business/people/models/people_state.dart';
import 'package:business/user/models/user_state.dart';

enum ThemeStyle {
  Orange,
  Purple,
}

class AppState {
  AppState({
    this.loginState,
    this.userState,
    this.eventsState,
    this.peopleState,
    this.chatsState,
    this.loading,
    this.homePageIndex,
    this.theme,
  });

  AppState copy({
    LoginState loginState,
    UserState userState,
    EventsState eventsState,
    PeopleState peopleState,
    ChatsState chatsState,
    bool loading,
    int homePageIndex,
    ThemeStyle theme,
  }) =>
      AppState(
        loginState: loginState ?? this.loginState,
        userState: userState ?? this.userState,
        eventsState: eventsState ?? this.eventsState,
        peopleState: peopleState ?? this.peopleState,
        chatsState: chatsState ?? this.chatsState,
        loading: loading ?? this.loading,
        homePageIndex: homePageIndex ?? this.homePageIndex,
        theme: theme ?? this.theme,
      );

  final LoginState loginState;
  final UserState userState;
  final EventsState eventsState;
  final PeopleState peopleState;
  final ChatsState chatsState;
  final bool loading;
  final int homePageIndex;
  final ThemeStyle theme;

  static AppState initialState({ChatsState chatsState}) => AppState(
        loginState: LoginState.initialState(),
        userState: UserState.initialState(),
        eventsState: EventsState.initialState(),
        peopleState: PeopleState.initialState(),
        chatsState: chatsState ?? ChatsState.initialState(),
        loading: true,
        homePageIndex: 0,
        theme: ThemeStyle.Orange,
      );
}
