import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/login/actions/login_google_action.dart';
import 'package:business/login/actions/login_facebook_action.dart';
import 'package:business/user/actions/user_listen_stream_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:inclusive/home_screen.dart';
import 'package:inclusive/widgets/background.dart';
import 'package:inclusive/widgets/view.dart';

import 'package:provider_for_redux/provider_for_redux.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'Login';

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(
        builder: (BuildContext context, Store<AppState> store, AppState state,
                void Function(ReduxAction<dynamic>) dispatch, Widget child) =>
            View(
                showAppBar: false,
                showNavBar: false,
                child: Container(
                    decoration: background,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: 300.0,
                                  child: GoogleSignInButton(
                                      borderRadius: 50.0,
                                      darkMode: true,
                                      onPressed: () async {
                                        await store.dispatchFuture(LoginGoogleAction());
                                        dispatch(
                                            NavigateAction<AppState>.pushNamed(
                                                HomeScreen.id));
                                      })),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: 300.0,
                                  child: FacebookSignInButton(
                                      borderRadius: 50.0,
                                      onPressed: () async {
                                        await store.dispatchFuture(
                                            LoginFacebookAction());
                                        dispatch(
                                            NavigateAction<AppState>.pushNamed(
                                                HomeScreen.id));
                                      })),
                            ],
                          ),
                          Text(state.loginState.loginError),
                        ]))));
  }
}
