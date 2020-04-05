import 'package:async_redux/async_redux.dart';
import 'package:business/classes/user.dart';
import 'package:flutter/widgets.dart';
import 'package:business/app_state.dart';
import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/classes/lounge.dart';
import 'package:flutter/material.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/cached_image.dart';
import 'package:outloud/widgets/meetup_widget.dart';
import 'package:outloud/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class LoungeViewScreen extends StatefulWidget {
  const LoungeViewScreen(this.lounge);
  final Lounge lounge;
  static const String id = 'LoungeViewScreen';

  @override
  _LoungeViewScreenState createState() => _LoungeViewScreenState();
}

class _LoungeViewScreenState extends State<LoungeViewScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _descriptionController = TextEditingController();
  double _limit;
  LoungeMeetupWidget _meetupWidget;

  @override
  void initState() {
    super.initState();
    _limit = widget.lounge.memberLimit.toDouble();
    _meetupWidget = LoungeMeetupWidget(widget.lounge, true);
    _descriptionController.text = widget.lounge.description;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _buildHeader(
      AppState state, void Function(ReduxAction<AppState>) dispatch) {
    final User owner = widget.lounge.members.firstWhere(
        (User member) => member.id == widget.lounge.owner,
        orElse: () => null);

    return Container(
        padding: const EdgeInsets.all(15.0),
        child: Row(children: <Widget>[
          Flexible(
              child: Stack(alignment: Alignment.center, children: <Widget>[
            Container(
                decoration: const BoxDecoration(
                    border:
                        Border(left: BorderSide(color: orange, width: 5.0))),
                child: CachedImage(widget.lounge.event.pic,
                    width: 40.0,
                    height: 40.0,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(5.0),
                        topRight: Radius.circular(5.0)),
                    imageType: ImageType.Event))
          ])),
          Flexible(
              flex: 8,
              child: Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(children: <Widget>[
                    if (owner != null)
                      Container(
                          child: Row(children: <Widget>[
                        CachedImage(owner.pics.isEmpty ? null : owner.pics[0],
                            width: 20.0,
                            height: 20.0,
                            borderRadius: BorderRadius.circular(20.0),
                            imageType: ImageType.User),
                        Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                                state.userState.user.id == owner.id
                                    ? 'Your Lounge'
                                    : owner.name + '\'s Lounge',
                                style: const TextStyle(
                                    color: black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500)))
                      ])),
                    Row(children: <Widget>[
                      RichText(
                          text: TextSpan(
                              text:
                                  '${widget.lounge.members.length.toString()} member${widget.lounge.members.length > 1 ? 's' : ''}',
                              style: const TextStyle(
                                  color: black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                              children: <TextSpan>[
                            TextSpan(
                                text: widget.lounge.event.name,
                                style: TextStyle(
                                    color: orange,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800))
                          ]))
                    ])
                  ])))
        ]));
  }

  Widget _buildMembers(BuildContext context, AppState state) {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(children: <Widget>[
          Container(
              constraints: BoxConstraints.expand(
                height: Theme.of(context).textTheme.display1.fontSize * 1.1,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('MEMBERS',
                        style: TextStyle(
                            color: black,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                    GestureDetector(
                        child: Row(children: const <Widget>[
                      Text('PUBLIC',
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                      IconButton(
                          iconSize: 20,
                          icon: Icon(Icons.lock_open, color: Colors.orange),
                          onPressed: null)
                    ]))
                  ])),
          Column(children: <Widget>[
            for (User member in widget.lounge.members)
              // if (member.id != lounge.owner)
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.only(left: 5),
                        child: Row(children: <Widget>[
                          CachedImage(
                              member.pics.isEmpty ? null : member.pics[0],
                              width: 40.0,
                              height: 40.0,
                              borderRadius: BorderRadius.circular(20.0),
                              imageType: ImageType.User),
                          Container(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(member.name,
                                  style: const TextStyle(
                                      color: black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700)))
                        ])),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                              child: const Text('vote to KICK',
                                  style: TextStyle(
                                      color: orange,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700))),
                        ])
                  ])
          ]),
          Row(children: <Widget>[
            IconButton(
                iconSize: 40,
                icon: Icon(Icons.add_circle, color: orange),
                onPressed: null),
            const Text('INVITE MORE PEOPLE',
                style: TextStyle(
                    color: orange, fontSize: 15, fontWeight: FontWeight.w700))
          ])
        ]));
  }

  Widget _buildLoungeMaxMemberCount(BuildContext context, AppState state) {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(children: <Widget>[
          Container(
              constraints: BoxConstraints.expand(
                height: Theme.of(context).textTheme.display1.fontSize * 1.1,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('MAX MEMBER COUNT : $_limit',
                        style: const TextStyle(
                            color: black,
                            fontSize: 15,
                            fontWeight: FontWeight.w700))
                  ])),
        ]));
  }

  Widget _buildLoungeDescription(BuildContext context, AppState state) {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(children: <Widget>[
          Container(
              constraints: BoxConstraints.expand(
                height: Theme.of(context).textTheme.display1.fontSize * 1.1,
              ),
              child: const Text('LOUNGE DESCRIPTION',
                  style: TextStyle(
                      color: black,
                      fontSize: 15,
                      fontWeight: FontWeight.w700))),
          Container(
              constraints: BoxConstraints.expand(
                  height: Theme.of(context).textTheme.display1.fontSize * 1.1 +
                      100),
              padding: const EdgeInsets.only(left: 10.0, top: 1.0, right: 10.0),
              color: orangeLight,
              child:
                  TextField(readOnly: true, controller: _descriptionController))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<dynamic>) dispatch,
        Widget child) {
      return View(
          title: 'VIEW LOUNGE DETAILS',
          child: Column(children: <Widget>[
            Expanded(
                child: Container(
                    child: Container(
                        child: Column(children: <Widget>[
              _buildHeader(state, dispatch),
              Container(color: white, child: const Divider()),
              Expanded(
                  flex: 8,
                  child: Scrollbar(
                      child: ListView(
                          controller: _scrollController,
                          children: <Widget>[
                        Column(children: <Widget>[
                          _buildMembers(context, state),
                          _buildLoungeMaxMemberCount(context, state),
                          _buildLoungeDescription(context, state),
                          _meetupWidget
                        ])
                      ]))),
              Expanded(
                  child: Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                    // Button(
                    //     text: 'SAVE CHANGES',
                    //     onPressed: () {
                    //       final Map<String, dynamic> _meetupEdits =
                    //           _meetupWidget.saveMeetupOptions();
                    //       dispatch(LoungeEditMeetupAction(
                    //           lounge,
                    //           _meetupEdits['date'] as DateTime,
                    //           _meetupEdits['location'] as GeoPoint,
                    //           _meetupEdits['notes'] as String));
                    //       dispatch(LoungeEditDetailsAction(lounge, _visibility,
                    //           _limit.toInt(), _descriptionController.text));
                    //       dispatch(NavigateAction<AppState>.pop());
                    //     },
                    //     paddingLeft: 5)
                  ])))
            ]))))
          ]));
    });
  }
}
