import 'package:async_redux/async_redux.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:business/app_state.dart';
import 'package:business/login/actions/login_interests_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:outloud/register/register_3.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/button.dart';
import 'package:outloud/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class Register2Screen extends StatefulWidget {
  static const String id = 'Register2';

  @override
  _Register2ScreenState createState() => _Register2ScreenState();
}

class _Register2ScreenState extends State<Register2Screen> {
  List<String> _interests;

  final Map<String, bool> _selected = <String, bool>{};

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
                  AutoSizeText(interest.key.toUpperCase(),
                      style: const TextStyle(color: white)),
                  const Padding(
                      padding: EdgeInsets.only(left: 10.0),
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
                  AutoSizeText(interest.key.toUpperCase(),
                      style: const TextStyle(color: pink)),
                  const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Icon(Icons.radio_button_unchecked,
                          color: pink, size: 12.0))
                ])));
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<AppState>) dispatch,
        Widget child) {
      _interests = <String>[
        FlutterI18n.translate(context, 'INTERESTS.FOOD_AND_DRINK'),
        FlutterI18n.translate(context, 'INTERESTS.ART'),
        FlutterI18n.translate(context, 'INTERESTS.FASHION_AND_BEAUTY'),
        FlutterI18n.translate(context, 'INTERESTS.OUTDOORS_AND_ADVENTURE'),
        FlutterI18n.translate(context, 'INTERESTS.SPORT'),
        FlutterI18n.translate(context, 'INTERESTS.FITNESS'),
        FlutterI18n.translate(context, 'INTERESTS.TECH'),
        FlutterI18n.translate(context, 'INTERESTS.HEALTH_AND_WELLNESS'),
        FlutterI18n.translate(context, 'INTERESTS.SELF_GROWTH'),
        FlutterI18n.translate(context, 'INTERESTS.PHOTOGRAPHY'),
        FlutterI18n.translate(context, 'INTERESTS.WRITING'),
        FlutterI18n.translate(context, 'INTERESTS.CULTURE_AND_LANGUAGE'),
        FlutterI18n.translate(context, 'INTERESTS.MUSIC'),
        FlutterI18n.translate(context, 'INTERESTS.ACTIVISM'),
        FlutterI18n.translate(context, 'INTERESTS.FILM'),
        FlutterI18n.translate(context, 'INTERESTS.GAMING'),
        FlutterI18n.translate(context, 'INTERESTS.BELIEFS'),
        FlutterI18n.translate(context, 'INTERESTS.BOOKS'),
        FlutterI18n.translate(context, 'INTERESTS.DANCE'),
        FlutterI18n.translate(context, 'INTERESTS.PET'),
        FlutterI18n.translate(context, 'INTERESTS.CRAFT'),
      ];
      for (final String interest in _interests) {
        if (_selected[interest] == null) {
          _selected[interest] = false;
        }
      }
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
                        Expanded(child: Container(width: 0.0, height: 0.0)),
                        Expanded(
                            child: Image.asset('images/OL-draft2a.png',
                                width: 50.0, height: 50.0)),
                        Expanded(
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                    onTap: () => dispatch(
                                        NavigateAction<AppState>.pushNamed(
                                            Register3Screen.id)),
                                    child: AutoSizeText(
                                        FlutterI18n.translate(
                                            context, 'REGISTER_2.SKIP'),
                                        style: const TextStyle(color: grey)))))
                      ]),
                      Expanded(
                          flex: 7,
                          child: ListView(children: <Widget>[
                            AutoSizeText(
                                FlutterI18n.translate(
                                    context, 'REGISTER_2.TITLE'),
                                style: const TextStyle(fontSize: 20.0)),
                            AutoSizeText(
                                FlutterI18n.translate(
                                    context, 'REGISTER_2.SUBTITLE'),
                                style: const TextStyle(color: grey)),
                            Image.asset('images/illustrationInterests.png',
                                width: MediaQuery.of(context).size.width * 0.9,
                                height:
                                    MediaQuery.of(context).size.width * 0.65,
                                fit: BoxFit.fitWidth),
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
                                text: FlutterI18n.translate(
                                    context, 'REGISTER_2.BACK'),
                                width: MediaQuery.of(context).size.width * 0.4,
                                onPressed: () =>
                                    dispatch(NavigateAction<AppState>.pop())),
                            Button(
                                text: FlutterI18n.translate(
                                    context, 'REGISTER_2.NEXT'),
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
