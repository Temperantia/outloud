import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/lounges/actions/lounge_create_action.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/lounges/lounge_create_detail_screen.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/button.dart';
import 'package:inclusive/widgets/cached_image.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class LoungeCreateScreen extends StatefulWidget {
  static const String id = 'LoungeCreateScreen';

  @override
  _LoungeCreateScreenState createState() => _LoungeCreateScreenState();
}

class _LoungeCreateScreenState extends State<LoungeCreateScreen> {
  Event _selected;

  Widget _buildUserEvent(Event event, ThemeStyle themeStyle) {
    return GestureDetector(
        onTap: () => setState(() => _selected = event),
        child: Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            decoration: BoxDecoration(
                color: _selected?.id == event.id
                    ? primary(themeStyle).withOpacity(0.3)
                    : null,
                borderRadius: BorderRadius.circular(5.0)),
            child: Row(children: <Widget>[
              if (event.pic != null)
                Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: CachedImage(
                      event.pic,
                      width: 40.0,
                      height: 40.0,
                      borderRadius: 5.0,
                    )),
              Expanded(
                  child: Text(event.name,
                      style: const TextStyle(
                          color: orange, fontWeight: FontWeight.bold))),
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<AppState>) dispatch,
        Widget child) {
      final List<Event> userEvents = state.userState.events;
      return View(
          title: 'CREATE LOUNGE',
          onBack: () => Navigator.popUntil(
              context, (Route<dynamic> route) => route.isFirst),
          backIcon: Icons.close,
          child: Column(children: <Widget>[
            Expanded(
                flex: 6,
                child: Container(
                    color: white,
                    padding: const EdgeInsets.all(20.0),
                    child: Column(children: <Widget>[
                      Row(children: <Widget>[
                        Container(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text('CHOOSE AN EVENT FOR THIS LOUNGE',
                                style: TextStyle(fontWeight: FontWeight.w900)))
                      ]),
                      Expanded(
                          child: ListView.builder(
                        itemCount: userEvents.length,
                        itemBuilder: (BuildContext context, int index) =>
                            _buildUserEvent(userEvents[index], state.theme),
                      )),
                    ]))),
            if (_selected != null)
              Expanded(
                  child: Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                    Button(
                        text: 'NEXT',
                        width: 150.0,
                        onPressed: () {
                          dispatch(LoungeCreateAction(
                            _selected.id,
                          ));
                          dispatch(redux.NavigateAction<AppState>.pushNamed(
                              LoungeCreateDetailScreen.id));
                        }),
                  ]))),
          ]));
    });
  }
}
