import 'package:business/app_state.dart';
import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/classes/event.dart';
import 'package:business/events/actions/events_get_action.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';

import 'package:expandable/expandable.dart';
import 'package:inclusive/widgets/cached_image.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:intl/intl.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class EventScreen extends StatelessWidget {
  EventScreen(this.event);

  final Event event;

  static const String id = 'EventScreen';

  Widget _buildEventInfo() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
              child: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                      margin: const EdgeInsets.all(5),
                      color: Colors.green,
                      child: Column(
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.all(5),
                              child: RichText(
                                  text: TextSpan(
                                      text: event.date.day.toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700)))),
                          Padding(
                              padding: const EdgeInsets.all(5),
                              child: RichText(
                                  text: TextSpan(
                                      text:
                                          DateFormat('MMM').format(event.date),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700))))
                        ],
                      ))),
              Expanded(
                  flex: 5,
                  child: Container(
                      child: RichText(
                          text: TextSpan(
                    text: event.name,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ))))
            ],
          )),
          Container(
              child: Row(
            children: <Widget>[
              Icon(Icons.location_on),
              Padding(
                padding: const EdgeInsets.all(5),
                child: RichText(
                    text: TextSpan(
                        text: 'awesome adress',
                        style: const TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)))
              )
            ],
          )),
          Container(
            child: Row(
              children: <Widget>[
                const Text('Hour-Date'),
                const Text('Lounges'),
                const Text('Liked'),
                const Text('Attended')
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                const Text('TAG PRIC'),
                const Text('TAG Info age')
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
        child: ExpandablePanel(
      header: Padding(
        padding: const EdgeInsets.all(10),
        child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'Event Description',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600))),
      ),
      expanded: Text(
        event.description,
        softWrap: true,
      ),
    ));
  }

  Widget _buildBanner() {
    return Container(
      child: Row(
        children: <Widget>[
          if (event.pic.isNotEmpty)
            Expanded(flex: 1, child: CachedImage(event.pic)),
          Expanded(
              flex: 1, child: Container(child: const Text('MAP GOES HERE')))
        ],
      ),
    );
  }

  Widget _buildLiveFeedSponsor() {
    return Container(
      child: Row(
        children: <Widget>[
          const Expanded(flex: 1, child: Text('Live Feed')),
          Expanded(
              flex: 3,
              child: Column(
                children: <Widget>[
                  const Text('Sponsored by le meilleur des sponsors'),
                  const Text(' www.sponsor.com '),
                  const Text('Twitter / Facebook / Etc.')
                ],
              ))
        ],
      ),
    );
  }

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
          child: Container(
        color: white,
        constraints: const BoxConstraints.expand(),
        child: Column(
          children: <Widget>[
            _buildEventInfo(),
            _buildBanner(),
            _buildDescription(),
            _buildLiveFeedSponsor(),
            Expanded(
                child: RefreshIndicator(
                    onRefresh: () => store.dispatchFuture(EventsGetAction()),
                    child: const Text('LIVE FEED GOES HERE'))),
          ],
        ),
      )

          /*       ListView(children: <Widget>[
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
      ]) */

          );
    });
  }
}
