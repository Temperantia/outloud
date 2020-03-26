import 'dart:async';

import 'package:business/app_state.dart';
import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/classes/event.dart';
import 'package:business/classes/interest.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/events/actions/event_like_action.dart';
import 'package:business/events/actions/event_unlike_action.dart';
import 'package:business/events/actions/event_register_action.dart';
import 'package:business/events/actions/event_unregister_action.dart';
import 'package:business/models/events.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/lounges/lounge_chat_screen.dart';
import 'package:inclusive/lounges/lounges_screen.dart';
import 'package:inclusive/theme.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:expandable/expandable.dart';
import 'package:inclusive/widgets/cached_image.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class EventScreen extends StatefulWidget {
  const EventScreen(this.event);

  final Event event;
  static const String id = 'EventScreen';

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  Event _event;
  StreamSubscription<Event> _eventSub;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final Map<String, Marker> _markers = <String, Marker>{};

  CameraPosition _intialMapLocation;
  String _adressEvent;

  @override
  void initState() {
    super.initState();
    _event = widget.event;
    _eventSub = streamEvent(widget.event.id)
        .listen((Event event) => setState(() => _event = event));
    _resolveAdressEvent();
    _intialMapLocation = CameraPosition(
        target: LatLng(_event.location.latitude, _event.location.longitude),
        zoom: 14);
    _markers.clear();
    _markers[_event.id] = Marker(
        markerId: MarkerId(_event.id),
        position: LatLng(_event.location.latitude, _event.location.longitude),
        infoWindow: InfoWindow(title: _event.name));
  }

  Future<int> _resolveAdressEvent() async {
    final List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(
            _event.location.latitude, _event.location.longitude);
    String _address = '';
    if (placemark.isNotEmpty) {
      final Placemark _place = placemark.first;
      _address = _place.subThoroughfare +
          ' ' +
          _place.thoroughfare +
          ' ' +
          _place.postalCode.toString() +
          ' ' +
          _place.locality;
    }
    setState(() {
      _adressEvent = _address;
    });
    return 0;
  }

  @override
  void dispose() {
    _eventSub.cancel();
    super.dispose();
  }

  Widget _buildEventInfo(
      AppState state, void Function(redux.ReduxAction<dynamic>) dispatch) {
    final bool isUserAttending =
        state.userState.user.isAttendingEvent(_event.id);

    return Column(children: <Widget>[
      Stack(alignment: Alignment.center, children: <Widget>[
        Row(children: <Widget>[
          Expanded(
              child: CachedImage(_event.pic,
                  height: 100.0, imageType: ImageType.Event))
        ]),
        Row(children: <Widget>[
          Expanded(
              child: Container(color: black.withOpacity(0.4), height: 100.0))
        ]),
        Column(children: <Widget>[
          Row(children: <Widget>[
            Expanded(
                child: Container(
                    margin: const EdgeInsets.all(5),
                    color: pink,
                    child: Column(children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(5),
                          child: RichText(
                              text: TextSpan(
                                  text: _event.dateStart.day.toString(),
                                  style: const TextStyle(
                                      color: white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700)))),
                      Padding(
                          padding: const EdgeInsets.all(5),
                          child: RichText(
                              text: TextSpan(
                                  text: DateFormat('MMM')
                                      .format(_event.dateStart),
                                  style: const TextStyle(
                                      color: white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700))))
                    ]))),
            Expanded(
                flex: 5,
                child: Container(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: RichText(
                        text: TextSpan(
                            text: _event.name,
                            style: const TextStyle(
                                color: white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700)))))
          ]),
          GestureDetector(
              onTap: () async {
                final GoogleMapController controller = await _controller.future;
                controller.animateCamera(
                    CameraUpdate.newCameraPosition(_intialMapLocation));
              },
              child: Container(
                  child: Row(children: <Widget>[
                Icon(Icons.location_on, color: pink),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: RichText(
                        text: TextSpan(
                            text: _adressEvent,
                            style: const TextStyle(
                                color: white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500))))
              ]))),
        ])
      ]),
      Container(
        height: 50.0,
        margin: const EdgeInsets.all(10),
        child: Row(children: <Widget>[
          Expanded(
              child: Container(
                  margin: const EdgeInsets.only(right: 5.0),
                  decoration:
                      BoxDecoration(border: Border.all(color: pinkLight)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RichText(
                            text: TextSpan(
                                text:
                                    '${DateFormat('jm').format(_event.dateStart)} -',
                                style: const TextStyle(
                                    color: pinkLight,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900))),
                        RichText(
                            text: TextSpan(
                                text: DateFormat('jm').format(_event.dateEnd
                                    .add(const Duration(hours: 2))),
                                style: const TextStyle(
                                    color: pinkLight,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900)))
                      ]))),
          _buildLoungeButton(isUserAttending, state, dispatch),
          Expanded(
              child: Container(
                  padding: const EdgeInsets.all(5),
                  color: isUserAttending ? pink : orange,
                  child: InkWell(
                      onTap: () {
                        if (isUserAttending) {
                          dispatch(EventUnRegisterAction(_event));
                        } else {
                          dispatch(EventRegisterAction(_event));
                        }
                      },
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                  Icon(Icons.check, color: white, size: 16),
                                  RichText(
                                      text: TextSpan(
                                          text: _event.memberIds.length
                                              .toString(),
                                          style: const TextStyle(
                                              color: white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400)))
                                ])),
                            Container(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: RichText(
                                    text: const TextSpan(
                                        text: 'ATTENDING',
                                        style: TextStyle(
                                            color: white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400))))
                          ]))))
        ]),
      ),
      Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Wrap(children: <Widget>[
                  for (final Interest interest in _event.interests)
                    Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(5),
                        decoration:
                            BoxDecoration(border: Border.all(color: pinkLight)),
                        child: RichText(
                            text: TextSpan(
                                text: interest.name,
                                style: const TextStyle(
                                    color: pink,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)))),
                  Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      color: Colors.pink[100],
                      child: RichText(
                          text: const TextSpan(
                              text: '21 and Over', // TODO(alexandre): firestore
                              style: TextStyle(
                                  color: pink,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)))),
                  Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      color: Colors.pink[100],
                      child: RichText(
                          text: TextSpan(
                              text: _event.price,
                              style: const TextStyle(
                                  color: pink,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600))))
                ])
              ]))
    ]);
  }

  Widget _buildLoungeButton(bool isUserAttending, AppState state,
      void Function(redux.ReduxAction<dynamic>) dispatch) {
    Widget widget;
    final Lounge userLounge = state.userState.lounges.firstWhere(
        (Lounge lounge) => lounge.eventId == _event.id,
        orElse: () => null);
    final List<Lounge> lounges = state.userState.eventLounges[_event.id];
    final String s = lounges == null || lounges.length == 1 ? '' : 'S';

    if (userLounge != null) {
      widget = Container(
          margin: const EdgeInsets.only(right: 5.0),
          color: blue,
          child: InkWell(
              onTap: () {
                dispatch(redux.NavigateAction<AppState>.pushNamed(
                    LoungeChatScreen.id,
                    arguments: userLounge));
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        width: 20.0,
                        height: 20.0,
                        child: Image.asset('images/iconLounge.png')),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Text('VIEW MY',
                              style: TextStyle(
                                  color: white, fontWeight: FontWeight.bold)),
                          Text('LOUNGE',
                              style: TextStyle(
                                  color: white, fontWeight: FontWeight.bold)),
                        ]),
                  ])));
    } else if (isUserAttending) {
      widget = Container(
          margin: const EdgeInsets.only(right: 5.0),
          color: pinkLight,
          child: InkWell(
              onTap: () {
                dispatch(redux.NavigateAction<AppState>.pushNamed(
                    LoungesScreen.id,
                    arguments: _event));
              },
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                          Container(
                              width: 20.0,
                              height: 20.0,
                              child: Image.asset('images/iconLounge.png')),
                          RichText(
                              text: TextSpan(
                                  text: lounges.length.toString(),
                                  style: const TextStyle(
                                      color: white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400))),
                        ])),
                    Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: RichText(
                            text: TextSpan(
                                text: 'LOUNGE$s',
                                style: const TextStyle(
                                    color: white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400))))
                  ])));
    } else {
      widget = Container(
          margin: const EdgeInsets.only(right: 5.0),
          color: grey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        width: 20.0,
                        height: 20.0,
                        child: Image.asset('images/iconLounge.png')),
                    const Text('ATTEND',
                        style: TextStyle(
                            color: white, fontWeight: FontWeight.bold)),
                  ]),
              const Text('FOR LOUNGES', style: TextStyle(color: white)),
            ],
          ));
    }
    return Expanded(child: widget);
  }

  Widget _buildDescription() {
    return Container(
        child: ExpandablePanel(
            header: Container(
              color: orange,
              padding: const EdgeInsets.all(10),
              child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                      text: 'EVENT DESCRIPTION',
                      style: TextStyle(
                          color: white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600))),
            ),
            iconColor: orange,
            expanded: Container(
                padding: const EdgeInsets.all(20.0),
                child: Text(_event.description, softWrap: true))));
  }

  Widget _buildBanner() {
    return Row(children: <Widget>[
      Expanded(
          child: Container(
              height: 160.0,
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(color: white),
              child: GoogleMap(
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
                  })))
    ]);
  }

  Widget _buildLiveFeedSponsor() {
    return Container(
        color: Colors.grey[400],
        child: Row(children: <Widget>[
          Expanded(
              child: Container(
                  margin: const EdgeInsets.all(5),
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                          text: 'LIVE FEED',
                          style: TextStyle(
                              color: blue,
                              fontSize: 28,
                              fontWeight: FontWeight.w900))))),
          Expanded(
              flex: 3,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        child: RichText(
                            textAlign: TextAlign.left,
                            text: const TextSpan(
                                text: 'Sponsored by : Best event provider',
                                style: TextStyle(
                                    color: black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400)))),
                    Container(
                        child: RichText(
                            textAlign: TextAlign.left,
                            text: const TextSpan(
                                text: 'https://www.sponsor-best.com',
                                style: TextStyle(
                                    color: blue,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700)))),
                    Container(
                        child: RichText(
                            text: const TextSpan(
                                text: 'Twitter / Facebook / @BestEvent',
                                style: TextStyle(
                                    color: blue,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700))))
                  ]))
        ]));
  }

  /*  Widget _buildLiveFeed() {
    return Container(
        height: 280,
        child: ListView.builder(
            itemCount: 150,
            itemBuilder: (BuildContext context, int index) => Container(
                child: Row(
                    mainAxisAlignment: index.isEven
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: <Widget>[Text(' NEWS  - $index ')]))));
  } */

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<dynamic>) dispatch,
        Widget child) {
      return View(
          title: 'EVENT DETAILS',
          actions: _event == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                      onTap: () {
                        if (_event.likes.contains(state.loginState.id)) {
                          dispatch(EventUnlikeAction(_event));
                        } else {
                          dispatch(EventLikeAction(_event));
                        }
                      },
                      child: Row(children: <Widget>[
                        if (_event.likes.contains(state.loginState.id))
                          Icon(MdiIcons.heart, color: white)
                        else
                          Icon(Icons.favorite_border, color: white),
                        Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(_event.likes.length.toString(),
                                style: const TextStyle(color: white)))
                      ])),
                ),
          child: _event == null
              ? const CircularProgressIndicator()
              : Container(
                  color: white,
                  constraints: const BoxConstraints.expand(),
                  child: Scrollbar(
                      child: ListView(children: <Widget>[
                    _buildEventInfo(state, dispatch),
                    _buildBanner(),
                    _buildDescription(),
                    _buildLiveFeedSponsor(),
                    // TODO(robin): later feature
                    //_buildLiveFeed()
                  ]))));
    });
  }
}
