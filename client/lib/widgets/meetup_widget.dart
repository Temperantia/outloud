import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:business/app.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:outloud/theme.dart';

const String googleApiKey =
    'AIzaSyCO8sI1kmXRQXqvwQRGrnbAW3IX-VTcCDw'; // TODO(robin): this should be somewhere else

class LoungeMeetupWidget extends StatefulWidget {
  const LoungeMeetupWidget(this.lounge, this.readMode, {Key key})
      : super(key: key);

  final Lounge lounge;
  final bool readMode;

  static const String id = 'LoungeMeetupWidget';

  @override
  LoungeMeetupWidgetState createState() => LoungeMeetupWidgetState();
}

class LoungeMeetupWidgetState extends State<LoungeMeetupWidget> {
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
    _initLounge();
    _initVariables();
  }

  @override
  void dispose() {
    _searchTextController.removeListener(_onSearchChanged);
    _searchTextController.dispose();
    super.dispose();
  }

  Future<void> _initLounge() async {
    final String _address = await _getAdressFromCoordinates(
        widget.lounge.location.latitude, widget.lounge.location.longitude);
    setState(() {
      _searchTextController.text = _address;
      _positionOfPlace = Marker(
          markerId: MarkerId(_address),
          position: LatLng(widget.lounge.location.latitude,
              widget.lounge.location.longitude),
          infoWindow: InfoWindow(
              snippet: _address,
              title: FlutterI18n.translate(
                  context, 'LOUNGE_CREATE_MEETUP.MEETING_POINT')));
      _notesTextController.text = widget.lounge.notes;
      _timeEvent = TimeOfDay.fromDateTime(widget.lounge.date);
      _dateEvent = widget.lounge.date;
      _markers.clear();
      _markers[_positionOfPlace.markerId.toString()] = _positionOfPlace;
    });
    _moveCameraToPosition(_positionOfPlace.position, 15);
  }

  Future<void> _onSearchChanged() async {
    if (_throttle?.isActive ?? false) {
      _throttle.cancel();
    }

    _throttle = Timer(const Duration(milliseconds: 500), () {
      if (!_adressChoosen) {
        _displayPrediction();
      }
    });
  }

  Future<String> _getAdressFromCoordinates(
      double latitude, double longitude) async {
    final List<Placemark> placemark = await geoLocator.placemarkFromCoordinates(
        latitude, longitude); // TODO(robin): exception here
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
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child);
        });
    if (timeSelected != null) {
      setState(() => _timeEvent = timeSelected);
    }
    return 0;
  }

  Future<void> _moveCameraToPosition(LatLng position, double zoom) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: zoom)));
  }

  Future<void> _displayPrediction() async {
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
      setState(() => _overlayInserted = false);
    }
  }

  Future<void> _initVariables() async {
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
        setState(() => _adressChoosen = false);
      } else {
        _throttle.cancel();
        setState(() => _adressChoosen = true);
        if (_suggestionsOverlay != null && _overlayInserted) {
          _suggestionsOverlay.remove();
        }
        // _scrollController.animateTo(0,
        //     duration: const Duration(seconds: 1), curve: Curves.ease);
      }
    });
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
                                setState(() => _moovingMarker = false);
                                if (_savedMarker != null) {
                                  final String _previousAdress =
                                      await _getAdressFromCoordinates(
                                          _savedMarker.position.latitude,
                                          _savedMarker.position.longitude);
                                  setState(() {
                                    _positionOfPlace = _savedMarker;
                                    _markers.clear();
                                    _markers[_positionOfPlace.markerId
                                        .toString()] = _positionOfPlace;
                                    _searchTextController.text =
                                        _previousAdress;
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
                              child: Text(FlutterI18n.translate(
                                  context, 'LOUNGE_CREATE_MEETUP.CANCEL'))),
                          FlatButton(
                              color: white,
                              // padding: const EdgeInsets.all(5),
                              onPressed: () async {
                                setState(() => _moovingMarker = false);
                                final String _address =
                                    await _getAdressFromCoordinates(
                                        _positionOfPlace.position.latitude,
                                        _positionOfPlace.position.longitude);
                                setState(() {
                                  _positionOfPlace = Marker(
                                      markerId: _positionOfPlace.markerId,
                                      position: _positionOfPlace.position,
                                      infoWindow: InfoWindow(
                                          title: FlutterI18n.translate(context,
                                              'LOUNGE_CREATE_MEETUP.MEETING_POINT'),
                                          snippet: _address));
                                  _markers.clear();
                                  _markers[_positionOfPlace.markerId
                                      .toString()] = _positionOfPlace;
                                  _searchTextController.text = _address;
                                });
                                // _moveCameraToPosition(
                                //     _positionOfPlace.position, 15);
                                _mapButtonsOverlay.remove();
                              },
                              child: Text(FlutterI18n.translate(
                                  context, 'LOUNGE_CREATE_MEETUP.OK')))
                        ])))));
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
                            _buildCompletionResult(index))))));
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
                    title: FlutterI18n.translate(
                        context, 'LOUNGE_CREATE_MEETUP.MEETING_POINT'),
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
              child: Text(
                  FlutterI18n.translate(
                      context, 'LOUNGE_CREATE_MEETUP.LOUNGE_DESIGNATED_MEETUP'),
                  style: const TextStyle(
                      color: black,
                      fontSize: 15,
                      fontWeight: FontWeight.w700))),
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
                            () => EagerGestureRecognizer())
                      },
                      onLongPress: (LatLng position) async {
                        if (widget.readMode) {
                          return;
                        }
                        if (_moovingMarker) {
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
                                title: FlutterI18n.translate(context,
                                    'LOUNGE_CREATE_MEETUP.MEETING_POINT')));

                        final GoogleMapController controller =
                            await _controller.future;
                        // final double _zoom = await controller.getZoomLevel();
                        setState(() => _moovingMarker = false);
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
                            setState(() => _moovingMarker = true);
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
                        setState(() => _searchTextController.text = _address);
                      },
                      onCameraMove: (CameraPosition position) {
                        if (!_moovingMarker) {
                          return;
                        }
                        _positionOfPlace = Marker(
                            markerId: MarkerId(FlutterI18n.translate(
                                context, 'LOUNGE_CREATE_MEETUP.MEETING_POINT')),
                            position: LatLng(position.target.latitude,
                                position.target.longitude),
                            infoWindow: InfoWindow(
                                snippet: position.toString(),
                                title: FlutterI18n.translate(context,
                                    'LOUNGE_CREATE_MEETUP.MEETING_POINT')));
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
                    readOnly: widget.readMode,
                    key: _keySearch,
                    cursorColor: black,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.go,
                    focusNode: _focusNodeAdress,
                    controller: _searchTextController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.location_on),
                        hintText: FlutterI18n.translate(
                            context, 'LOUNGE_CREATE_MEETUP.SELECT_PLACE')))),
            link: _layerLink));
  }

  Widget _buildTimeField(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(
          height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 70,
        ),
        padding: const EdgeInsets.all(15.0),
        child: Column(children: <Widget>[
          Container(
              constraints: BoxConstraints.expand(
                  height: Theme.of(context).textTheme.display1.fontSize * 1.1),
              child: Text(
                  FlutterI18n.translate(
                      context, 'LOUNGE_CREATE_MEETUP.MEETUP_TIME'),
                  style: const TextStyle(
                      color: black,
                      fontSize: 15,
                      fontWeight: FontWeight.w700))),
          CompositedTransformTarget(
              key: _keyDate,
              link: _dateLink,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        width: 180,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GestureDetector(
                                  onTap: () {
                                    if (widget.readMode) {
                                      return;
                                    }
                                    _updateTimeOfEvent();
                                  },
                                  child: Container(
                                      color: orangeLight,
                                      height: 40,
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                          _timeEvent.hour.toString()))),
                              const Text(':'),
                              GestureDetector(
                                  onTap: () {
                                    if (widget.readMode) {
                                      return;
                                    }
                                    _updateTimeOfEvent();
                                  },
                                  child: Container(
                                      color: orangeLight,
                                      height: 40,
                                      padding: const EdgeInsets.all(10.0),
                                      child:
                                          Text(_timeEvent.minute.toString())))
                            ])),
                    GestureDetector(
                        onTap: () async {
                          if (widget.readMode) {
                            return;
                          }
                          final DateTime dateSelected = await showDatePicker(
                              context: context,
                              initialDate:
                                  DateTime.now().add(const Duration(days: 1)),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 100)));
                          if (dateSelected != null) {
                            setState(() => _dateEvent = dateSelected);
                          }
                        },
                        child: Container(
                            color: orangeLight,
                            height: 40,
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                                DateFormat('dd-MM-yyyy').format(_dateEvent))))
                  ]))
        ]));
  }

  Widget _buildNotesField(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(
            height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 300),
        padding: const EdgeInsets.all(15),
        child: Column(children: <Widget>[
          Container(
              constraints: BoxConstraints.expand(
                  height: Theme.of(context).textTheme.display1.fontSize * 1.1),
              child: Text(
                  FlutterI18n.translate(
                      context, 'LOUNGE_CREATE_MEETUP.MEETUP_NOTES'),
                  style: const TextStyle(
                      color: black,
                      fontSize: 15,
                      fontWeight: FontWeight.w700))),
          Expanded(
              child: Container(
                  padding: const EdgeInsets.all(15.0),
                  color: orangeLight,
                  child: TextField(
                      readOnly: widget.readMode,
                      controller: _notesTextController,
                      focusNode: _focusNodeNotes,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: FlutterI18n.translate(context,
                              'LOUNGE_CREATE_MEETUP.NOTES_FOR_GROUP')))))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<AppState>) dispatch,
        Widget child) {
      return Column(children: <Widget>[
        _buildMap(context),
        _buildAdressField(context),
        _buildTimeField(context),
        _buildNotesField(context),
      ]);
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
