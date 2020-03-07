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
  CameraPosition _intialMapLocation;
  GoogleMapsPlaces _googleMapsPlaces;
  PlacesSearchResult _choosenPlace;

  final ScrollController _scrollController = ScrollController();

  final Map<String, Marker> _markers = <String, Marker>{};
  Marker _positionOfPlace;
  Marker _savedMarker;

  LatLng _referencePosition;

  bool _adressChoosen;

  bool _firstMove;
  bool _moovingMarker;

  List<PlacesSearchResult> _resultPlaces = <PlacesSearchResult>[];
  final FocusNode _focusNodeAdress = FocusNode();
  OverlayEntry _suggestionsOverlay;
  OverlayEntry _mapButtonsOverlay;

  final LayerLink _layerLink = LayerLink();
  final LayerLink _mapLink = LayerLink();
  final GlobalKey _keySearch = GlobalKey();
  final GlobalKey _keyMap = GlobalKey();
  final TextEditingController _searchTextController = TextEditingController();
  Timer _throttle;
  Timer _moveDelay;
  bool _movingCamera;

  bool _overlayInserted;

  @override
  void initState() {
    super.initState();
    _initVariables();
  }

  Future<Null> _onSearchChanged() async {
    if (_throttle?.isActive ?? false) {
      _throttle.cancel();
    }

    _throttle = Timer(const Duration(milliseconds: 500), () {
      if (!_adressChoosen) {
        _displayPrediction();
      }
    });
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
    _firstMove = true;
    _moovingMarker = false;
    _movingCamera = false;
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
                            setState(() {
                              _firstMove = true;
                              if (_savedMarker != null) {
                                _positionOfPlace = _savedMarker;
                                _markers.clear();
                                _markers[_positionOfPlace.markerId.toString()] =
                                    _positionOfPlace;
                              } else {
                                _markers.clear();
                              }
                              _moovingMarker = false;
                              _movingCamera = false;
                            });
                            final GoogleMapController controller =
                                await _controller.future;
                            controller.animateCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                                    target: _positionOfPlace.position,
                                    zoom: 15)));
                            _mapButtonsOverlay.remove();
                          },
                          child: const Text('Cancel'),
                        ),
                        FlatButton(
                          color: white,
                          // padding: const EdgeInsets.all(5),
                          onPressed: () async {
                            setState(() {
                              _firstMove = true;
                              // if (_savedMarker != null) {
                              //   _positionOfPlace = _savedMarker;
                              //   _markers.clear();
                              //   _markers[_positionOfPlace.markerId.toString()] =
                              //       _positionOfPlace;
                              // }
                              _moovingMarker = false;
                              _movingCamera = false;
                            });
                            final List<Placemark> placemark = await Geolocator()
                                .placemarkFromCoordinates(
                                    _positionOfPlace.position.latitude,
                                    _positionOfPlace.position.longitude);
                            print('loook he places : ' + placemark.toString());
                            if (placemark.isNotEmpty) {
                              final Placemark _place = placemark.first;
                              final String _address = _place.subThoroughfare +' ' +
                                  _place.thoroughfare + ' ' + 
                                  _place.postalCode.toString() + ' ' +
                                  _place.locality;
                              print('_place adress : ' + _address);
                              setState(() {
                                _positionOfPlace = Marker(
                                  markerId: _positionOfPlace.markerId, 
                                  position: _positionOfPlace.position,
                                  infoWindow:InfoWindow(title: 'meeting point', snippet: _address) );
                                _markers.clear();
                                _markers[_positionOfPlace.markerId.toString()] = _positionOfPlace;
                                _searchTextController.text = _address;
                              });
                            }

                            final GoogleMapController controller =
                                await _controller.future;
                            controller.animateCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                                    target: _positionOfPlace.position,
                                    zoom: 15)));
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
                    title: _choosenPlace.name,
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
                                title: 'meeting point'));

                        final GoogleMapController controller =
                            await _controller.future;
                        final double _zoom = await controller.getZoomLevel();
                        setState(() {
                          _moovingMarker = false;
                          _movingCamera = true;
                        });
                        controller
                            .animateCamera(CameraUpdate.newCameraPosition(
                                CameraPosition(
                                    target: _positionOfPlace.position,
                                    zoom: _zoom)))
                            .then((void value) {
                          setState(() {
                            if (tmpMarker != null) {
                                _savedMarker = tmpMarker;
                            }
                            _markers.clear();
                            _markers[_positionOfPlace.markerId.toString()] =
                                _positionOfPlace;
                            _mapButtonsOverlay = _createOverlayButtons();
                          });
                          Overlay.of(context).insert(_mapButtonsOverlay);
                          _moveDelay =
                              Timer(const Duration(milliseconds: 1200), () {
                            setState(() {
                              _moovingMarker = true;
                              _movingCamera = false;
                            });
                          });
                        });
                      },
                      onCameraMoveStarted: () {
                        print('on commence a bouger');
                      },
                      onCameraIdle: () {
                        print('stop moving camera ');
                      },
                      onCameraMove: (CameraPosition position) {
                        if (!_moovingMarker) {
                          return;
                        }
                        if (_firstMove) {
                          print('first real move');
                          setState(() {
                            _referencePosition = position.target;
                            _firstMove = false;
                          });
                          return;
                        }

                        _positionOfPlace = Marker(
                            markerId: MarkerId('meeting point'),
                            position: LatLng(position.target.latitude,
                                position.target.longitude),
                            infoWindow: InfoWindow(
                                snippet: position.toString(),
                                title: 'meeting point'));
                        setState(() {
                          _referencePosition = position.target;
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
