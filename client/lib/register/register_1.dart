import 'package:async_redux/async_redux.dart';
import 'package:business/actions/app_disconnect_action.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'package:outloud/register/register_2.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/button.dart';
import 'package:outloud/widgets/cached_image.dart';
import 'package:outloud/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class Register1Screen extends StatefulWidget {
  static const String id = 'Register1';
  @override
  _Register1ScreenState createState() => _Register1ScreenState();
}

class _Register1ScreenState extends State<Register1Screen> {
  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<dynamic>) dispatch,
        Widget child) {
      final User user = state.loginState.user;

      return View(
          showAppBar: false,
          showNavBar: false,
          child: Stack(children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[pinkLight, pink])),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 2 / 3,
              decoration: const BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0))),
            ),
            if (user == null)
              const Center(child: CircularProgressIndicator())
            else
              Container(
                  constraints: const BoxConstraints.expand(),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                            width: 50.0,
                            height: 50.0,
                            child: Image.asset('images/OL-draft2a.png')),
                        Text(
                            FlutterI18n.translate(
                                context, 'REGISTER_1.SIGNED_AS'),
                            style: const TextStyle(fontSize: 20.0)),
                        CachedImage(user.pics[0],
                            width: 150.0,
                            height: 150.0,
                            borderRadius: BorderRadius.circular(180.0),
                            imageType: ImageType.User),
                        Text(user.name, style: const TextStyle(fontSize: 26.0)),
                        if (state.userState.user == null)
                          Button(
                              text: FlutterI18n.translate(
                                  context, 'REGISTER_1.COMPLETE_PROFILE'),
                              width: MediaQuery.of(context).size.width * 0.8,
                              onPressed: () => dispatch(
                                  NavigateAction<AppState>.pushNamed(
                                      Register2Screen.id)))
                        else
                          Button(
                              text: FlutterI18n.translate(
                                  context, 'REGISTER_1.CONTINUE_APP'),
                              width: MediaQuery.of(context).size.width * 0.8,
                              onPressed: () =>
                                  dispatch(NavigateAction<AppState>.pop())),
                        Button(
                            text: FlutterI18n.translate(
                                context, 'REGISTER_1.BACK'),
                            width: MediaQuery.of(context).size.width * 0.8,
                            onPressed: () async {
                              await store.dispatchFuture(AppDisconnectAction());
                              dispatch(NavigateAction<AppState>.pop());
                            })
                      ])),
          ]));
    });
  }
}
