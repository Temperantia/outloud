import 'package:business/events/models/events_state.dart';
import 'package:business/login/models/login_state.dart';
import 'package:business/people/models/people_state.dart';
import 'package:business/user/models/user_state.dart';

class AppState {
  AppState({
    this.loginState,
    this.userState,
    this.eventsState,
    this.peopleState,
    this.loading,
    this.homePageIndex,
  });

  AppState copy({
    LoginState loginState,
    UserState userState,
    EventsState eventsState,
    PeopleState peopleState,
    bool loading,
    int homePageIndex,
  }) =>
      AppState(
        loginState: loginState ?? this.loginState,
        userState: userState ?? this.userState,
        eventsState: eventsState ?? this.eventsState,
        peopleState: peopleState ?? this.peopleState,
        loading: loading ?? this.loading,
        homePageIndex: homePageIndex ?? this.homePageIndex,
      );

  final LoginState loginState;
  final UserState userState;
  final EventsState eventsState;
  final PeopleState peopleState;
  final bool loading;
  final int homePageIndex;

  static AppState initialState() => AppState(
        loginState: LoginState.initialState(),
        userState: UserState.initialState(),
        eventsState: EventsState.initialState(),
        peopleState: PeopleState.initialState(),
        loading: true,
        homePageIndex: 0,
      );
}
