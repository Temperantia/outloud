import 'dart:async';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:business/app_state.dart';
import 'package:async_redux/async_redux.dart'
    show ReduxAction, NavigateAction, Store;
import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/message.dart';
import 'package:business/classes/user.dart';
import 'package:business/events/actions/event_like_action.dart';
import 'package:business/events/actions/event_unlike_action.dart';
import 'package:business/events/actions/event_register_action.dart';
import 'package:business/events/actions/event_unregister_action.dart';
import 'package:business/lounges/actions/lounge_remove_action.dart';
import 'package:business/lounges/actions/lounge_kick_user_action.dart';
import 'package:business/lounges/actions/lounge_leave_action.dart';
import 'package:business/models/event_message.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:outloud/events/event_attending_screen.dart';
import 'package:outloud/lounges/lounge_chat_screen.dart';
import 'package:outloud/lounges/lounges_screen.dart';
import 'package:outloud/theme.dart';
import 'package:expandable/expandable.dart';
import 'package:outloud/widgets/cached_image.dart';
import 'package:outloud/widgets/view.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class EventScreen extends StatefulWidget {
  const EventScreen(this.event);

  final Event event;
  static const String id = 'EventScreen';

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen>
    with TickerProviderStateMixin {
  void Function(ReduxAction<AppState>) _dispatch;
  Future<void> Function(ReduxAction<AppState>) _dispatchFuture;
  /*  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>(); */
  /* final Map<String, Marker> _markers = <String, Marker>{}; */
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _feedEventScrollController = ScrollController();

/*   CameraPosition _intialMapLocation;
  String _adressEvent; */
/*   double _latitude;
  double _longitude; */
  bool _doubleClickingGuard;

  @override
  void initState() {
    super.initState();
    /* _adressEvent = '';
    _latitude = widget.event.location != null
        ? widget.event.location.latitude
        : 48.859305;
    _longitude = widget.event.location != null
        ? widget.event.location.longitude
        : 2.294348;
    _intialMapLocation =
        CameraPosition(target: LatLng(_latitude, _longitude), zoom: 14);
    _markers.clear();
    _markers[widget.event.id] = Marker(
        markerId: MarkerId(widget.event.id),
        position: LatLng(_latitude, _longitude),
        infoWindow: InfoWindow(title: widget.event.name)); */
    // _resolveAdressEvent();
    _doubleClickingGuard = false;
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _feedEventScrollController.dispose();
    super.dispose();
  }

  Future<void> _sendImage(String userId) async {
    try {
      final Uint8List image =
          (await (await MultiImagePicker.pickImages(maxImages: 1))[0]
                  .getByteData())
              .buffer
              .asUint8List();
      final StorageReference ref = FirebaseStorage.instance
          .ref()
          .child('images/events/${widget.event.id}/${DateTime.now()}');
      final StorageUploadTask uploadTask = ref.putData(image);
      final StorageTaskSnapshot result = await uploadTask.onComplete;
      final String url = (await result.ref.getDownloadURL()).toString();
      addEventMessage(widget.event.id, userId, url, MessageType.Image);
    } catch (error) {
      return;
    }
  }

  void _showConfirmPopup(String userId, List<Lounge> lounges) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Stack(children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              offset: const Offset(0.0, 10.0))
                        ]),
                    child: Column(mainAxisSize: MainAxisSize.min, children: <
                        Widget>[
                      const Icon(
                        MdiIcons.handRight,
                        color: pink,
                        size: 60,
                      ),
                      AutoSizeText(
                          FlutterI18n.translate(context, 'EVENT.HOLD_UP'),
                          style: const TextStyle(
                              color: pink,
                              fontSize: 28,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 15),
                      Container(
                          padding: const EdgeInsets.only(
                              left: 18, right: 18, bottom: 10),
                          child: AutoSizeText(
                              FlutterI18n.translate(
                                  context, 'EVENT.UNATTEND_WARNING'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: pink,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500))),
                      Container(
                          padding: const EdgeInsets.only(
                              left: 18, right: 18, bottom: 15),
                          child: AutoSizeText(
                              FlutterI18n.translate(context, 'EVENT.CONTINUE'),
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                  color: pink,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500))),
                      SizedBox(
                          child: Container(
                              color: pink,
                              child: Column(children: <Widget>[
                                Container(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: FlatButton(
                                          color: white,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: AutoSizeText(
                                                  FlutterI18n.translate(context,
                                                      'EVENT.TAKE_ME_BACK'),
                                                  style: const TextStyle(
                                                      color: pink,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500)))),
                                    )),
                                Container(
                                    padding: const EdgeInsets.only(
                                        bottom: 5, top: 5),
                                    child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: FlatButton(
                                            onPressed: () async {
                                              /* await showLoaderAnimation(
                                                  context, this,
                                                  animationDuration: 600); */
                                              Navigator.pop(context);
                                              _dispatch(EventUnRegisterAction(
                                                  widget.event));
                                              final Lounge _lounge =
                                                  lounges.firstWhere(
                                                      (Lounge lounge) =>
                                                          lounge.eventId ==
                                                          widget.event.id,
                                                      orElse: () => null);
                                              if (_lounge != null) {
                                                if (_lounge.owner == userId) {
                                                  for (final String memberId
                                                      in _lounge.memberIds) {
                                                    await _dispatchFuture(
                                                        LoungeKickUserAction(
                                                            memberId, _lounge));
                                                  }
                                                  _dispatch(LoungeRemoveAction(
                                                      _lounge));
                                                } else {
                                                  _dispatch(LoungeLeaveAction(
                                                      userId, _lounge));
                                                }
                                              }
                                            },
                                            child: AutoSizeText(
                                                FlutterI18n.translate(
                                                    context, 'EVENT.UNATTEND'),
                                                style: const TextStyle(
                                                    color: white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500)))))
                              ])))
                    ]))
              ]));
        });
  }

  void _showInfoPopup() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Stack(children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: const Offset(0.0, 10.0),
                          )
                        ]),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(
                            MdiIcons.glassCocktail,
                            color: white,
                            size: 60,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          AutoSizeText(
                              FlutterI18n.translate(
                                  context, 'EVENT.LOUNGES_AVAILABLE'),
                              style: const TextStyle(
                                  color: white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 18, right: 18, bottom: 10),
                            child: AutoSizeText(
                                FlutterI18n.translate(context, 'EVENT.JOINING'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                          ),
                          SizedBox(
                              child: GestureDetector(
                                  onTap: () {
                                    // setState(() => _doubleClickingGuard = false);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                      color: white,
                                      child: Column(children: <Widget>[
                                        Container(
                                            padding: const EdgeInsets.all(15),
                                            child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                    FlutterI18n.translate(
                                                        context,
                                                        'EVENT.GOT_IT'),
                                                    style: const TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w600))))
                                      ]))))
                        ]))
              ]));
        });
  }

