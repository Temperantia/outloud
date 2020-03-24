import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/events/find_events_screen.dart';
import 'package:inclusive/events/my_events_screen.dart';
import 'package:inclusive/widgets/loading.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class EventsWidget extends StatefulWidget {
  @override
  _EventsWidgetState createState() => _EventsWidgetState();
}

class _EventsWidgetState extends State<EventsWidget>
    with AutomaticKeepAliveClientMixin<EventsWidget> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<dynamic>) dispatch,
        Widget child) {
      if (state.eventsState.events == null ||
          state.userState.events == null ||
          state.userState.user.events == null ||
          state.userState.lounges == null) {
        return Loading();
      }
      return DefaultTabController(
          length: 2,
          child: Column(children: <Widget>[
            const Expanded(
                child:
                    TabBar(indicatorColor: Colors.transparent, tabs: <Widget>[
              Tab(text: 'MY EVENTS'),
              Tab(text: 'FIND EVENTS'),
            ])),
            Expanded(
                flex: 8,
                child: Container(
                    child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: <Widget>[
                      MyEventsScreen(),
                      FindEventsScreen()
                    ]))),
          ]));
    });
  }
}
