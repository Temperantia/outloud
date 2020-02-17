import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/events/actions/events_get_action.dart';
import 'package:business/events/actions/events_select_action.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/events/event_screen.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/button.dart';
import 'package:inclusive/widgets/loading.dart';
import 'package:intl/intl.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class EventsWidget extends StatefulWidget {
  @override
  _EventsWidgetState createState() => _EventsWidgetState();
}

class _EventsWidgetState extends State<EventsWidget>
    with AutomaticKeepAliveClientMixin<EventsWidget> {
  @override
  bool get wantKeepAlive => true;

  Widget _buildEvent(
      Event event,
      void Function(redux.ReduxAction<AppState>) dispatch,
      Future<void> Function(redux.ReduxAction<AppState>) dispatchFuture) {
    final String date = DateFormat('dd.MM').format(event.date);
    final String time = DateFormat('Hm').format(event.date);
    return Column(children: <Widget>[
      const Divider(
        thickness: 3.0,
      ),
      GestureDetector(
          onTap: () async {
            await dispatchFuture(EventsSelectAction(event));
            dispatch(redux.NavigateAction<AppState>.pushNamed(EventScreen.id));
          },
          child: Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                if (event.pic.isNotEmpty)
                  Flexible(
                      child: CachedNetworkImage(
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
                              Text(event.name, style: textStyleListItemTitle),
                              Text(event.description,
                                  maxLines: 3, overflow: TextOverflow.ellipsis),
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
                              Text(date,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text(time,
                                  style: const TextStyle(
                                      color: grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0))
                            ]))),
              ]))),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<dynamic>) dispatch,
        Widget child) {
      final List<Event> events = state.eventsState.events;
      if (events == null) {
        return Loading();
      }

      return RefreshIndicator(
          onRefresh: () => store.dispatchFuture(EventsGetAction()),
          child: ListView(children: <Widget>[
            // TODO(robin): Google map here above the list of events
            SizedBox(
                height: 300.0,
                child: Container(
                    decoration: const BoxDecoration(color: white),
                    child: const Center(child: Text('google map here')))),
            Container(
              decoration: const BoxDecoration(color: white),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(children: const <Widget>[
                      Text('Events', style: textStyleTitle),
                      Spacer(),
                      Flexible(flex: 6, child: Button(text: 'Create')),
                      Spacer(),
                      Flexible(flex: 6, child: Button(text: 'Discover')),
                    ]),
                    Column(children: <Widget>[
                      for (final Event event in events)
                        _buildEvent(event, dispatch, store.dispatchFuture)
                    ]),
                  ]),
            ),
          ]));
    });
  }
}
