import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/login/actions/login_google_action.dart';
import 'package:business/login/actions/login_facebook_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:inclusive/register/register_1.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/button.dart';
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
                            Column(children: const <Widget>[
                              Text('Meet colorful people',
                                  style: TextStyle(color: grey)),
                              Text('Events • Activities • Experiences',
                                  style: TextStyle(color: grey))
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
                                  text: 'CONTINUE WITH FACEBOOK',
                                  fontWeight: FontWeight.bold,
                                  width: 300.0,
                                  backgroundColor: blueDark,
                                  backgroundOpacity: 0.7,
                                  onPressed: () async {
                                    dispatch(LoginFacebookAction());
                                    dispatch(NavigateAction<AppState>.pushNamed(
                                        Register1Screen.id));
                                  }),
                            ]),
                            Button(
                                text: 'SIGN IN WITH GOOGLE',
                                fontWeight: FontWeight.bold,
                                width: 300.0,
                                onPressed: () async {
                                  dispatch(LoginGoogleAction());
                                  dispatch(NavigateAction<AppState>.pushNamed(
                                      Register1Screen.id));
                                }),
                            Container(height: 50.0)
                          ]))
                ])));
  }
}
