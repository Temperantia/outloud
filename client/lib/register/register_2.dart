import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/login/actions/login_interests_action.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/register/register_3.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/button.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class Register2Screen extends StatefulWidget {
  static const String id = 'Register2';

  @override
  _Register2ScreenState createState() => _Register2ScreenState();
}

class _Register2ScreenState extends State<Register2Screen> {
  final List<String> _interests = <String>[
    'Food & Drink',
    'Art',
    'Fashion & Beauty',
    'Outdoors & Adventure',
    'Sport',
    'Fitness',
    'Tech',
    'Health & Wellness',
    'Self Growth',
    'Photography',
    'Writing',
    'Culture & Language',
    'Music',
    'Activism',
    'Film',
    'Gaming',
    'Beliefs',
    'Books',
    'Dance',
    'Pet',
    'Craft'
  ];

  final Map<String, bool> _selected = <String, bool>{};

  @override
  void initState() {
    super.initState();
    for (final String interest in _interests) {
      _selected[interest] = false;
    }
  }

  Widget _buildInterest(MapEntry<String, bool> interest) {
    return interest.value
        ? GestureDetector(
            onTap: () => setState(() => _selected[interest.key] = false),
            child: Container(
                decoration:
                    BoxDecoration(color: pink, border: Border.all(color: pink)),
                padding: const EdgeInsets.all(5.0),
                margin: const EdgeInsets.all(5.0),
                child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Text(interest.key.toUpperCase(),
                      style: const TextStyle(color: white)),
                  Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Icon(Icons.check, color: white, size: 12.0))
                ])),
          )
        : GestureDetector(
            onTap: () => setState(() => _selected[interest.key] = true),
            child: Container(
                decoration: BoxDecoration(border: Border.all(color: pink)),
                padding: const EdgeInsets.all(5.0),
                margin: const EdgeInsets.all(5.0),
                child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Text(interest.key.toUpperCase(),
                      style: const TextStyle(color: pink)),
                  Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Icon(Icons.radio_button_unchecked,
                          color: pink, size: 12.0))
                ])));
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
                        Expanded(child: Container()),
                        Expanded(
                            child: Container(
                                width: 50.0,
                                height: 50.0,
                                child: Image.asset('images/OL-draft2a.png'))),
                        Expanded(
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                    onTap: () => dispatch(
                                        NavigateAction<AppState>.pushNamed(
                                            Register3Screen.id)),
                                    child: const Text('Skip >',
                                        style: TextStyle(color: grey)))))
                      ]),
                      Expanded(
                          flex: 7,
                          child: ListView(children: <Widget>[
                            const Text('Tell us about what interests you',
                                style: TextStyle(fontSize: 20.0)),
                            const Text(
                                'Help us find people and events for you that you\'ll really enjoy.',
                                style: TextStyle(color: grey)),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height:
                                    MediaQuery.of(context).size.width * 0.65,
                                child: Image.asset(
                                    'images/illustrationInterests.png',
                                    fit: BoxFit.fitWidth)),
                            Wrap(children: <Widget>[
                              for (final MapEntry<String, bool> interest
                                  in _selected.entries)
                                _buildInterest(interest)
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
                                text: 'NEXT',
                                width: MediaQuery.of(context).size.width * 0.4,
                                onPressed: () {
                                  dispatch(LoginInterestsAction(_selected
                                      .entries
                                      .where(
                                          (MapEntry<String, bool> interest) =>
                                              interest.value)
                                      .map((MapEntry<String, bool> interest) =>
                                          interest.key)
                                      .toList()));
                                  dispatch(NavigateAction<AppState>.pushNamed(
                                      Register3Screen.id));
                                })
                          ]))
                    ])))
          ]));
    });
  }
}