/*   Future<int> _resolveAdressEvent() async {
    final List<Placemark> placemark =
        await geoLocator.placemarkFromCoordinates(_latitude, _longitude);
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
    setState(() => _adressEvent = _address);
    return 0;
  } */

  Widget _buildEventInfo(String userId, bool isUserAttending,
      List<Lounge> lounges, Map<String, List<Lounge>> eventLounges) {
    return Column(children: <Widget>[
      Stack(alignment: Alignment.center, children: <Widget>[
        Row(children: <Widget>[
          Expanded(
              child: CachedImage(widget.event.pic,
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
                          child: AutoSizeText(
                              widget.event.dateStart.day.toString(),
                              style: const TextStyle(
                                  color: white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700))),
                      Padding(
                          padding: const EdgeInsets.all(5),
                          child: AutoSizeText(
                              DateFormat('MMM').format(widget.event.dateStart),
                              style: const TextStyle(
                                  color: white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700)))
                    ]))),
            Expanded(
                flex: 5,
                child: Container(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: AutoSizeText(widget.event.name,
                        style: const TextStyle(
                            color: white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700))))
          ]),
          /*  GestureDetector(
              onTap: () async {
                final GoogleMapController controller = await _controller.future;
                controller.animateCamera(
                    CameraUpdate.newCameraPosition(_intialMapLocation));
              },
              child: Row(children: <Widget>[
                Icon(Icons.location_on, color: pink),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: AutoSizeText(_adressEvent,
                        style: const TextStyle(
                            color: white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)))
              ])), */
        ])
      ]),
      Container(
          height: 85.0,
          margin: const EdgeInsets.all(10),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(right: 5.0),
                        decoration:
                            BoxDecoration(border: Border.all(color: pinkLight)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              AutoSizeText(
                                  '${DateFormat('jm').format(widget.event.dateStart)} -',
                                  style: const TextStyle(
                                      color: pinkLight,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900)),
                              AutoSizeText(
                                  DateFormat('jm').format(widget.event.dateEnd),
                                  style: const TextStyle(
                                      color: pinkLight,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900))
                            ]))),
                _buildLoungeButton(isUserAttending, lounges, eventLounges),
                _buildAttendingButton(userId, isUserAttending, lounges)
              ])),
      Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Wrap(children: <Widget>[
                  for (final String interest in widget.event.interests)
                    Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(5),
                        decoration:
                            BoxDecoration(border: Border.all(color: pinkLight)),
                        child: AutoSizeText(interest,
                            style: const TextStyle(
                                color: pink,
                                fontSize: 14,
                                fontWeight: FontWeight.w600))),
                ])
              ]))
    ]);
  }

  Widget _buildLoungeButton(bool isUserAttending, List<Lounge> lounges,
      Map<String, List<Lounge>> eventLounges) {
    Widget w;
    final Lounge userLounge = lounges.firstWhere(
        (Lounge lounge) => lounge.eventId == widget.event.id,
        orElse: () => null);

    if (userLounge != null) {
      w = Container(
          margin: const EdgeInsets.only(right: 5.0),
          color: blueDark,
          child: InkWell(
              onTap: () => _dispatch(NavigateAction<AppState>.pushNamed(
                  LoungeChatScreen.id,
                  arguments: userLounge)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        width: 20.0,
                        height: 20.0,
                        child: Image.asset('images/iconLounge.png')),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          AutoSizeText(
                              FlutterI18n.translate(context, 'EVENT.VIEW_MY'),
                              style: const TextStyle(
                                  color: white, fontWeight: FontWeight.bold)),
                          AutoSizeText(
                              FlutterI18n.translate(context, 'EVENT.LOUNGE'),
                              style: const TextStyle(
                                  color: white, fontWeight: FontWeight.bold)),
                        ]),
                  ])));
    } else if (isUserAttending) {
      final List<Lounge> lounges = eventLounges[widget.event.id];
      w = Container(
          margin: const EdgeInsets.only(right: 5.0),
          color: pinkLight,
          child: InkWell(
              onTap: () => _dispatch(NavigateAction<AppState>.pushNamed(
                  LoungesScreen.id,
                  arguments: widget.event)),
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
                          AutoSizeText(
                              lounges == null ? '0' : lounges.length.toString(),
                              style: const TextStyle(
                                  color: white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                        ]),
                    Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: AutoSizeText(
                            'LOUNGE${lounges == null || lounges.length <= 1 ? '' : 'S'}',
                            style: const TextStyle(
                                color: white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400)))
                  ])));
    } else {
      w = Container(
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
                      AutoSizeText(
                          FlutterI18n.translate(context, 'EVENT.ATTEND'),
                          style: const TextStyle(
                              color: white, fontWeight: FontWeight.bold)),
                    ]),
                AutoSizeText(
                    FlutterI18n.translate(context, 'EVENT.FOR_LOUNGES'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: white)),
              ]));
    }
    return Expanded(child: w);
  }

  Widget _buildAttendingButton(
      String userId, bool isUserAttending, List<Lounge> lounges) {
    return Expanded(
        child: isUserAttending
            ? Row(children: <Widget>[
                Expanded(
                    child: Container(
                        color: orange,
                        padding: const EdgeInsets.all(5),
                        child: GestureDetector(
                            onTap: () => _showConfirmPopup(userId, lounges),
                            // TODO(alexandre): to unattend an event, you need not to have a lounge, so if that's the case, toast a msg about it and/or disable it,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Stack(
                                      alignment: Alignment.center,
                                      children: const <Widget>[
                                        Icon(Icons.check, color: white),
                                        Icon(Icons.not_interested, color: pink)
                                      ])
                                ])))),
                Expanded(
                    flex: 3,
                    child: GestureDetector(
                        onTap: () => _dispatch(
                            NavigateAction<AppState>.pushNamed(
                                EventAttendingScreen.id,
                                arguments: widget.event)),
                        child: Container(
                            color: pink,
                            padding: const EdgeInsets.all(5),
                            child: Column(children: <Widget>[
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    const Icon(Icons.person, color: white),
                                    AutoSizeText(
                                        widget.event.memberIds.length
                                            .toString(),
                                        style: const TextStyle(color: white))
                                  ]),
                              AutoSizeText(
                                  FlutterI18n.translate(
                                      context, 'EVENT.VIEW_LIST'),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400))
                            ]))))
              ])
            : Container(
                padding: const EdgeInsets.all(5),
                color: orange,
                child: IgnorePointer(
                    ignoring: _doubleClickingGuard,
                    child: InkWell(
                        onTap: () {
                          setState(() => _doubleClickingGuard = true);
                          if (!widget.event.likes.contains(userId)) {
                            _dispatch(EventLikeAction(widget.event));
                          }
                          _dispatch(EventRegisterAction(widget.event));
                          _showInfoPopup();
                        },
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    const Icon(Icons.check,
                                        color: white, size: 16),
                                    AutoSizeText(
                                        widget.event.memberIds.length
                                            .toString(),
                                        style: const TextStyle(
                                            color: white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400))
                                  ]),
                              AutoSizeText(
                                  FlutterI18n.translate(
                                      context, 'EVENT.ATTENDING'),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400))
                            ])))));
  }

  Widget _buildDescription() {
    return ExpandablePanel(
        header: Container(
          color: orange,
          padding: const EdgeInsets.all(10),
          child: AutoSizeText(
              FlutterI18n.translate(context, 'EVENT.EVENT_DESCRIPTION'),
              style: const TextStyle(
                  color: white, fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        theme: const ExpandableThemeData(iconColor: orange),
        expanded: Container(
            padding: const EdgeInsets.all(20.0),
            child: AutoSizeText(widget.event.description, softWrap: true)));
  }

  /*  Widget _buildBanner() {
    return Row(children: <Widget>[
      Expanded(
          child: GestureDetector(
              child: Container(
                  height: 160.0,
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
                            () => EagerGestureRecognizer())
                      },
                      initialCameraPosition: _intialMapLocation,
                      markers: _markers.values.toSet(),
                      onMapCreated: (GoogleMapController controller) {
                        if (!_controller.isCompleted) {
                          _controller.complete(controller);
                        }
                      }))))
    ]);
  } */

/*   Widget _buildLiveFeedSponsor() {
    return Container(
        color: Colors.grey[400],
        child: Row(children: <Widget>[
          Expanded(
              child: Container(
                  margin: const EdgeInsets.all(5),
                  child: const AutoSizeText('LIVE FEED',
                      style: TextStyle(
                          color: blueDark,
                          fontSize: 28,
                          fontWeight: FontWeight.w900)))),
          Expanded(
              flex: 3,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    AutoSizeText('Sponsored by : Best event provider',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                    AutoSizeText('https://www.sponsor-best.com',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: blueDark,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                    AutoSizeText('Twitter / Facebook / @BestEvent',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: blueDark,
                            fontSize: 15,
                            fontWeight: FontWeight.w700))
                  ]))
        ]));
  } */

  Widget _buildLiveFeed() {
    if (widget.event.chatMembers == null) {
      return Container(width: 0.0, height: 0.0);
    }

    return GestureDetector(
        // onVerticalDragCancel: () {
        //   if (_feedEventScrollController.offset == 0.0)  {
        //  _scrollController
        //         .jumpTo(_scrollController.position.minScrollExtent);

        //   } else {
        //  _scrollController
        //         .jumpTo(_scrollController.position.maxScrollExtent);
        //   }
        // },
        child: Container(
            height: 280,
            child: ListView.builder(
                controller: _feedEventScrollController,
                reverse: false,
                itemCount: widget.event.messages.length,
                itemBuilder: (BuildContext context, int index) =>
                    _buildMessage(widget.event.messages[index]))));
  }

  Widget _buildMessage(Message message) {
    final User user = widget.event.chatMembers.firstWhere(
        (User user) => user.id == message.idFrom,
        orElse: () => null);
    final String date = DateFormat('yyyy-MM-dd \'at\' kk:mm')
        .format(DateTime.fromMillisecondsSinceEpoch(message.timestamp));
    if (user == null) {
      return Container(width: 0.0, height: 0.0);
    }
    return message.messageType == MessageType.Text
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: <Widget>[
              CachedImage(user.pics.isEmpty ? null : user.pics[0],
                  width: 30.0,
                  height: 30.0,
                  borderRadius: BorderRadius.circular(20.0),
                  imageType: ImageType.User),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AutoSizeText(user.name,
                                style: const TextStyle(
                                    color: blueDark,
                                    fontWeight: FontWeight.bold)),
                            AutoSizeText(message.content,
                                style: const TextStyle(color: blueDark))
                          ]))),
              AutoSizeText(date, style: const TextStyle(color: blueDark))
            ]))
        : Row(children: <Widget>[
            Expanded(
                child: Column(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: <Widget>[
                    CachedImage(user.pics.isEmpty ? null : user.pics[0],
                        width: 30.0,
                        height: 30.0,
                        borderRadius: BorderRadius.circular(20.0),
                        imageType: ImageType.User),
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  AutoSizeText(user.name,
                                      style: const TextStyle(
                                          color: blueDark,
                                          fontWeight: FontWeight.bold))
                                ]))),
                    AutoSizeText(date, style: const TextStyle(color: blueDark))
                  ])),
              Row(children: <Widget>[
                Expanded(
                    child: CachedImage(message.content,
                        fit: BoxFit.cover, imageType: ImageType.Event))
              ])
            ]))
          ]);
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<AppState>) dispatch,
        Widget child) {
      _dispatch = dispatch;
      final String userId = state.userState.user.id;
      final bool isUserAttending =
          state.userState.user.isAttendingEvent(widget.event.id);
      return View(
          title: FlutterI18n.translate(context, 'EVENT.EVENT_DETAILS'),
          actions: widget.event == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                      onTap: () {
                        if (widget.event.likes.contains(userId)) {
                          dispatch(EventUnlikeAction(widget.event));
                        } else {
                          dispatch(EventLikeAction(widget.event));
                        }
                      },
                      child: Row(children: <Widget>[
                        if (widget.event.likes.contains(userId))
                          const Icon(MdiIcons.heart, color: white)
                        else
                          const Icon(Icons.favorite_border, color: white),
                        Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: AutoSizeText(
                                widget.event.likes.length.toString(),
                                style: const TextStyle(color: white)))
                      ]))),
          buttons: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                  color: orangeLight.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(5.0)),
              child: Row(children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {
                          _sendImage(userId);
                          _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent);
                          Timer(
                              const Duration(milliseconds: 250),
                              () => _feedEventScrollController.jumpTo(
                                  _feedEventScrollController
                                      .position.maxScrollExtent));
                        },
                        child: Icon(Icons.panorama, color: white))),
                Expanded(
                    child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration.collapsed(
                            hintText:
                                FlutterI18n.translate(context, 'EVENT.MESSAGE'),
                            hintStyle: const TextStyle(color: white)))),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {
                          addEventMessage(widget.event.id, userId,
                              _messageController.text.trim(), MessageType.Text);
                          _messageController.clear();
                          _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent);
                          Timer(
                              const Duration(milliseconds: 250),
                              () => _feedEventScrollController.jumpTo(
                                  _feedEventScrollController
                                      .position.maxScrollExtent));
                        },
                        child: Icon(Icons.send, color: white)))
              ])),
          child: widget.event == null
              ? const CircularProgressIndicator()
              : ListView(controller: _scrollController, children: <Widget>[
                  _buildEventInfo(userId, isUserAttending,
                      state.userState.lounges, state.userState.eventLounges),
                  _buildDescription(),
                  //_buildBanner(),
                  //_buildLiveFeedSponsor(),
                  _buildLiveFeed()
                ]));
    });
  }
}
