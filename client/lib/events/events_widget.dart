import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:outloud/events/find_events_screen.dart';
import 'package:outloud/events/my_events_screen.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/loading.dart';
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
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
      if ( //state.eventsState.events == null ||
          state.userState.events == null ||
              state.userState.user.events == null ||
              state.userState.lounges == null) {
        return Loading();
      }

      _tabController.animateTo(state.eventsTabIndex);

      return DefaultTabController(
          length: 2,
          child: Column(children: <Widget>[
            Expanded(
                child: TabBar(
                    labelColor: white,
                    indicatorColor: Colors.transparent,
                    controller: _tabController,
                    tabs: <Widget>[
                  Tab(text: FlutterI18n.translate(context, 'EVENTS.MY_EVENTS')),
                  Tab(
                      text:
                          FlutterI18n.translate(context, 'EVENTS.FIND_EVENTS'))
                ])),
            Expanded(
                flex: 8,
                child: Container(
                    child: TabBarView(
                      controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: <Widget>[
                      MyEventsScreen(),
                      FindEventsScreen()
                    ]))),
          ]));
    });
  }
}
