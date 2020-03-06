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

  final Map<String, Marker> _markers = <String, Marker>{};
  Marker _positionOfPlace;

  bool _adressChoosen;

  List<PlacesSearchResult> _resultPlaces = <PlacesSearchResult>[];
  final FocusNode _focusNodeAdress = FocusNode();
  OverlayEntry _suggestionsOverlay;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _keySearch = GlobalKey();
  final TextEditingController _searchTextController = TextEditingController();
  Timer _throttle;

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
    // if (_suggestionsOverlay != null) {
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
      }
    });
    _adressChoosen = false;
    return 0;
  }

  @override
  void dispose() {
    _searchTextController.removeListener(_onSearchChanged);
    _searchTextController.dispose();
    super.dispose();
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
              CameraPosition(target: _positionOfPlace.position, zoom: 20)));
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
        padding: const EdgeInsets.all(15),
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
                  markers: _markers.values.toSet(),
                  initialCameraPosition: _intialMapLocation,
                  onMapCreated: (GoogleMapController controller) {
                    if (!_controller.isCompleted) {
                      _controller.complete(controller);
                    }
                  }))
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
