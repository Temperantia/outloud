import 'dart:async';

import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/models/events.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/cached_image.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class EventAttendingScreen extends StatefulWidget {
  const EventAttendingScreen(this.event);
  final Event event;

  static const String id = 'EventAttendingScreen';

  @override
  _EventAttendingScreenState createState() => _EventAttendingScreenState();
}

class _EventAttendingScreenState extends State<EventAttendingScreen> {
  Event _event;
  StreamSubscription<Event> _eventSub;

  @override
  void initState() {
    super.initState();
    _event = widget.event;
    _eventSub = streamEvent(widget.event.id)
        .listen((Event event) => setState(() => _event = event));
  }

  @override
  void dispose() {
    _eventSub.cancel();
    super.dispose();
  }

  Widget _buildHeader() {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            Text('FOR THE EVENT',
                style: TextStyle(
                    color: black, fontSize: 13, fontWeight: FontWeight.w500)),
          ]),
          Container(
              child: Row(children: <Widget>[
            Flexible(
                child: CachedImage(_event.pic,
                    width: 30.0,
                    height: 30.0,
                    borderRadius: BorderRadius.circular(5.0),
                    imageType: ImageType.Event)),
            Expanded(
                flex: 8,
                child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(_event.name,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                            color: orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)))),
          ])),
        ]));
  }

  Widget _buildList() {
    print(_event.members);
    return Column(children: <Widget>[Text(_event.memberIds.length.toString())]);
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<AppState>) dispatch,
        Widget child) {
      return View(
          child: Column(children: <Widget>[
        _buildHeader(),
        const Divider(),
        _buildList()
      ]));
    });
  }
}
