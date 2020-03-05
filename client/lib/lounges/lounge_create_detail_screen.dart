import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/lounge_visibility.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/lounges/lounge_create_meetup_screen.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/button.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class LoungeCreateDetailScreen extends StatefulWidget {
  static const String id = 'LoungeCreateDetailScreen';

  @override
  _LoungeCreateDetailScreenState createState() =>
      _LoungeCreateDetailScreenState();
}

class _LoungeCreateDetailScreenState extends State<LoungeCreateDetailScreen> {
  LoungeVisibility _visibility = LoungeVisibility.Public;
  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<AppState>) dispatch,
        Widget child) {
      var loungeCreation = state.loungesState.loungeCreation;
      return View(
          title: 'CREATE LOUNGE',
          onBack: () => Navigator.popUntil(
              context, (Route<dynamic> route) => route.isFirst),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                      color: white,
                      child: ListView(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('LOUNGE VISIBILITY'),
                              Row(
                                children: <Widget>[
                                  Radio(
                                    activeColor: primary(state.theme),
                                    groupValue: _visibility,
                                    value: LoungeVisibility.Public,
                                    onChanged: (LoungeVisibility visibility) =>
                                        _visibility = visibility,
                                  ),
                                  Text('PUBLIC',
                                      style: textStyleCardTitle(state.theme))
                                ],
                              )
                            ],
                          )
                        ],
                      ))),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Button(
                    text: 'BACK',
                    onPressed: () {
                      dispatch(NavigateAction<AppState>.pop());
                    }),
                Button(
                    text: 'NEXT',
                    onPressed: () {
                      dispatch(NavigateAction<AppState>.pushNamed(
                        LoungeCreateMeetupScreen.id,
                      ));
                    }),
              ]),
            ],
          ));
    });
  }
}
