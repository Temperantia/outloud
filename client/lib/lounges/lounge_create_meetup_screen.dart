import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:geolocator/geolocator.dart';

import '../theme.dart';

const String googleApiKey = 'AIzaSyCO8sI1kmXRQXqvwQRGrnbAW3IX-VTcCDw';

class LoungeCreateMeetupScreen extends StatefulWidget {
  static const String id = 'LoungeCreateMeetupScreen';

  @override
  _LoungeCreateMeetupScreenState createState() =>
      _LoungeCreateMeetupScreenState();
}

class _LoungeCreateMeetupScreenState extends State<LoungeCreateMeetupScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final ScrollController _scrollController = ScrollController();
  final Map<String, Marker> _markers = <String, Marker>{};
  final FocusNode _focusNodeAdress = FocusNode();
  final LayerLink _layerLink = LayerLink();
  final LayerLink _mapLink = LayerLink();
  final GlobalKey _keySearch = GlobalKey();
  final GlobalKey _keyMap = GlobalKey();
  final TextEditingController _searchTextController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    _initVariables();
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
        _scrollController.animateTo(0,
            duration: const Duration(seconds: 1), curve: Curves.ease);
      }
    });
    return 0;
  }

  @override
  void dispose() {
    _searchTextController.removeListener(_onSearchChanged);
    _searchTextController.dispose();
    super.dispose();
  }

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
                            setState(() {
                              _moovingMarker = false;
                            });
                            _mapButtonsOverlay.remove();
                          },
                          child: const Text('Cancel'),
                        ),
                        FlatButton(
                          color: white,
                          // padding: const EdgeInsets.all(5),
                          onPressed: () async {
                            final String _address =
                                await _getAdressFromCoordinates(
                                    _positionOfPlace.position.latitude,
                                    _positionOfPlace.position.longitude);
                            setState(() {
                              _moovingMarker = false;
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
                            _moveCameraToPosition(
                                _positionOfPlace.position, 15);
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
          height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 300,
        ),
        decoration: const BoxDecoration(color: white),
        key: _keyMap,
        padding: const EdgeInsets.all(5),
        child: Column(children: <Widget>[
          Container(
              constraints: BoxConstraints.expand(
                height: Theme.of(context).textTheme.display1.fontSize * 1.1,
              ),
              child: RichText(
                text: TextSpan(
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
                        print('start selecting a place at position ' +
                            position.toString());
                        if (_moovingMarker) {
                          print('on est deja en train de positioner le truc');
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
                        final double _zoom = await controller.getZoomLevel();
                        setState(() {
                          _moovingMarker = false;
                        });
                        controller
                            .animateCamera(CameraUpdate.newCameraPosition(
                                CameraPosition(
                                    target: _positionOfPlace.position,
                                    zoom: _zoom)))
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
                          Overlay.of(context).insert(_mapButtonsOverlay);
                          Timer(const Duration(milliseconds: 1200), () {
                            setState(() {
                              _moovingMarker = true;
                            });
                          });
                        });
                      },
                      onCameraMoveStarted: () {
                        print('start moving camera');
                      },
                      onCameraIdle: () async {
                        print('stop moving camera');
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
        color: blue,
        constraints: BoxConstraints.expand(
          height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 40,
        ),
        child: Padding(
            padding: const EdgeInsets.all(15),
            child: CompositedTransformTarget(
              child: TextFormField(
                key: _keySearch,
                cursorColor: Colors.black,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.go,
                focusNode: _focusNodeAdress,
                controller: _searchTextController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Select place...',
                ),
              ),
              link: _layerLink,
            )));
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
          title: 'CREATE LOUNGE',
          onBack: () => Navigator.popUntil(
              context, (Route<dynamic> route) => route.isFirst),
          backIcon: Icons.close,
          child: Container(
              constraints: const BoxConstraints.expand(
                  // width: MediaQuery.of(context).size.width
                  ),
              child: Container(
                  color: white,
                  child: Scrollbar(
                      child: ListView(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(10),
                          children: <Widget>[
                        _buildMap(context),
                        _buildAdressField(context),
                        _buildTimeField(context),
                        _buildNotesField(context)
                      ])))));
    });
  }
}
