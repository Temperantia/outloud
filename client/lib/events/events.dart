import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/events/actions/events_get_action.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/button.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class Events extends StatelessWidget {
  Widget _buildEvent(Event event) {
    return Column(children: <Widget>[
      const Divider(
        thickness: 3.0,
      ),
      Container(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
            Flexible(
                child: event.pic.isEmpty
                    ? Image.asset('images/default-user-profile-image-png-7.png')
                    : CachedNetworkImage(
                        imageUrl: event.pic,
                        placeholder: (BuildContext context, String url) =>
                            const CircularProgressIndicator(),
                        errorWidget:
                            (BuildContext context, String url, Object error) =>
                                Icon(Icons.error),
                      )),
            Flexible(
                flex: 2,
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(event.name,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(event.description,
                              maxLines: 3, overflow: TextOverflow.ellipsis),
                          Button(
                              text: Text('view',
                                  style: TextStyle(
                                      color: white,
                                      fontWeight: FontWeight.bold))),
                        ]))),
            Flexible(
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: grey, width: 2.0),
                        borderRadius: BorderRadius.circular(5.0)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 5.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text('25.02',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('20:00',
                              style: TextStyle(
                                  color: grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.0))
                        ])))
          ])),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<dynamic>) dispatch,
        Widget child) {
      final List<Event> events = state.eventsState.events;
      return RefreshIndicator(
          onRefresh: () => store.dispatchFuture(EventsGetAction()),
          child: Column(children: <Widget>[
            // TODO(robin): Google map here above the list of events
            Flexible(flex: 1, child: Container()),
            Flexible(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(color: white),
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Events',
                            style: TextStyle(
                                color: pink,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold)),
                        Row(children: <Widget>[
                          const Spacer(flex: 1),
                          Flexible(
                              flex: 6,
                              child: Button(
                                  text: Text('Create',
                                      style: TextStyle(
                                          color: white,
                                          fontWeight: FontWeight.bold)))),
                          const Spacer(flex: 2),
                          Flexible(
                              flex: 6,
                              child: Button(
                                  text: Text('Discover',
                                      style: TextStyle(
                                          color: white,
                                          fontWeight: FontWeight.bold)))),
                          const Spacer(flex: 1),
                        ]),
                        Flexible(
                            child: ListView.builder(
                                itemCount: events.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        _buildEvent(events[index]))),
                      ]),
                )),
          ]));
    });
  }
}
