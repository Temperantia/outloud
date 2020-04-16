import 'package:async_redux/async_redux.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:business/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:outloud/register/register_5.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/button.dart';
import 'package:outloud/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class Register4Screen extends StatefulWidget {
  static const String id = 'Register4';

  @override
  _Register4ScreenState createState() => _Register4ScreenState();
}

class _Register4ScreenState extends State<Register4Screen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<dynamic>) dispatch,
        Widget child) {
      return View(
          showAppBar: false,
          showNavBar: false,
          child: Stack(children: <Widget>[
            Container(
                decoration: const BoxDecoration(
                    gradient:
                        LinearGradient(colors: <Color>[pinkLight, pink]))),
            Container(
                height: MediaQuery.of(context).size.height * 5 / 6,
                decoration: const BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0)))),
            Container(
                constraints: const BoxConstraints.expand(),
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(children: <Widget>[
                      Row(children: <Widget>[
                        Expanded(
                            child: Container(
                                width: 50.0,
                                height: 50.0,
                                child: Image.asset('images/OL-draft2a.png'))),
                      ]),
                      Expanded(
                          flex: 7,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: MediaQuery.of(context).size.width *
                                        0.65,
                                    child: Image.asset(
                                        'images/illustrationEvents.png',
                                        fit: BoxFit.fitWidth)),
                                AutoSizeText(
                                    FlutterI18n.translate(
                                        context, 'REGISTER_4.TITLE'),
                                    style: const TextStyle(
                                        color: grey, fontSize: 20.0)),
                                AutoSizeText(
                                    FlutterI18n.translate(
                                        context, 'REGISTER_4.TITLE_BIG'),
                                    style: const TextStyle(fontSize: 40.0)),
                                AutoSizeText(
                                    FlutterI18n.translate(
                                        context, 'REGISTER_4.SUBTITLE'),
                                    style: const TextStyle(color: grey)),
                                Row(children: <Widget>[
                                  Icon(Icons.lens, size: 10.0),
                                  Icon(Icons.radio_button_unchecked, size: 10.0)
                                ])
                              ])),
                      Expanded(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                            Button(
                                text: FlutterI18n.translate(
                                    context, 'REGISTER_4.BACK'),
                                width: MediaQuery.of(context).size.width * 0.4,
                                onPressed: () =>
                                    dispatch(NavigateAction<AppState>.pop())),
                            Button(
                                text: FlutterI18n.translate(
                                    context, 'REGISTER_4.NEXT'),
                                width: MediaQuery.of(context).size.width * 0.4,
                                onPressed: () => dispatch(
                                    NavigateAction<AppState>.pushNamed(
                                        Register5Screen.id)))
                          ]))
                    ])))
          ]));
    });
  }
}
