import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/login/actions/login_google_action.dart';
import 'package:business/login/actions/login_facebook_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

import 'package:provider_for_redux/provider_for_redux.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({this.connected, this.onLoginGoogle, this.onLoginEmail});
  static const String id = 'Login';
  final bool connected;
  final VoidCallback onLoginGoogle;
  final VoidCallback onLoginEmail;
  final TextEditingController _controllerEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(
        builder: (BuildContext context, Store<AppState> store, AppState state,
                void Function(ReduxAction<dynamic>) dispatch, Widget child) =>
            Scaffold(
                resizeToAvoidBottomInset: false,
                body: Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('images/scene.png'),
                            fit: BoxFit.cover)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(state.loginState.connected.toString()),
                          Text(state.userState.user?.name.toString()),
                          Container(
                              padding: const EdgeInsets.all(10.0),
                              child: TextField(
                                decoration:
                                    const InputDecoration(hintText: 'Email'),
                                controller: _controllerEmail,
                              )),
                          RaisedButton(
                              onPressed: () {
                                //Navigator.of(context).pushNamed(LoginScreen.id);
                              },
                              child: Text('LOGIN',
                                  style: Theme.of(context).textTheme.title)),
                          Container(
                              width: 270.0,
                              child: GoogleSignInButton(
                                  borderRadius: 50.0,
                                  darkMode: true,
                                  onPressed: () =>
                                      dispatch(LoginGoogleAction()))),
                          Container(
                              width: 270.0,
                              child: FacebookSignInButton(
                                  borderRadius: 50.0,
                                  onPressed: () =>
                                      dispatch(LoginFacebookAction()))),
                          Text(state.loginState.loginError),
                        ]))));
  }
}
