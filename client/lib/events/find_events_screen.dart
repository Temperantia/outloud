import 'dart:async';

import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/interest.dart';
import 'package:business/classes/user_event_state.dart';
import 'package:business/events/actions/events_get_action.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inclusive/events/event_screen.dart';
import 'package:inclusive/functions/loader_animation.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/cached_image.dart';
import 'package:inclusive/widgets/multiselect_dropdown.dart';
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
  final GlobalKey _interestFilterKey = GlobalKey();
  final LayerLink _interestLink = LayerLink();
  final List<CheckBoxContent> _interests = <CheckBoxContent>[];

  CameraPosition _initialMapLocation =
      const CameraPosition(target: LatLng(48.85902056, 2.34637398), zoom: 14);

  int _flexFactorMap = 1;
  int _flexFactorListEvent = 5;
  OverlayEntry _interestsCheckBox;
  bool _checkBoxDisplayed = false;
  String _distanceValue;
  String _timeValue;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _interests.add(CheckBoxContent(checked: false, name: 'Contemporary art'));
    _interests.add(CheckBoxContent(checked: false, name: 'Techno'));
    _interests.add(CheckBoxContent(checked: false, name: 'Food'));
    _interests.add(CheckBoxContent(checked: false, name: 'Gay Community'));
    _interests.add(CheckBoxContent(checked: false, name: 'Books'));
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
    final Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    if (position != null) {
      _initialMapLocation = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 14);
      return 0;
    }
    return 1;
  }

  Widget _buildMapView() {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(color: white),
        child: GoogleMap(
            onTap: (_) {
              _growMap();
            },
            onCameraMoveStarted: () {
              _growMap();
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
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  child: CompositedTransformTarget(
                      link: _interestLink,
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: black, width: 1),
                          ),
                          key: _interestFilterKey,
                          child: FlatButton(
                              child: Row(
                                children: <Widget>[
                                  const Text('Interests'),
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
                                    _interestsCheckBox =
                                        _createInterestsCheckBox();
                                    _checkBoxDisplayed = true;
                                  });
                                  Overlay.of(context)
                                      .insert(_interestsCheckBox);
                                }
                              })))),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration:
                      BoxDecoration(border: Border.all(color: black, width: 1)),
                  child: DropdownButton<String>(
                      hint: const Text('Distance'),
                      underline: Container(),
                      value: _distanceValue,
                      items: <String>[
                        '< 1 km',
                        '< 2 km',
                        '< 3 km',
                        '< 5 km',
                        '< 10km'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String newValue) {
                        setState(() {
                          _distanceValue = newValue;
                        });
                      })),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: black, width: 1),
                  ),
                  child: DropdownButton<String>(
                      hint: const Text('Time'),
                      underline: Container(),
                      value: _timeValue,
                      items: <String>['6 pm', '7 pm', '8 pm', '9 pm', '10 pm']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String newValue) {
                        setState(() {
                          _timeValue = newValue;
                        });
                      }))
            ]));
  }

  OverlayEntry _createInterestsCheckBox() {
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
  }

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
          onTap: () async {
            showLoaderAnimation(
                context,
                this,
                dispatch,
                redux.NavigateAction<AppState>.pushNamed(EventScreen.id,
                    arguments: event),
                600);
          },
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
                                      Container(
                                          child: Text(
                                              '${event.distance.toString()}km away',
                                              style: const TextStyle(
                                                  color: orange)))
                                  ]),
                              Wrap(children: <Widget>[
                                for (Interest interest in event.interests)
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          border: Border.all(color: pink)),
                                      child: Text(interest.name.toUpperCase(),
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
                    Icon(Icons.check, size: 40.0, color: white)
                  else if (state == UserEventState.Liked)
                    Icon(MdiIcons.heart, size: 40.0, color: white),
                ])
              ]))),
      const Divider(color: orange),
    ]);
  }

  Widget _buildFindEvents(
      List<Event> events,
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
                          onRefresh: () {
                            return dispatchFuture(EventsGetAction());
                          },
                          child: ListView.builder(
                              itemCount: events?.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        _buildEvent(
                                            events[index],
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
      for (final Event event in state.eventsState.events) {
        if (event.location != null) {
          _markers[event.id] = Marker(
              markerId: MarkerId(event.id),
              position:
                  LatLng(event.location.latitude, event.location.longitude),
              infoWindow: InfoWindow(title: event.name));
        }
      }
      return Container(
          child: _buildFindEvents(
              state.eventsState.events,
              state.userState.user.events,
              state.theme,
              dispatch,
              store.dispatchFuture));
    });
  }
}
