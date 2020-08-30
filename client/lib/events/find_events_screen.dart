import 'dart:async';

import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/user_event_state.dart';
import 'package:business/events/actions/events_get_action.dart';
import 'package:date_utils/date_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outloud/events/event_screen.dart';
import 'package:outloud/functions/loader_animation.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/cached_image.dart';
//import 'package:outloud/widgets/multiselect_dropdown.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class FindEventsScreen extends StatefulWidget {
  @override
  _FindEventsScreen createState() => _FindEventsScreen();
}

class _FindEventsScreen extends State<FindEventsScreen>
    with
        AutomaticKeepAliveClientMixin<FindEventsScreen>,
        TickerProviderStateMixin {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final Map<String, Marker> _markers = <String, Marker>{};
  // final GlobalKey _interestFilterKey = GlobalKey();
  //final LayerLink _interestLink = LayerLink();
  //final List<CheckBoxContent> _interests = <CheckBoxContent>[];

  CameraPosition _initialMapLocation =
      const CameraPosition(target: LatLng(48.85902056, 2.34637398), zoom: 14);

  int _flexFactorMap = 1;
  int _flexFactorListEvent = 5;
  //OverlayEntry _interestsCheckBox;
  // bool _checkBoxDisplayed = false;
  String _distanceValue;
  String _timeValue;
  List<Event> _events;
  List<Event> _eventsDisplayed;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getPosition();
  }

  void _shrinkMap() {
    setState(() {
      _flexFactorListEvent = 5;
      _flexFactorMap = 1;
    });
  }

  void _growMap() {
    setState(() {
      _flexFactorListEvent = 2;
      _flexFactorMap = 4;
    });
  }

  Future<int> _getPosition() async {
    final Position position = await geoLocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    if (position != null) {
      _initialMapLocation = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 14);
      return 0;
    }
    return 1;
  }

  void _refreshEvents() {
    final DateTime now = DateTime.now();

    _eventsDisplayed = _events.where((Event event) {
      final DateTime eventDateStart = event.dateStart;
      if (_distanceValue == FlutterI18n.translate(context, 'FIND_EVENTS.5KM')) {
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

  Widget _buildMapView() {
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

  Widget _buildFilters() {
    return Container(
        color: white,
        constraints: BoxConstraints.expand(
            height: Theme.of(context).textTheme.display1.fontSize * 1.1),
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
            Widget>[
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
                              Text('Interests'),
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
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(border: Border.all(color: black)),
              child: DropdownButton<String>(
                  underline: Container(),
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
                              value: value, child: Text(value)))
                      .toList(),
                  onChanged: (String newValue) => setState(() {
                        _distanceValue = newValue;
                        _refreshEvents();
                      }))),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(border: Border.all(color: black)),
              child: DropdownButton<String>(
                  underline: Container(),
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
                              value: value, child: Text(value)))
                      .toList(),
                  onChanged: (String newValue) => setState(() {
                        _timeValue = newValue;
                        _refreshEvents();
                      })))
        ]));
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

  Widget _buildEvent(
      Event event,
      Map<String, UserEventState> userEventStates,
      void Function(redux.ReduxAction<AppState>) dispatch,
      Future<void> Function(redux.ReduxAction<AppState>) dispatchFuture,
      ThemeStyle theme) {
    final String date = event.dateStart == null
        ? null
        : DateFormat('dd').format(event.dateStart);
    final String month = event.dateStart == null
        ? null
        : DateFormat('MMM').format(event.dateStart);
    final String time = event.dateStart == null
        ? null
        : DateFormat('Hm').format(event.dateStart);
    final String timeEnd =
        event.dateEnd == null ? null : DateFormat('Hm').format(event.dateEnd);
    final UserEventState state = userEventStates[event.id];

    return Column(children: <Widget>[
      GestureDetector(
          onTap: () async => await showLoaderAnimation(context, this,
              executeCallback: true,
              dispatch: dispatch,
              callback: redux.NavigateAction<AppState>.pushNamed(EventScreen.id,
                  arguments: event),
              animationDuration: 600),
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(children: <Widget>[
                if (date != null && time != null)
                  Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                          color: pinkBright,
                          borderRadius: BorderRadius.circular(5.0)),
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Column(children: <Widget>[
                        Text(date,
                            style: const TextStyle(
                                color: white, fontWeight: FontWeight.bold)),
                        Text(month,
                            style: const TextStyle(
                                color: white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0))
                      ])),
                Expanded(
                    child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(event.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('$time - $timeEnd',
                                        style: const TextStyle(color: orange)),
                                    if (event.distance != null)
                                      Text(
                                          '${event.distance.toString()}${FlutterI18n.translate(context, 'FIND_EVENTS.AWAY')}',
                                          style: const TextStyle(color: orange))
                                  ]),
                              Wrap(children: <Widget>[
                                for (String interest in event.interests)
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          border: Border.all(color: pink)),
                                      child: Text(interest.toUpperCase(),
                                          style: const TextStyle(
                                              color: pink,
                                              fontWeight: FontWeight.bold)))
                              ])
                            ]))),
                Stack(alignment: Alignment.center, children: <Widget>[
                  Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              left: BorderSide(color: orange, width: 7.0))),
                      child: CachedImage(event.pic,
                          width: 50.0,
                          height: 50.0,
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(5.0),
                              topRight: Radius.circular(5.0)),
                          imageType: ImageType.Event)),
                  if (state == UserEventState.Attending)
                    const Icon(Icons.check, size: 40.0, color: white)
                  else if (state == UserEventState.Liked)
                    const Icon(MdiIcons.heart, size: 40.0, color: white),
                ])
              ]))),
      const Divider(color: orange),
    ]);
  }

  Widget _buildFindEvents(
      Map<String, UserEventState> userEventStates,
      ThemeStyle themeStyle,
      void Function(redux.ReduxAction<AppState>) dispatch,
      Future<void> Function(redux.ReduxAction<AppState>) dispatchFuture) {
    return Container(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: Column(children: <Widget>[
          Flexible(
              flex: _flexFactorMap,
              child: GestureDetector(
                  onTap: () {
                    _growMap();
                  },
                  child: _buildMapView())),
          Container(
              child: GestureDetector(
                  onTap: () {
                    _shrinkMap();
                  },
                  child: _buildFilters())),
          Expanded(
              flex: _flexFactorListEvent,
              child: Container(
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
                      child: RefreshIndicator(
                          onRefresh: () => dispatchFuture(EventsGetAction()),
                          child: ListView.builder(
                              itemCount: _eventsDisplayed?.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        _buildEvent(
                                            _eventsDisplayed[index],
                                            userEventStates,
                                            dispatch,
                                            dispatchFuture,
                                            themeStyle),
                                      ]))))))
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
        ]));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<dynamic>) dispatch,
        Widget child) {
      _markers.clear();
      _events = state.eventsState.events;
      if (_events == null) {
        return const CircularProgressIndicator();
      }

      _distanceValue ??=
          FlutterI18n.translate(context, 'FIND_EVENTS.ANY_DISTANCE');
      _timeValue ??= FlutterI18n.translate(context, 'FIND_EVENTS.ANY_TIME');
      _refreshEvents();

      for (final Event event in _eventsDisplayed) {
        if (event.location != null) {
          _markers[event.id] = Marker(
              markerId: MarkerId(event.id),
              position:
                  LatLng(event.location.latitude, event.location.longitude),
              infoWindow: InfoWindow(title: event.name));
        }
      }
      return _buildFindEvents(state.userState.user.events, state.theme,
          dispatch, store.dispatchFuture);
    });
  }
}
