import 'package:async_redux/async_redux.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:business/app_state.dart';
import 'package:business/login/actions/login_apple_action.dart';
import 'package:business/login/actions/login_google_action.dart';
import 'package:business/login/actions/login_facebook_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:outloud/register/register_1.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/button.dart';
import 'package:outloud/widgets/view.dart';

import 'package:provider_for_redux/provider_for_redux.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'Login';

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(
        builder: (BuildContext context, Store<AppState> store, AppState state,
                void Function(ReduxAction<AppState>) dispatch, Widget child) =>
            View(
                showAppBar: false,
                showNavBar: false,
                child: Stack(children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                        gradient:
                            LinearGradient(colors: <Color>[pinkLight, pink])),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 3 / 5,
                    decoration: const BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0))),
                  ),
                  Container(
                      constraints: const BoxConstraints.expand(),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: 100.0,
                                height: 100.0,
                                child: Image.asset('images/OL-draft2a.png')),
                            Container(
                                width: 200.0,
                                child: Image.asset('images/OL-blue.png')),
                            Column(children: <Widget>[
                              AutoSizeText(
                                  FlutterI18n.translate(
                                      context, 'LOGIN.MOTTO_1'),
                                  style: const TextStyle(color: grey)),
                              AutoSizeText(
                                  FlutterI18n.translate(
                                      context, 'LOGIN.MOTTO_2'),
                                  style: const TextStyle(color: grey))
                            ]),
                            Column(children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height:
                                      MediaQuery.of(context).size.width * 0.65,
                                  child: Image.asset(
                                      'images/illustrationSplash.png',
                                      fit: BoxFit.fitWidth)),
                              Button(
                                  text: FlutterI18n.translate(
                                      context, 'LOGIN.FACEBOOK'),
                                  fontWeight: FontWeight.bold,
                                  width: 300.0,
                                  backgroundColor: blueDark,
                                  backgroundOpacity: 0.7,
                                  onPressed: () {
                                    dispatch(LoginFacebookAction());
                                    dispatch(NavigateAction<AppState>.pushNamed(
                                        Register1Screen.id));
                                  }),
                            ]),
                            Button(
                                text: FlutterI18n.translate(
                                    context, 'LOGIN.GOOGLE'),
                                fontWeight: FontWeight.bold,
                                width: 300.0,
                                onPressed: () {
                                  dispatch(LoginGoogleAction());
                                  dispatch(NavigateAction<AppState>.pushNamed(
                                      Register1Screen.id));
                                }),
                            Button(
                                text: FlutterI18n.translate(
                                    context, 'LOGIN.APPLE'),
                                fontWeight: FontWeight.bold,
                                width: 300.0,
                                onPressed: () {
                                  dispatch(LoginAppleAction());
                                  dispatch(NavigateAction<AppState>.pushNamed(
                                      Register1Screen.id));
                                }),
                          ]))
                ])));
  }
}
