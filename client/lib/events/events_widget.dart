import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:flutter/material.dart';
import 'package:outloud/events/find_events_screen.dart';
import 'package:outloud/events/my_events_screen.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class EventsWidget extends StatefulWidget {
  @override
  _EventsWidgetState createState() => _EventsWidgetState();
}

class _EventsWidgetState extends State<EventsWidget>
    with
        AutomaticKeepAliveClientMixin<EventsWidget>,
        SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<dynamic>) dispatch,
        Widget child) {
      return TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            FindEventsScreen(),
            MyEventsScreen(),
          ]);
    });
  }
}
