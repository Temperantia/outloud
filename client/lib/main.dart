import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:business/app_state.dart';
import 'package:inclusive/home.dart';
import 'package:inclusive/register/login.dart';
import 'package:business/login/actions/login_action.dart';
import 'package:inclusive/routes.dart';

import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/loading.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

Store<AppState> store;

void main() {
  store = Store<AppState>(initialState: AppState.initialState());
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AsyncReduxProvider<AppState>.value(
        value: store,
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme,
            title: 'Inc•lusive',
            home: ReduxConsumer<AppState>(
              builder: (BuildContext context,
                  Store<AppState> store,
                  AppState state,
                  void Function(ReduxAction<dynamic>) dispatch,
                  Widget child) {
                if (state.loading) {
                  print('loading');
                  // init state
                  dispatch(LoginAction());

                  return Loading();
                }
                print('not loading');
                if (state.loginState.id == null) {
                  return LoginScreen();
                }
                return HomeScreen();
              },
            ),
            onGenerateRoute: (RouteSettings settings) =>
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => routes[settings.name],
                )));
  }
}
