import 'dart:async';

import 'package:async_redux/async_redux.dart'
    show ReduxAction, NavigateAction, Store;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/user_event_state.dart';
import 'package:business/events/actions/events_get_action.dart';
import 'package:date_utils/date_utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'package:outloud/events/event_screen.dart';
import 'package:outloud/theme.dart';
import 'package:intl/intl.dart';
import 'package:outloud/widgets/content_list.dart';
import 'package:outloud/widgets/content_list_item.dart';
import 'package:outloud/widgets/event_image.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class FindEventsScreen extends StatefulWidget {
  @override
  _FindEventsScreen createState() => _FindEventsScreen();
}

class _FindEventsScreen extends State<FindEventsScreen>
    with
        AutomaticKeepAliveClientMixin<FindEventsScreen>,
        TickerProviderStateMixin {
/*   final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final Map<String, Marker> _markers = <String, Marker>{}; */
  // final GlobalKey _interestFilterKey = GlobalKey();
  //final LayerLink _interestLink = LayerLink();
  //final List<CheckBoxContent> _interests = <CheckBoxContent>[];

/*   CameraPosition _initialMapLocation =
      const CameraPosition(target: LatLng(48.85902056, 2.34637398), zoom: 14); */

/*   int _flexFactorMap = 1;
  int _flexFactorListEvent = 5; */
  //OverlayEntry _interestsCheckBox;
  // bool _checkBoxDisplayed = false;
  //String _distanceValue;
  void Function(ReduxAction<AppState>) _dispatch;
  Future<void> Function(ReduxAction<AppState>) _dispatchFuture;
  String _timeValue;
  List<Event> _events;
  List<Event> _eventsDisplayed;

  @override
  bool get wantKeepAlive => true;

/*   @override
  void initState() {
    super.initState();
     _getPosition();
  } */

/*   void _shrinkMap() {
    setState(() {
      _flexFactorListEvent = 5;
      _flexFactorMap = 1;
    });
  } */

  /*  void _growMap() {
    setState(() {
      _flexFactorListEvent = 2;
      _flexFactorMap = 4;
    });
  } */

/*   Future<int> _getPosition() async {
    final Position position = await geoLocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    if (position != null) {
      _initialMapLocation = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 14);
      return 0;
    }
    return 1;
  } */

  void _refreshEvents() {
    final DateTime now = DateTime.now();

    _eventsDisplayed = _events.where((Event event) {
      final DateTime eventDateStart = event.dateStart;
      /*   if (_distanceValue == FlutterI18n.translate(context, 'FIND_EVENTS.5KM')) {
        if (event.distance == null || event.distance > 5.0) {
          return false;
        }
      } else if (_distanceValue ==
          FlutterI18n.translate(context, 'FIND_EVENTS.10KM')) {
        if (event.distance == null || event.distance > 10.0) {
          return false;
        }
      } else if (_distanceValue ==
          FlutterI18n.translate(context, 'FIND_EVENTS.50KM')) {
        if (event.distance == null || event.distance > 50.0) {
          return false;
        }
      } else if (_distanceValue ==
          FlutterI18n.translate(context, 'FIND_EVENTS.100KM')) {
        if (event.distance == null || event.distance > 100.0) {
          return false;
        }
      }
 */
      if (_timeValue ==
          FlutterI18n.translate(context, 'FIND_EVENTS.THIS_WEEK')) {
        if (!Utils.isSameWeek(now, eventDateStart) ||
            eventDateStart.weekday > 5) {
          return false;
        }
      } else if (_timeValue ==
          FlutterI18n.translate(context, 'FIND_EVENTS.THIS_WEEKEND')) {
        if (!Utils.isSameWeek(now, eventDateStart) ||
            eventDateStart.weekday < 5) {
          return false;
        }
      } else if (_timeValue ==
          FlutterI18n.translate(context, 'FIND_EVENTS.NEXT_WEEK')) {
        if (!Utils.isSameWeek(Utils.nextWeek(now), eventDateStart)) {
          return false;
        }
      } else if (_timeValue ==
          FlutterI18n.translate(context, 'FIND_EVENTS.THIS_MONTH')) {
        if (now.year != eventDateStart.year ||
            now.month != eventDateStart.month) {
          return false;
        }
      } else if (_timeValue ==
          FlutterI18n.translate(context, 'FIND_EVENTS.NEXT_MONTH')) {
        if (now.year != eventDateStart.year ||
            Utils.nextMonth(now).month != eventDateStart.month) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  /* Widget _buildMapView() {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(color: white),
        child: GoogleMap(
            onTap: (_) => _growMap(),
            onCameraMoveStarted: () => _growMap(),
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer())
            },
            initialCameraPosition: _initialMapLocation,
            markers: _markers.values.toSet(),
            onMapCreated: (GoogleMapController controller) {
              if (!_controller.isCompleted) {
                _controller.complete(controller);
              }
            }));
  }
 */
  Widget _buildFilters() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          /*  CompositedTransformTarget(
                  link: _interestLink,
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: black, width: 1),
                      ),
                      key: _interestFilterKey,
                      child: FlatButton(
                          child: Row(
                            children: const <Widget>[
                              AutoSizeText('Interests'),
                              Icon(Icons.arrow_drop_down)
                            ],
                          ),
                          onPressed: () {
                            if (_checkBoxDisplayed) {
                              _interestsCheckBox.remove();
                              setState(() {
                                _checkBoxDisplayed = false;
                              });
                            } else {
                              _shrinkMap();
                              setState(() {
                                _interestsCheckBox = _createInterestsCheckBox();
                                _checkBoxDisplayed = true;
                              });
                              Overlay.of(context).insert(_interestsCheckBox);
                            }
                          }))), */
          /*  Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(border: Border.all(color: black)),
              child: DropdownButton<String>(
                  underline: Container(width: 0.0, height: 0.0),
                  value: _distanceValue,
                  items: <String>[
                    FlutterI18n.translate(context, 'FIND_EVENTS.ANY_DISTANCE'),
                    FlutterI18n.translate(context, 'FIND_EVENTS.5KM'),
                    FlutterI18n.translate(context, 'FIND_EVENTS.10KM'),
                    FlutterI18n.translate(context, 'FIND_EVENTS.50KM'),
                    FlutterI18n.translate(context, 'FIND_EVENTS.100KM'),
                  ]
                      .map<DropdownMenuItem<String>>((String value) =>
                          DropdownMenuItem<String>(
                              value: value, child: AutoSizeText(value)))
                      .toList(),
                  onChanged: (String newValue) => setState(() {
                        _distanceValue = newValue;
                        _refreshEvents();
                      }))), */
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(border: Border.all(color: black)),
              child: DropdownButton<String>(
                  underline: Container(width: 0.0, height: 0.0),
                  value: _timeValue,
                  items: <String>[
                    FlutterI18n.translate(context, 'FIND_EVENTS.ANY_TIME'),
                    FlutterI18n.translate(context, 'FIND_EVENTS.THIS_WEEK'),
                    FlutterI18n.translate(context, 'FIND_EVENTS.THIS_WEEKEND'),
                    FlutterI18n.translate(context, 'FIND_EVENTS.NEXT_WEEK'),
                    FlutterI18n.translate(context, 'FIND_EVENTS.THIS_MONTH'),
                    FlutterI18n.translate(context, 'FIND_EVENTS.NEXT_MONTH'),
                  ]
                      .map<DropdownMenuItem<String>>((String value) =>
                          DropdownMenuItem<String>(
                              value: value, child: AutoSizeText(value)))
                      .toList(),
                  onChanged: (String newValue) => setState(() {
                        _timeValue = newValue;
                        _refreshEvents();
                      })))
        ]);
  }

/*   OverlayEntry _createInterestsCheckBox() {
    final RenderBox renderBox =
        _interestFilterKey.currentContext.findRenderObject() as RenderBox;
    final Size sizeInterests = renderBox.size;
    final Offset positionInterests = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (BuildContext context) => Positioned(
            left: positionInterests.dx,
            height: 300,
            width: 200,
            child: CompositedTransformFollower(
                link: _interestLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, sizeInterests.height + 5),
                child: Material(
                    elevation: 4.0,
                    child: MyMultiCheckBoxesContent(checkboxes: _interests)))));
  } */

  Widget _buildEvent(Event event, Map<String, UserEventState> userEventStates) {
    String date = '';
    String month = '';
    String time = '';
    String timeEnd = '';

    if (event.dateStart != null) {
      date = DateFormat('dd').format(event.dateStart);
      month = DateFormat('MMM').format(event.dateStart);
      time = DateFormat('Hm').format(event.dateStart);

      if (event.dateEnd != null) {
        if (!Utils.isSameDay(event.dateStart, event.dateEnd)) {
          date += ' - ${DateFormat('dd').format(event.dateEnd)}';
        }
        if (event.dateStart.month != event.dateEnd.month) {
          month += ' - ${DateFormat('MMM').format(event.dateEnd)}';
        }
        timeEnd = DateFormat('Hm').format(event.dateEnd);
      }
    }

    final UserEventState state = userEventStates[event.id];
    return ContentListItem(
        onTap: () => _dispatch(NavigateAction<AppState>.pushNamed(
            EventScreen.id,
            arguments: event)),
        leading: Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
                color: pink, borderRadius: BorderRadius.circular(5.0)),
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AutoSizeText(date,
                      style: const TextStyle(
                          color: white, fontWeight: FontWeight.bold)),
                  AutoSizeText(month,
                      style: const TextStyle(
                          color: white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0))
                ])),
        title: AutoSizeText(event.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AutoSizeText('$time - $timeEnd',
                    style: const TextStyle(color: orange)),
                /*  if (event.distance != null)
                                      AutoSizeText(
                                          '${event.distance.toStringAsFixed(1)}${FlutterI18n.translate(context, 'FIND_EVENTS.AWAY')}',
                                          style: const TextStyle(color: orange)) */
              ]),
          Wrap(children: <Widget>[
            for (String interest in event.interests)
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: pink)),
                  child: AutoSizeText(interest.toUpperCase(),
                      style: const TextStyle(
                          color: pink, fontWeight: FontWeight.bold)))
          ])
        ]),
        trailing: EventImage(
            image: event.pic, size: 50.0, hasOverlay: false, state: state));
  }

  Widget _buildFindEvents(Map<String, UserEventState> userEventStates) {
    return Column(children: <Widget>[
      /*  Flexible(
          flex: _flexFactorMap,
          child: GestureDetector(
              onTap: () {
                _growMap();
              },
              child: _buildMapView())), */
      /*  Container(
          child: GestureDetector(
              onTap: () {
                _shrinkMap();
              },
              child: _buildFilters())),
      Expanded(
          flex: _flexFactorListEvent,
          child: GestureDetector(
              onTap: () {
                _shrinkMap();
              },
              onVerticalDragDown: (_) {
                _shrinkMap();
              },
              onHorizontalDragDown: (_) {
                _shrinkMap();
              },
              onTapDown: (_) {
                _shrinkMap();
              },
              child:  */
      _buildFilters(),
      Expanded(
          child: ContentList<Event>(
              items: _eventsDisplayed,
              builder: (Event event) => _buildEvent(event, userEventStates),
              onRefresh: () => _dispatchFuture(EventsGetAction())))
      /*  Expanded(
          flex: 1,
          child: Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                Button(
                    text: 'CREATE EVENT',
                    width: 200,
                    icon: Icon(Icons.add),
                    onPressed: () => dispatch(
                        redux.NavigateAction<AppState>.pushNamed(
                            EventCreateScreen.id))),
              ]))) */
    ]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<AppState>) dispatch,
        Widget child) {
      // _markers.clear();
      _dispatch = dispatch;
      _dispatchFuture = store.dispatchFuture;
      _events = state.eventsState.events;
      if (_events == null) {
        return const CircularProgressIndicator();
      }

      /*   _distanceValue ??=
          FlutterI18n.translate(context, 'FIND_EVENTS.ANY_DISTANCE'); */
      _timeValue ??= FlutterI18n.translate(context, 'FIND_EVENTS.ANY_TIME');
      _refreshEvents();

      /*  for (final Event event in _eventsDisplayed) {
        if (event.location != null) {
          _markers[event.id] = Marker(
              markerId: MarkerId(event.id),
              position:
                  LatLng(event.location.latitude, event.location.longitude),
              infoWindow: InfoWindow(title: event.name));
        }
      } */
      return _buildFindEvents(state.userState.user.events);
    });
  }
}
