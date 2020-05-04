import 'package:flutter/material.dart'
    show
        AutomaticKeepAliveClientMixin,
        BuildContext,
        NeverScrollableScrollPhysics,
        SingleTickerProviderStateMixin,
        State,
        StatefulWidget,
        TabBarView,
        Widget;
import 'package:outloud/events/find_events_screen.dart' show FindEventsScreen;
import 'package:outloud/events/my_events_screen.dart' show MyEventsScreen;

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
  Widget build(BuildContext context) {
    super.build(context);

    return TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[FindEventsScreen(), MyEventsScreen()]);
  }
}
