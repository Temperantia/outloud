import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

import '../theme.dart';

class LoungeCreateMeetupScreen extends StatelessWidget {
  static const String id = 'LoungeCreateMeetupScreen';
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  CameraPosition _intialMapLocation =
      const CameraPosition(target: LatLng(48.85902056, 2.34637398), zoom: 14);

  void initState() {}

  Widget _buildMap(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(
          height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 300,
        ),
        decoration: const BoxDecoration(color: white),
        padding: const EdgeInsets.all(15),
        child: Column(children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(
              height: Theme.of(context).textTheme.display1.fontSize * 1.1,
            ),
            child: const Text('LOUNGE DESIGNATED MEETUP'),
          ),
          Expanded(
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
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  }))
        ]));
  }

  Widget _buildAdressField(BuildContext context) {
    return Container(
      color: blue,
      constraints: BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 60,
      ),
    );
  }

  Widget _buildTimeField(BuildContext context) {
    return Container(
      color: black,
      constraints: BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 80,
      ),
    );
  }

  Widget _buildNotesField(BuildContext context) {
    return Container(
      color: red,
      constraints: BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 300,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<AppState>) dispatch,
        Widget child) {
      return View(
          child: Container(
              constraints: const BoxConstraints.expand(
                  // width: MediaQuery.of(context).size.width
                  ),
              child: Container(
                  color: white,
                  child: Scrollbar(
                      child: ListView(
                          padding: const EdgeInsets.all(10),
                          children: <Widget>[
                        _buildMap(context),
                        _buildAdressField(context),
                        _buildTimeField(context),
                        _buildNotesField(context)
                      ]))
                  // Column(children: [
                  //   _buildMap(context),
                  //   _buildAdressField(context),
                  //   _buildTimeField(context),
                  //   _buildNotesField(context)
                  // ]),
                  )));
    });
  }
}
