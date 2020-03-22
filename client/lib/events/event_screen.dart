import 'dart:async';

import 'package:business/app_state.dart';
import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/classes/event.dart';
import 'package:business/events/actions/event_register_action.dart';
import 'package:business/events/actions/event_unregister_action.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/lounges/lounges_screen.dart';
import 'package:inclusive/theme.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:expandable/expandable.dart';
import 'package:inclusive/widgets/cached_image.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:intl/intl.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class EventScreen extends StatefulWidget {
  const EventScreen(this.event);

  final Event event;
  static const String id = 'EventScreen';

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final Map<String, Marker> _markers = <String, Marker>{};

  CameraPosition _intialMapLocation;
  // final double _googleMapSize = 60.0;
  String _adressEvent;

  @override
  void initState() {
    super.initState();
    _resolveAdressEvent();
    _intialMapLocation = CameraPosition(
        target: LatLng(
            widget.event.location.latitude, widget.event.location.longitude),
        zoom: 14);
    _markers.clear();
    _markers[widget.event.id] = Marker(
        markerId: MarkerId(widget.event.id),
        position: LatLng(
            widget.event.location.latitude, widget.event.location.longitude),
        infoWindow: InfoWindow(title: widget.event.name));
  }

  Future<int> _resolveAdressEvent() async {
    final List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(
            widget.event.location.latitude, widget.event.location.longitude);
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

  Widget _buildEventInfo(
      AppState state, void Function(redux.ReduxAction<dynamic>) dispatch) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
              child: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                      margin: const EdgeInsets.all(5),
                      color: Colors.green[800],
                      child: Column(
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.all(5),
                              child: RichText(
                                  text: TextSpan(
                                      text: widget.event.date.day.toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700)))),
                          Padding(
                              padding: const EdgeInsets.all(5),
                              child: RichText(
                                  text: TextSpan(
                                      text: DateFormat('MMM')
                                          .format(widget.event.date),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700))))
                        ],
                      ))),
              Expanded(
                  flex: 5,
                  child: Container(
                      child: RichText(
                          text: TextSpan(
                    text: widget.event.name,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w700),
                  ))))
            ],
          )),
          GestureDetector(
              onTap: () async {
                final GoogleMapController controller = await _controller.future;
                controller.animateCamera(
                    CameraUpdate.newCameraPosition(_intialMapLocation));
              },
              child: Container(
                  child: Row(
                children: <Widget>[
                  Icon(Icons.location_on),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: RichText(
                          text: TextSpan(
                              text: _adressEvent,
                              style: TextStyle(
                                  color: Colors.green[800],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500))))
                ],
              ))),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.all(10),
                        color: Colors.green,
                        child: Column(
                          children: <Widget>[
                            Container(
                                padding: const EdgeInsets.all(5),
                                child: RichText(
                                    text: TextSpan(
                                        text: DateFormat('jm')
                                            .format(widget.event.date),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500)))),
                            Container(
                                padding: const EdgeInsets.all(5),
                                child: RichText(
                                    text: TextSpan(
                                        text: DateFormat('jm').format(widget
                                            .event.date
                                            .add(const Duration(hours: 2))),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500))))
                          ],
                        ))),
                Expanded(
                    child: InkWell(
                        splashColor: yellow,
                        onTap: () {
                          if (state.userState.eventLounges[widget.event.id] !=
                              null) {
                            dispatch(redux.NavigateAction<AppState>.pushNamed(
                                LoungesScreen.id,
                                arguments: widget.event));
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          color: Colors.green,
                          child: Column(
                            children: <Widget>[
                              Container(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Icon(Icons.airline_seat_recline_extra,
                                          color: Colors.white, size: 16),
                                      RichText(
                                          text: TextSpan(
                                              text: state.userState
                                                              .eventLounges[
                                                          widget.event.id] !=
                                                      null
                                                  ? state
                                                      .userState
                                                      .eventLounges[
                                                          widget.event.id]
                                                      .length
                                                      .toString()
                                                  : 'N/A',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.w400))),
                                    ],
                                  )),
                              Container(
                                padding: const EdgeInsets.all(5),
                                child: RichText(
                                    text: const TextSpan(
                                        text: 'LOUNGES',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400))),
                              )
                            ],
                          ),
                        ))),
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.all(10),
                        color: Colors.green,
                        child: Column(
                          children: <Widget>[
                            Container(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Icon(Icons.favorite_border,
                                        color: Colors.white, size: 16),
                                    RichText(
                                        text: const TextSpan(
                                            // text: widget.event.memberIds.length.toString(),
                                            text: '6',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400))),
                                  ],
                                )),
                            Container(
                              padding: const EdgeInsets.all(5),
                              child: RichText(
                                  text: const TextSpan(
                                      text: 'LIKED',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400))),
                            )
                          ],
                        ))),
                Expanded(
                    child: InkWell(
                        onTap: () {
                          if (state.userState.user
                              .isAttendingEvent(widget.event.id)) {
                            dispatch(EventUnRegisterAction(widget.event.id));
                          } else {
                            dispatch(EventRegisterAction(widget.event.id));
                          }
                        },
                        child: Container(
                            margin: const EdgeInsets.all(10),
                            color: Colors.green[700],
                            child: Column(
                              children: <Widget>[
                                Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Icon(
                                            state.userState.user
                                                    .isAttendingEvent(
                                                        widget.event.id)
                                                ? Icons.check
                                                : Icons.do_not_disturb,
                                            color: Colors.white,
                                            size: 16),
                                        RichText(
                                            text: TextSpan(
                                                // text: widget.event.memberIds.length.toString(),
                                                text: state.userState.user
                                                        .isAttendingEvent(
                                                            widget.event.id)
                                                    ? '5'
                                                    : '4',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400))),
                                      ],
                                    )),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  child: RichText(
                                      text: const TextSpan(
                                          text: 'ATTENDING',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400))),
                                )
                              ],
                            ))))
              ],
            ),
          ),
          Container(
            // margin: const EdgeInsets.all(5),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(color: red, width: 1.0)),
                        child: RichText(
                            text: TextSpan(
                                text: 'Entertainment',
                                style: TextStyle(
                                    color: Colors.green[600],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600))))),
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(5),
                        color: Colors.pink[100],
                        child: RichText(
                            text: TextSpan(
                                text: '21 and Over',
                                style: TextStyle(
                                    color: Colors.green[800],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600))))),
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(5),
                        color: Colors.pink[100],
                        child: RichText(
                            text: TextSpan(
                                text: '\$29.00 - \$79.00',
                                style: TextStyle(
                                    color: Colors.green[800],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600))))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
        child: ExpandablePanel(
      header: Container(
        color: Colors.green[400],
        padding: const EdgeInsets.all(10),
        child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'EVENT DESCRIPTION',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600))),
      ),
      iconColor: Colors.green,
      expanded: Container(
          child: Text(
        widget.event.description,
        softWrap: true,
      )),
    ));
  }

  Widget _buildBanner() {
    return Container(
      constraints: const BoxConstraints.expand(height: 160),
      child: Row(
        children: <Widget>[
          if (widget.event.pic.isNotEmpty)
            Expanded(flex: 1, child: CachedImage(widget.event.pic)),
          Expanded(
              flex: 1,
              child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(color: white),
                  child: GoogleMap(
                      mapType: MapType.normal,
                      zoomGesturesEnabled: true,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      gestureRecognizers: <
                          Factory<OneSequenceGestureRecognizer>>{
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
        ],
      ),
    );
  }

  Widget _buildLiveFeedSponsor() {
    return Container(
      color: Colors.grey[400],
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
                  margin: const EdgeInsets.all(5),
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: 'LIVE FEED',
                          style: TextStyle(
                              color: Colors.purple[500],
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
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400))),
                  ),
                  Container(
                    child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                            text: 'https://www.sponsor-best.com ',
                            style: TextStyle(
                                color: Colors.purple[200],
                                fontSize: 15,
                                fontWeight: FontWeight.w700))),
                  ),
                  Container(
                    child: RichText(
                        text: TextSpan(
                            text: 'Twitter / Facebook / @BestEvent',
                            style: TextStyle(
                                color: Colors.purple[200],
                                fontSize: 15,
                                fontWeight: FontWeight.w700))),
                  )
                ],
              ))
        ],
      ),
    );
  }

  Widget _buildLiveFeed() {
    return Container(
        height: 280,
        child: ListView.builder(
          itemCount: 150,
          itemBuilder: (BuildContext context, int index) => Container(
            child: Row(
              mainAxisAlignment: index.isEven
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: <Widget>[Text(' NEWS  - $index ')],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<dynamic>) dispatch,
        Widget child) {
      return View(
          child: Container(
              color: white,
              constraints: const BoxConstraints.expand(),
              child: Scrollbar(
                  child: ListView(
                children: <Widget>[
                  _buildEventInfo(state, dispatch),
                  _buildBanner(),
                  _buildDescription(),
                  _buildLiveFeedSponsor(),
                  _buildLiveFeed()
                ],
              ))));
    });
  }
}
