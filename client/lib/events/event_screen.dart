import 'package:business/app_state.dart';
import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/classes/event.dart';
import 'package:business/events/actions/event_register_action.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/button.dart';
import 'package:inclusive/widgets/cached_image.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:intl/intl.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class EventScreen extends StatelessWidget {
  const EventScreen(this.event);

  final Event event;

  static const String id = 'EventScreen';

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<dynamic>) dispatch,
        Widget child) {
      final String date = DateFormat('ddMMM').format(event.date);
      final String time = DateFormat('Hm').format(event.date);

      return View(
          child: ListView(children: <Widget>[
        Row(children: <Widget>[
          if (event.pic.isNotEmpty) Expanded(child: CachedImage(event.pic)),
        ]),
        Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(color: primary(state.theme)),
            child: Column(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            flex: 3,
                            child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(event.name,
                                        style: textStyleCardTitleAlt),
                                    Text(event.description,
                                        style: textStyleCardDescription),
                                  ],
                                ))),
                        Expanded(
                            child: Card(
                                color: white,
                                child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: Column(children: <Widget>[
                                      Text(date,
                                          style: const TextStyle(
                                              color: pink,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold)),
                                      Text(time,
                                          style: const TextStyle(
                                              color: pink,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold)),
                                    ])))),
                      ])),
              const Button(text: 'See map', width: 200.0),
              if (state.userState.user.isAttendingEvent(event.id))
                const Button(text: 'Registered', width: 200.0)
              else
                Button(
                    text: 'Register me',
                    width: 200.0,
                    onPressed: () {
                      dispatch(EventRegisterAction(event.id));
                    }),
            ])),
      ]));
    });
  }
}
