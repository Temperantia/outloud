import 'dart:async';

import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/interest.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user_event_state.dart';
import 'package:business/events/actions/events_get_action.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inclusive/events/event_screen.dart';
import 'package:inclusive/lounges/lounge_chat_screen.dart';
import 'package:inclusive/lounges/lounges_screen.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/button.dart';
import 'package:inclusive/widgets/cached_image.dart';
import 'package:inclusive/widgets/loading.dart';
import 'package:inclusive/widgets/multiselect_dropdown.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                      hint: const Text('Distance'),
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
                  child: MyMultiCheckBoxesContent(checkboxes: _interests)),
            )));
  }

  Widget _buildUserEvents(
      List<Event> events,
      Map<String, UserEventState> userEventStates,
      List<Lounge> userLounges,
      ThemeStyle themeStyle,
      void Function(redux.ReduxAction<AppState>) dispatch) {
    return Column(children: <Widget>[
      Expanded(
          flex: 8,
          child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (BuildContext context, int index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildUserEvent(events[index], userEventStates,
                            userLounges, dispatch, themeStyle),
                        const Divider(color: orange),
                      ]))),
      Expanded(
          child: Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
            Button(text: 'VIEW CALENDAR', width: 200, onPressed: () => null)
          ])))
    ]);
  }

  Widget _buildUserEvent(
      Event event,
      Map<String, UserEventState> userEventStates,
      List<Lounge> userLounges,
      void Function(redux.ReduxAction<AppState>) dispatch,
      ThemeStyle theme) {
    final String date = event.dateStart == null
        ? null
        : DateFormat('dd').format(event.dateStart);
    final String month = event.dateStart == null
        ? null
        : DateFormat('MMM').format(event.dateStart);
    final String time = event.dateStart == null
        ? null
        : DateFormat('jm').format(event.dateStart);
    final String timeEnd =
        event.dateEnd == null ? null : DateFormat('jm').format(event.dateEnd);

    final UserEventState state = userEventStates[event.id];
    String stateMessage;
    if (state == UserEventState.Attending) {
      stateMessage = 'Going';
    } else if (state == UserEventState.Liked) {
      stateMessage = 'Liked';
    }

    final Lounge lounge = userLounges.firstWhere(
        (Lounge lounge) => lounge.eventId == event.id,
        orElse: () => null);

    if (date == null || month == null || time == null) {
      return Container();
    }
    return Container(
        padding: const EdgeInsets.all(10.0),
        child: Row(children: <Widget>[
          Stack(alignment: Alignment.center, children: <Widget>[
            CachedImage(event.pic,
                width: 70.0,
                height: 70.0,
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(5.0),
                    topRight: Radius.circular(5.0))),
            Container(color: pink.withOpacity(0.5), width: 70.0, height: 70.0),
            Column(children: <Widget>[
              Text(date,
                  style: const TextStyle(
                      color: white, fontWeight: FontWeight.bold, fontSize: 20)),
              Text(month,
                  style: const TextStyle(
                      color: white, fontWeight: FontWeight.bold))
            ])
          ]),
          Container(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(event.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('$time - $timeEnd'),
                          Container(
                              padding: const EdgeInsets.only(left: 100.0),
                              child: Row(children: <Widget>[
                                if (state == UserEventState.Attending)
                                  Icon(Icons.check)
                                else if (state == UserEventState.Liked)
                                  Icon(MdiIcons.heart),
                                Text(stateMessage),
                              ]))
                        ]),
                    if (lounge == null)
                      Button(
                          text: 'JOIN A LOUNGE',
                          width: 300.0,
                          height: 30.0,
                          backgroundColor: orange,
                          backgroundOpacity: 1.0,
                          onPressed: () => dispatch(
                              redux.NavigateAction<AppState>.pushNamed(
                                  LoungesScreen.id,
                                  arguments: event)))
                    else
                      Button(
                          text: 'VIEW LOUNGE',
                          width: 300.0,
                          height: 30.0,
                          backgroundColor: pinkBright,
                          backgroundOpacity: 1.0,
                          onPressed: () => dispatch(
                              redux.NavigateAction<AppState>.pushNamed(
                                  LoungeChatScreen.id,
                                  arguments: lounge)))
                  ]))
        ]));
  }

  Widget _buildFindEvents(
      List<Event> events,
      Map<String, UserEventState> userEventStates,
      ThemeStyle themeStyle,
      void Function(redux.ReduxAction<AppState>) dispatch,
      Future<void> Function(redux.ReduxAction<AppState>) dispatchFuture) {
    // TODO(robin): it seems the refresh indicator behaviour is overriden by some gesture detection from your map trick
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
              child: _buildMapView())),
      _buildFilters(),
      Expanded(
          flex: _flexFactorListEvent,
          child: RefreshIndicator(
              onRefresh: () => dispatchFuture(EventsGetAction()),
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: events.length,
                  itemBuilder: (BuildContext context, int index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _buildEvent(events[index], userEventStates,
                                dispatch, themeStyle),
                          ]))))
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

  Widget _buildEvent(Event event, Map<String, UserEventState> userEventStates,
      void Function(redux.ReduxAction<AppState>) dispatch, ThemeStyle theme) {
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
            dispatch(redux.NavigateAction<AppState>.pushNamed(EventScreen.id,
                arguments: event));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
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
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(event.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Row(children: <Widget>[
                              Text('$time - $timeEnd',
                                  style: const TextStyle(color: orange)),
                              if (event.distance != null)
                                Padding(
                                    padding: const EdgeInsets.only(left: 50.0),
                                    child: Text(
                                        '${event.distance.toString()}km away',
                                        style: const TextStyle(color: orange)))
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
                                        style: TextStyle(
                                            color: pink,
                                            fontWeight: FontWeight.bold)))
                            ])
                          ])),
                  if (event != null && event.pic.isNotEmpty)
                    Stack(alignment: Alignment.center, children: <Widget>[
                      Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  left: BorderSide(color: orange, width: 7.0))),
                          child: CachedImage(
                            event.pic,
                            width: 50.0,
                            height: 50.0,
                            borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(5.0),
                                topRight: Radius.circular(5.0)),
                          )),
                      if (state == UserEventState.Attending)
                        Icon(Icons.check, size: 40.0, color: white)
                      else
                        Icon(MdiIcons.heart, size: 40.0, color: white),
                    ]),
                ]),
          )),
      const Divider(color: orange),
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
      final Map<String, UserEventState> userEventStates =
          state.userState.user.events;
      final List<Lounge> userLounges = state.userState.lounges;
      final ThemeStyle themeStyle = state.theme;
      if (events == null ||
          userEvents == null ||
          userEventStates == null ||
          userLounges == null) {
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
                      _buildUserEvents(userEvents, userEventStates, userLounges,
                          themeStyle, dispatch),
                      _buildFindEvents(events, userEventStates, themeStyle,
                          dispatch, store.dispatchFuture),
                    ]))),
          ]));
    });
  }
}
