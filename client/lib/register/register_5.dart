import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/button.dart';
import 'package:inclusive/widgets/view.dart';
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
                                        'images/illustrationLounges.png',
                                        fit: BoxFit.fitWidth)),
                                const Text('Meet people in',
                                    style:
                                        TextStyle(color: grey, fontSize: 20.0)),
                                const Text('LOUNGES',
                                    style: TextStyle(fontSize: 40.0)),
                                const Text(
                                    'After joining an event, find a lounge to have people to go with who are just as hyped as you.',
                                    style: TextStyle(color: grey)),
                                Row(children: <Widget>[
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
                                text: 'BACK',
                                width: MediaQuery.of(context).size.width * 0.4,
                                onPressed: () =>
                                    dispatch(NavigateAction<AppState>.pop())),
                            Button(
                                text: 'FINISH',
                                width: MediaQuery.of(context).size.width * 0.4,
                                onPressed: () => Navigator.of(context).popUntil(
                                    (Route<dynamic> route) => route.isFirst))
                          ]))
                    ])))
          ]));
    });
  }
}
