import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/lounges/actions/lounge_create_action.dart';
import 'package:business/models/events.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/lounges/lounge_create_detail_screen.dart';
import 'package:inclusive/lounges/lounge_create_meetup_screen.dart';
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
            color: _selected?.id == event.id
                ? primary(themeStyle).withOpacity(0.3)
                : null,
            child: Row(children: [
              if (event.pic != null)
                CachedImage(event.pic, width: 50.0, height: 50.0),
              Expanded(child: Text(event.name))
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
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                      color: white,
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Text('CHOOSE AN EVENT FOR THIS LOUNGE'),
                          Expanded(
                              child: ListView.builder(
                            itemCount: userEvents.length,
                            itemBuilder: (context, index) =>
                                _buildUserEvent(userEvents[index], state.theme),
                          ))
                        ],
                      ))),
              if (_selected != null)
                Expanded(
                  child: Button(
                      text: 'NEXT',
                      onPressed: () {
                        dispatch(LoungeCreateAction(
                            Lounge(eventRef: getEventReference(_selected.id))));
                        dispatch(redux.NavigateAction<AppState>.pushNamed(
                            LoungeCreateDetailScreen.id));
                      }),
                )
            ],
          ));
    });
  }
}
