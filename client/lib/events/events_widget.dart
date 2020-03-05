import 'dart:async';

import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/events/actions/events_get_action.dart';
import 'package:business/events/actions/events_select_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inclusive/events/event_create_screen.dart';
import 'package:inclusive/events/event_screen.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/button.dart';
import 'package:inclusive/widgets/cached_image.dart';
import 'package:inclusive/widgets/loading.dart';
import 'package:intl/intl.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class EventsWidget extends StatefulWidget {
  @override
  _EventsWidgetState createState() => _EventsWidgetState();
}

class _EventsWidgetState extends State<EventsWidget>
    with AutomaticKeepAliveClientMixin<EventsWidget> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final Map<String, Marker> _markers = <String, Marker>{};
  final ScrollController _scrollController = ScrollController();
  double _googleMapSize = 100.0;
  CameraPosition _intialMapLocation =
      const CameraPosition(target: LatLng(48.85902056, 2.34637398), zoom: 14);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _googleMapSize = 100.0;
      });
    });
    getPosition();
  }

  Future<int> getPosition() async {
    final Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    if (position != null) {
      _intialMapLocation = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 14);
      return 0;
    }
    return 1;
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildMap() {
    return Container(
        constraints: BoxConstraints.expand(
          height: Theme.of(context).textTheme.display1.fontSize * 1.1 +
              _googleMapSize,
        ),
        decoration: const BoxDecoration(color: white),
        child: GoogleMap(
            onTap: (LatLng latlang) {
              setState(() {
                _googleMapSize = 400.0;
              });
            },
            onCameraMoveStarted: () {
              setState(() {
                _googleMapSize = 400.0;
              });
            },
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              )
            },
            initialCameraPosition: _intialMapLocation,
            markers: _markers.values.toSet(),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            }));
  }

  Widget _buildEvents(
      List<Event> events,
      ThemeStyle themeStyle,
      void Function(redux.ReduxAction<AppState>) dispatch,
      Future<void> Function(redux.ReduxAction<AppState>) dispatchFuture) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) => Container(
        decoration: const BoxDecoration(color: white),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildEvent(events[index], dispatch, dispatchFuture, themeStyle)
            ]),
      ),
      controller: _scrollController,
    );
  }

  Widget _buildEvent(
      Event event,
      void Function(redux.ReduxAction<AppState>) dispatch,
      Future<void> Function(redux.ReduxAction<AppState>) dispatchFuture,
      ThemeStyle theme) {
    final String date =
        event.date == null ? null : DateFormat('dd.MM').format(event.date);
    final String time =
        event.date == null ? null : DateFormat('Hm').format(event.date);
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
                  Flexible(child: CachedImage(event.pic)),
                Flexible(
                    flex: 2,
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(event.name,
                                  style: textStyleCardTitle(theme)),
                              Text(event.description,
                                  maxLines: 3, overflow: TextOverflow.ellipsis),
                            ]))),
                if (date != null && time != null)
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
      final List<Event> userEvents = state.userState.events;
      final ThemeStyle themeStyle = state.theme;
      if (events == null || userEvents == null) {
        return Loading();
      }
      _markers.clear();
      for (final Event event in events) {
        if (event.location != null) {
          _markers[event.id] = Marker(
              markerId: MarkerId(event.id),
              position:
                  LatLng(event.location.latitude, event.location.longitude),
              infoWindow: InfoWindow(title: event.name));
        }
      }
      return DefaultTabController(
          length: 2,
          child: Column(
            children: <Widget>[
              Expanded(
                  child: TabBar(
                labelStyle: textStyleButton,
                tabs: <Widget>[
                  Tab(text: 'MY EVENTS'),
                  Tab(text: 'FIND EVENTS'),
                ],
              )),
              Expanded(
                  flex: 6,
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      _buildEvents(userEvents, themeStyle, dispatch,
                          store.dispatchFuture),
                      RefreshIndicator(
                        onRefresh: () =>
                            store.dispatchFuture(EventsGetAction()),
                        child: _buildEvents(
                            events, themeStyle, dispatch, store.dispatchFuture),
                      ),
                    ],
                  ))
            ],
          ));
    });
  }
}
