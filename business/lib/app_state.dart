import 'package:business/events/models/events_state.dart';
import 'package:business/login/models/login_state.dart';
import 'package:business/user/models/user_state.dart';

class AppState {
  AppState({
    this.loginState,
    this.userState,
    this.eventsState,
    this.loading,
    this.homePageIndex,
  });

  AppState copy({
    LoginState loginState,
    UserState userState,
    EventsState eventsState,
    bool loading,
    int homePageIndex,
  }) =>
      AppState(
        loginState: loginState ?? this.loginState,
        userState: userState ?? this.userState,
        eventsState: eventsState ?? this.eventsState,
        loading: loading ?? this.loading,
        homePageIndex: homePageIndex ?? this.homePageIndex,
      );

  final LoginState loginState;
  final UserState userState;
  final EventsState eventsState;
  final bool loading;
  final int homePageIndex;

  static AppState initialState() => AppState(
        loginState: LoginState.initialState(),
        userState: UserState.initialState(),
        eventsState: EventsState.initialState(),
        loading: true,
        homePageIndex: 0,
      );
}
