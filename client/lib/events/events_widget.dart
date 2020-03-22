import 'dart:async';

import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/events/actions/events_get_action.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inclusive/events/event_screen.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/button.dart';
import 'package:inclusive/widgets/cached_image.dart';
import 'package:inclusive/widgets/loading.dart';
import 'package:inclusive/widgets/multiselect_dropdown.dart';
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

  CameraPosition _intialMapLocation =
      const CameraPosition(target: LatLng(48.85902056, 2.34637398), zoom: 14);
  // double _googleMapSize = 60.0;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _interestFilterKey = GlobalKey();
  final LayerLink _interestLink = LayerLink();

  int _flexFactorMap = 1;
  int _flexFactorListEvent = 5;
  OverlayEntry _interestsCheckBox;
  bool _checkBoxDisplayed = false;
  String _distanceValue;
  String _timeValue;

  final List<CheckBoxContent> _interests = <CheckBoxContent>[];

  @override
  void initState() {
    super.initState();
    _interests.add(CheckBoxContent(checked: false, name: 'Contemporary art'));
    _interests.add(CheckBoxContent(checked: false, name: 'Techno'));
    _interests.add(CheckBoxContent(checked: false, name: 'Food'));
    _interests.add(CheckBoxContent(checked: false, name: 'Gay Community'));
    _interests.add(CheckBoxContent(checked: false, name: 'Books'));
    _scrollController.addListener(() {
      setState(() {
        _flexFactorListEvent = 5;
        _flexFactorMap = 1;
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

/*  Widget _buildMap() {
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
              if (!_controller.isCompleted) {
                _controller.complete(controller);
              }
            }));
  } */

  Widget _buildMapView() {
    return Container(
        // constraints: const BoxConstraints.expand(),
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(color: white),
        child: GoogleMap(
            onTap: (LatLng latlang) {
              setState(() {
                _flexFactorListEvent = 2;
                _flexFactorMap = 4;
              });
            },
            onCameraMoveStarted: () {
              setState(() {
                _flexFactorListEvent = 2;
                _flexFactorMap = 4;
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
                // padding: const EdgeInsets.all(5),
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
                            setState(() {
                              _flexFactorListEvent = 5;
                              _flexFactorMap = 1;
                              _interestsCheckBox = _createInterestsCheckBox();
                              _checkBoxDisplayed = true;
                            });
                            Overlay.of(context).insert(_interestsCheckBox);
                          }
                        },
                      ),
                    ))),
            Container(
                decoration: BoxDecoration(
                  border: Border.all(color: black, width: 1),
                ),
                child: DropdownButton<String>(
                    hint: const Text('Set distance'),
                    underline: Container(),
                    value: _distanceValue,
                    items: <String>[
                      ' < 1 km',
                      ' < 2 km',
                      ' < 3 km',
                      ' < 5 km',
                      ' < 10km'
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
                decoration: BoxDecoration(
                  border: Border.all(color: black, width: 1),
                ),
                child: DropdownButton<String>(
                    hint: const Text('Set time'),
                    underline: Container(),
                    value: _timeValue,
                    items: <String>[
                      ' 6 pm ',
                      ' 7 pm',
                      ' 8 pm',
                      ' 9 pm',
                      ' 10 pm'
                    ].map<DropdownMenuItem<String>>((String value) {
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
          ],
        ));
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
                  child: MyMultiCheckBoxesContent(checkboxes: _interests)),
            )));
  }

  @override
  void dispose() {
    // TODO(me): dispose time
    super.dispose();
  }

  Widget _buildUserEvents(List<Event> events, ThemeStyle themeStyle,
      void Function(redux.ReduxAction<AppState>) dispatch) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (BuildContext context, int index) => Container(
                    decoration: const BoxDecoration(color: white),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildEvent(events[index], dispatch, themeStyle),
                        ]))),
          ),
          Expanded(
              child: Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                Button(
                    text: 'VIEW CALENDAR', width: 200, onPressed: () => null),
              ])))
        ],
      ),
    );
  }

  Widget _buildFindEvents(
      List<Event> events,
      ThemeStyle themeStyle,
      void Function(redux.ReduxAction<AppState>) dispatch,
      Future<void> Function(redux.ReduxAction<AppState>) dispatchFuture) {
    return Container(
        child: Column(children: <Widget>[
      Expanded(
          flex: _flexFactorMap,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _flexFactorListEvent = 2;
                _flexFactorMap = 4;
              });
            },
            child: _buildMapView(),
          )),
      _buildFilters(),
      Expanded(
          flex: _flexFactorListEvent,
          child: RefreshIndicator(
              onRefresh: () => dispatchFuture(EventsGetAction()),
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: events.length,
                  itemBuilder: (BuildContext context, int index) => Container(
                      decoration: const BoxDecoration(color: white),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _buildEvent(events[index], dispatch, themeStyle),
                          ]))))),
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

  Widget _buildEvent(Event event,
      void Function(redux.ReduxAction<AppState>) dispatch, ThemeStyle theme) {
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
            dispatch(redux.NavigateAction<AppState>.pushNamed(EventScreen.id,
                arguments: event));
          },
          child: Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                if (event != null && event.pic.isNotEmpty)
                  Flexible(
                      child:
                          CachedImage(event.pic, width: 100.0, height: 100.0)),
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
                      _buildUserEvents(userEvents, themeStyle, dispatch),
                      _buildFindEvents(
                          events, themeStyle, dispatch, store.dispatchFuture),
                    ]))),
          ]));
    });
  }
}
