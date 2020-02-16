import 'package:business/app_state.dart';
import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/classes/event.dart';
import 'package:business/events/actions/event_groups_get_action.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/events/event_groups_screen.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/button.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:intl/intl.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class EventScreen extends StatelessWidget {
  static const String id = 'EventScreen';
  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<dynamic>) dispatch,
        Widget child) {
      final Event event = state.eventsState.event;
      final String date = DateFormat('ddMMM').format(event.date);
      final String time = DateFormat('Hm').format(event.date);
      return View(
          child: Column(children: <Widget>[
        Expanded(
            child: Row(children: <Widget>[
          Expanded(
              child: event.pic.isEmpty
                  ? Image.asset(
                      'images/default-user-profile-image-png-7.png',
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      fit: BoxFit.fitWidth,
                      imageUrl: event.pic,
                      placeholder: (BuildContext context, String url) =>
                          const CircularProgressIndicator(),
                      errorWidget:
                          (BuildContext context, String url, Object error) =>
                              Icon(Icons.error),
                    )),
        ])),
        Expanded(
            flex: 2,
            child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(gradient: gradientTopDown),
                child: ListView(children: <Widget>[
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                  // TODO(robin): Google map here centered on the event location
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: SizedBox(
                          height: 300.0,
                          child: Container(
                              decoration: const BoxDecoration(color: white),
                              child: const Center(
                                  child: Text('google map here'))))),
                  Row(children: <Widget>[
                    const Spacer(flex: 1),
                    const Flexible(
                        flex: 6, child: Button(text: 'Register me', alt: true)),
                    const Spacer(flex: 2),
                    Flexible(
                        flex: 6,
                        child: Button(
                            text: 'View all subgroups',
                            alt: true,
                            onPressed: () async {
                              await store.dispatchFuture(EventGroupsGetAction(
                                  state.eventsState.event.id));
                              dispatch(redux.NavigateAction<AppState>.pushNamed(
                                  EventGroupsScreen.id));
                            })),
                    const Spacer(flex: 1),
                  ]),
                ]))),
      ]));
    });
  }
}
