import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../theme.dart';

const String googleApiKey = 'AIzaSyCO8sI1kmXRQXqvwQRGrnbAW3IX-VTcCDw';

class LoungeMeetupWidget extends StatefulWidget {
  LoungeMeetupWidget(this.lounge);
  static const String id = 'LoungeMeetupWidget';

  final Lounge lounge;

  _LoungeMeetupWidgetState loungeMeetupWidgetState = _LoungeMeetupWidgetState();

// TODO(robin): what ?
  @override
  _LoungeMeetupWidgetState createState() {
    final _LoungeMeetupWidgetState _loungeMeetupWidgetState =
        loungeMeetupWidgetState;
    _loungeMeetupWidgetState.initLounge(lounge);
    return _loungeMeetupWidgetState;
  }

  Map<String, dynamic> saveMeetupOptions() {
    return loungeMeetupWidgetState.saveMeetupOptions();
  }
}

class _LoungeMeetupWidgetState extends State<LoungeMeetupWidget> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  //final ScrollController _scrollController = ScrollController();
  final Map<String, Marker> _markers = <String, Marker>{};
  final FocusNode _focusNodeAdress = FocusNode();
  final FocusNode _focusNodeNotes = FocusNode();
  final LayerLink _layerLink = LayerLink();
  final LayerLink _mapLink = LayerLink();
  final LayerLink _dateLink = LayerLink();
  final GlobalKey _keySearch = GlobalKey();
  final GlobalKey _keyMap = GlobalKey();
  final GlobalKey _keyDate = GlobalKey();
  final TextEditingController _searchTextController = TextEditingController();
  final TextEditingController _notesTextController = TextEditingController();

  List<PlacesSearchResult> _resultPlaces = <PlacesSearchResult>[];
  CameraPosition _intialMapLocation;
  GoogleMapsPlaces _googleMapsPlaces;
  PlacesSearchResult _choosenPlace;

  OverlayEntry _suggestionsOverlay;
  OverlayEntry _mapButtonsOverlay;

  Timer _throttle;
  Marker _positionOfPlace;
  Marker _savedMarker;
  bool _adressChoosen;
  bool _moovingMarker;
  bool _overlayInserted;
  TimeOfDay _timeEvent;
  DateTime _dateEvent;

  @override
  void initState() {
    super.initState();
    _initVariables();
  }

  @override
  void dispose() {
    _searchTextController.removeListener(_onSearchChanged);
    _searchTextController.dispose();
    super.dispose();
  }

  Future<int> initLounge(Lounge lounge) async {
    final String _address = await _getAdressFromCoordinates(
        lounge.location.latitude, lounge.location.longitude);
    setState(() {
      lounge = lounge;
      _searchTextController.text = _address;
      _positionOfPlace = Marker(
          markerId: MarkerId(_address),
          position: LatLng(lounge.location.latitude, lounge.location.longitude),
          infoWindow: InfoWindow(snippet: _address, title: 'Meeting point'));

      _markers.clear();
      _markers[_positionOfPlace.markerId.toString()] = _positionOfPlace;
      _notesTextController.text = lounge.notes;
      _timeEvent = TimeOfDay.fromDateTime(lounge.date);
      _dateEvent = lounge.date;
    });
    _moveCameraToPosition(_positionOfPlace.position, 15);
    return 0;
  }

  Future<int> _onSearchChanged() async {
    if (_throttle?.isActive ?? false) {
      _throttle.cancel();
    }

    _throttle = Timer(const Duration(milliseconds: 500), () {
      if (!_adressChoosen) {
        _displayPrediction();
      }
    });
    return 0;
  }

  Future<String> _getAdressFromCoordinates(
      double latitude, double longitude) async {
    final List<Placemark> placemark =
        await Geolocator().placemarkFromCoordinates(latitude, longitude);
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
    return _address;
  }

  Future<int> _updateTimeOfEvent() async {
    final TimeOfDay timeSelected = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
              child: child);
        });
    if (timeSelected != null) {
      setState(() {
        _timeEvent = timeSelected;
      });
    }
    return 0;
  }

  Future<int> _moveCameraToPosition(LatLng position, double zoom) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: zoom)));
    return 0;
  }

  Future<int> _displayPrediction() async {
    final PlacesSearchResponse response =
        await _googleMapsPlaces.searchByText(_searchTextController.text);
    if (response.results.isNotEmpty) {
      if (_overlayInserted) {
        _suggestionsOverlay.remove();
      }
      setState(() {
        _resultPlaces = response.results;
        _suggestionsOverlay = _createOverlayEntry();
        _overlayInserted = true;
      });
      Overlay.of(context).insert(_suggestionsOverlay);
    } else if (_overlayInserted) {
      _suggestionsOverlay.remove();
      setState(() {
        _overlayInserted = false;
      });
    }
    return 0;
  }

  Future<int> _initVariables() async {
    _intialMapLocation =
        const CameraPosition(target: LatLng(48.85902056, 2.34637398), zoom: 14);

    _googleMapsPlaces = GoogleMapsPlaces(apiKey: googleApiKey);
    _overlayInserted = false;
    _searchTextController.addListener(_onSearchChanged);
    _moovingMarker = false;
    _adressChoosen = true;

    _timeEvent = TimeOfDay.now();
    _dateEvent = DateTime.now();

    _focusNodeAdress.addListener(() {
      if (_focusNodeAdress.hasFocus) {
        print('we have the focus  ');
        setState(() {
          _adressChoosen = false;
        });
      } else {
        _throttle.cancel();
        print('we dont have the focus');
        setState(() {
          _adressChoosen = true;
        });
        if (_suggestionsOverlay != null && _overlayInserted) {
          _suggestionsOverlay.remove();
        }
        // _scrollController.animateTo(0,
        //     duration: const Duration(seconds: 1), curve: Curves.ease);
      }
    });

    return 0;
  }

