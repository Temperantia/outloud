import 'package:async_redux/async_redux.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:business/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/button.dart';
import 'package:outloud/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class Register5Screen extends StatefulWidget {
  static const String id = 'Register5';

  @override
  _Register5ScreenState createState() => _Register5ScreenState();
}

class _Register5ScreenState extends State<Register5Screen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<AppState>) dispatch,
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
                            child: Image.asset('images/OL-draft2a.png',
                                width: 50.0, height: 50.0)),
                      ]),
                      Expanded(
                          flex: 7,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Image.asset('images/illustrationLounges.png',
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: MediaQuery.of(context).size.width *
                                        0.65,
                                    fit: BoxFit.fitWidth),
                                AutoSizeText(
                                    FlutterI18n.translate(
                                        context, 'REGISTER_5.TITLE'),
                                    style: const TextStyle(
                                        color: grey, fontSize: 20.0)),
                                AutoSizeText(
                                    FlutterI18n.translate(
                                        context, 'REGISTER_5.TITLE_BIG'),
                                    style: const TextStyle(fontSize: 40.0)),
                                AutoSizeText(
                                    FlutterI18n.translate(
                                        context, 'REGISTER_5.SUBTITLE'),
                                    style: const TextStyle(color: grey)),
                                Row(children: const <Widget>[
                                  Icon(Icons.radio_button_unchecked,
                                      size: 10.0),
                                  Icon(Icons.lens, size: 10.0)
                                ])
                              ])),
                      Expanded(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                            Button(
                                text: FlutterI18n.translate(
                                    context, 'REGISTER_5.BACK'),
                                width: MediaQuery.of(context).size.width * 0.4,
                                onPressed: () =>
                                    dispatch(NavigateAction<AppState>.pop())),
                            Button(
                                text: FlutterI18n.translate(
                                    context, 'REGISTER_5.NEXT'),
                                width: MediaQuery.of(context).size.width * 0.4,
                                onPressed: () => Navigator.of(context).popUntil(
                                    (Route<dynamic> route) => route.isFirst))
                          ]))
                    ])))
          ]));
    });
  }
}