/*   void _dismissDialog() {
    Navigator.pop(context);
  } */

  OverlayEntry _createOverlayButtons() {
    final RenderBox renderBox =
        _keyMap.currentContext.findRenderObject() as RenderBox;
    final Size sizeMap = renderBox.size;
    final Offset positionMap = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (BuildContext context) => Positioned(
              left: positionMap.dx,
              height: 60,
              width: sizeMap.width / 1.5,
              child: CompositedTransformFollower(
                link: _mapLink,
                showWhenUnlinked: false,
                offset: Offset(30, sizeMap.height - 100),
                child: Material(
                    color: grey,
                    elevation: 4.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          color: white,
                          // padding: const EdgeInsets.all(5),
                          onPressed: () async {
                            setState(() {
                              _moovingMarker = false;
                            });
                            if (_savedMarker != null) {
                              final String _previousAdress =
                                  await _getAdressFromCoordinates(
                                      _savedMarker.position.latitude,
                                      _savedMarker.position.longitude);
                              setState(() {
                                _positionOfPlace = _savedMarker;
                                _markers.clear();
                                _markers[_positionOfPlace.markerId.toString()] =
                                    _positionOfPlace;
                                _searchTextController.text = _previousAdress;
                              });
                              _moveCameraToPosition(
                                  _positionOfPlace.position, 15);
                            } else {
                              setState(() {
                                _markers.clear();
                                _searchTextController.text = '';
                                _positionOfPlace = null;
                              });
                            }
                            _mapButtonsOverlay.remove();
                          },
                          child: const Text('Cancel'),
                        ),
                        FlatButton(
                          color: white,
                          // padding: const EdgeInsets.all(5),
                          onPressed: () async {
                            setState(() {
                              _moovingMarker = false;
                            });
                            final String _address =
                                await _getAdressFromCoordinates(
                                    _positionOfPlace.position.latitude,
                                    _positionOfPlace.position.longitude);
                            setState(() {
                              _positionOfPlace = Marker(
                                  markerId: _positionOfPlace.markerId,
                                  position: _positionOfPlace.position,
                                  infoWindow: InfoWindow(
                                      title: 'Meeting point',
                                      snippet: _address));
                              _markers.clear();
                              _markers[_positionOfPlace.markerId.toString()] =
                                  _positionOfPlace;
                              _searchTextController.text = _address;
                            });
                            // _moveCameraToPosition(
                            //     _positionOfPlace.position, 15);
                            _mapButtonsOverlay.remove();
                          },
                          child: const Text('Ok'),
                        )
                      ],
                    )),
              ),
            ));
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox =
        _keySearch.currentContext.findRenderObject() as RenderBox;
    final Size sizeSearch = renderBox.size;
    final Offset positionSearch = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (BuildContext context) => Positioned(
            left: positionSearch.dx,
            height: 180,
            width: sizeSearch.width,
            child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, sizeSearch.height + 5.0),
                child: Material(
                    elevation: 4.0,
                    child: ListView.builder(
                        itemCount: _resultPlaces.length,
                        itemBuilder: (BuildContext context, int index) =>
                            Container(
                                child: _buildCompletionResult(index)))))));
  }

  Widget _buildCompletionResult(int index) {
    return ListTile(
        title: Text(_resultPlaces[index].name),
        onTap: () async {
          _throttle.cancel();
          setState(() {
            _adressChoosen = true;
            _searchTextController.text = _resultPlaces[index].formattedAddress;
            _overlayInserted = false;
            _choosenPlace = _resultPlaces[index];
            _positionOfPlace = Marker(
                markerId: MarkerId(_choosenPlace.id),
                position: LatLng(_choosenPlace.geometry.location.lat,
                    _choosenPlace.geometry.location.lng),
                infoWindow: InfoWindow(
                    title: 'Meeting point',
                    snippet: _choosenPlace.formattedAddress));
          });
          _markers.clear();
          _markers[_positionOfPlace.markerId.toString()] = _positionOfPlace;
          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: _positionOfPlace.position, zoom: 15)));
          _suggestionsOverlay.remove();
          _focusNodeAdress.unfocus();
        });
  }

  Widget _buildMap(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(
          height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 240,
        ),
        // decoration: const BoxDecoration(color: white),
        key: _keyMap,
        padding: const EdgeInsets.all(15),
        child: Column(children: <Widget>[
          Container(
              constraints: BoxConstraints.expand(
                height: Theme.of(context).textTheme.display1.fontSize * 1.1,
              ),
              child: RichText(
                text: const TextSpan(
                  text: 'LOUNGE DESIGNATED MEETUP',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                ),
              )),
          Expanded(
              child: CompositedTransformTarget(
                  link: _mapLink,
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
                      onLongPress: (LatLng position) async {
                        if (_moovingMarker) {
                          print('mooving marker ?  weird ');
                          return;
                        }
                        Marker tmpMarker;
                        if (_positionOfPlace != null) {
                          tmpMarker = _positionOfPlace.clone();
                        }
                        _positionOfPlace = Marker(
                            markerId: MarkerId(position.toString()),
                            position:
                                LatLng(position.latitude, position.longitude),
                            infoWindow: InfoWindow(
                                snippet: position.toString(),
                                title: 'Meeting point'));

                        final GoogleMapController controller =
                            await _controller.future;
                        // final double _zoom = await controller.getZoomLevel();
                        setState(() {
                          _moovingMarker = false;
                        });
                        controller
                            .animateCamera(CameraUpdate.newCameraPosition(
                                CameraPosition(
                                    target: _positionOfPlace.position,
                                    zoom: 15)))
                            .then((void value) async {
                          final String _address =
                              await _getAdressFromCoordinates(
                                  _positionOfPlace.position.latitude,
                                  _positionOfPlace.position.longitude);
                          setState(() {
                            if (tmpMarker != null) {
                              _savedMarker = tmpMarker;
                            }
                            _markers.clear();
                            _markers[_positionOfPlace.markerId.toString()] =
                                _positionOfPlace;
                            _mapButtonsOverlay = _createOverlayButtons();
                            _searchTextController.text = _address;
                          });
                          Timer(const Duration(milliseconds: 800), () {
                            setState(() {
                              _moovingMarker = true;
                            });
                            Overlay.of(context).insert(_mapButtonsOverlay);
                          });
                        });
                      },
                      onCameraIdle: () async {
                        if (_positionOfPlace == null || !_moovingMarker) {
                          return;
                        }
                        final String _address = await _getAdressFromCoordinates(
                            _positionOfPlace.position.latitude,
                            _positionOfPlace.position.longitude);
                        setState(() {
                          _searchTextController.text = _address;
                        });
                      },
                      onCameraMove: (CameraPosition position) {
                        if (!_moovingMarker) {
                          return;
                        }
                        _positionOfPlace = Marker(
                            markerId: MarkerId('Meeting point'),
                            position: LatLng(position.target.latitude,
                                position.target.longitude),
                            infoWindow: InfoWindow(
                                snippet: position.toString(),
                                title: 'Meeting point'));
                        setState(() {
                          _markers.clear();
                          _markers[_positionOfPlace.markerId.toString()] =
                              _positionOfPlace;
                        });
                      },
                      markers: _markers.values.toSet(),
                      initialCameraPosition: _intialMapLocation,
                      onMapCreated: (GoogleMapController controller) {
                        if (!_controller.isCompleted) {
                          _controller.complete(controller);
                        }
                      })))
        ]));
  }

  Widget _buildAdressField(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(
          height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 40,
        ),
        padding: const EdgeInsets.all(15),
        child: CompositedTransformTarget(
          child: Container(
              color: orangeLight,
              child: TextFormField(
                key: _keySearch,
                cursorColor: Colors.black,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.go,
                focusNode: _focusNodeAdress,
                controller: _searchTextController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.location_on),
                  hintText: 'Select place...',
                ),
              )),
          link: _layerLink,
        ));
  }

  Widget _buildTimeField(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 70,
      ),
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Container(
              constraints: BoxConstraints.expand(
                height: Theme.of(context).textTheme.display1.fontSize * 1.1,
              ),
              child: RichText(
                text: const TextSpan(
                  text: 'MEETUP TIME',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                ),
              )),
          Container(
              child: CompositedTransformTarget(
                  key: _keyDate,
                  link: _dateLink,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 180,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _updateTimeOfEvent();
                              },
                              child: Container(
                                color: orangeLight,
                                height: 40,
                                padding: const EdgeInsets.all(10.0),
                                child: Text(_timeEvent.hourOfPeriod.toString()),
                              ),
                            ),
                            Container(child: const Text(':')),
                            GestureDetector(
                              onTap: () {
                                _updateTimeOfEvent();
                              },
                              child: Container(
                                color: orangeLight,
                                height: 40,
                                padding: const EdgeInsets.all(10.0),
                                child: Text(_timeEvent.minute.toString()),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _updateTimeOfEvent();
                              },
                              child: Container(
                                color: orangeLight,
                                height: 40,
                                padding: const EdgeInsets.all(10.0),
                                child: Text(_timeEvent.period == DayPeriod.am
                                    ? 'AM'
                                    : 'PM'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final DateTime dateSelected = await showDatePicker(
                              context: context,
                              initialDate:
                                  DateTime.now().add(const Duration(days: 1)),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 100)));
                          if (dateSelected != null) {
                            setState(() {
                              _dateEvent = dateSelected;
                              print('on change la date : _dateEVent : ' +
                                  _dateEvent.toString());
                            });
                          }
                        },
                        child: Container(
                          color: orangeLight,
                          height: 40,
                          padding: const EdgeInsets.all(10.0),
                          child:
                              Text(DateFormat('dd-MM-yyyy').format(_dateEvent)),
                        ),
                      )
                    ],
                  )))
        ],
      ),
    );
  }

  Widget _buildNotesField(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 300,
      ),
      padding: const EdgeInsets.all(15),
      child: Column(children: <Widget>[
        Container(
            constraints: BoxConstraints.expand(
              height: Theme.of(context).textTheme.display1.fontSize * 1.1,
            ),
            child: RichText(
              text: const TextSpan(
                text: 'MEETUP TIME',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w700),
              ),
            )),
        Expanded(
            child: Container(
                padding: const EdgeInsets.all(15.0),
                color: orangeLight,
                child: TextField(
                  controller: _notesTextController,
                  focusNode: _focusNodeNotes,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Notes for your group...'),
                )))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<AppState>) dispatch,
        Widget child) {
      // setState(() {
      //   dispatch = dispatch;
      // });
      return Container(
          child: Column(
        children: <Widget>[
          _buildMap(context),
          _buildAdressField(context),
          _buildTimeField(context),
          _buildNotesField(context),
        ],
      ));
    });
  }

  Map<String, dynamic> saveMeetupOptions() {
    _focusNodeNotes.unfocus();
    _focusNodeAdress.unfocus();
    final DateTime _dateOfEvent = DateTime(_dateEvent.year, _dateEvent.month,
        _dateEvent.day, _timeEvent.hour, _timeEvent.minute);
    final GeoPoint _location = GeoPoint(_positionOfPlace.position.latitude,
        _positionOfPlace.position.longitude);
    return <String, dynamic>{
      'date': _dateOfEvent,
      'location': _location,
      'notes': _notesTextController.text
    };
  }
}
