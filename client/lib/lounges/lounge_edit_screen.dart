import 'package:business/classes/lounge_visibility.dart';
import 'package:business/classes/user.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:business/app_state.dart';
import 'package:business/lounges/actions/lounge_remove_action.dart';
import 'package:business/lounges/actions/lounge_kick_user_action.dart';
import 'package:business/lounges/actions/lounge_edit_details_action.dart';
import 'package:business/lounges/actions/lounge_edit_meetup_action.dart';
import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/classes/lounge.dart';
import 'package:flutter/material.dart';
import 'package:outloud/functions/loader_animation.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/button.dart';
import 'package:outloud/widgets/cached_image.dart';
import 'package:outloud/widgets/meetup_widget.dart';
import 'package:outloud/widgets/view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoungeEditScreen extends StatefulWidget {
  const LoungeEditScreen(this.lounge);
  final Lounge lounge;
  static const String id = 'LoungeEditScreen';

  @override
  _LoungeEditScreenState createState() => _LoungeEditScreenState();
}

class _LoungeEditScreenState extends State<LoungeEditScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _descriptionController = TextEditingController();

  final GlobalKey<LoungeMeetupWidgetState> _meetupWidget = GlobalKey();

  double _limit;
  LoungeVisibility _visibility;

  @override
  void initState() {
    super.initState();
    _limit = widget.lounge.memberLimit.toDouble();
    _visibility = widget.lounge.visibility;
    _descriptionController.text = widget.lounge.description;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showConfirmPopup(void Function(redux.ReduxAction<AppState>) dispatch,
      Future<void> Function(redux.ReduxAction<AppState>) dispatchFuture) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
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
                        MdiIcons.trashCan,
                        color: orange,
                        size: 60,
                      ),
                      const Text('Delete Lounge?',
                          style: TextStyle(
                              color: orange,
                              fontSize: 26,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 18, right: 18),
                        child: const Text(
                            'This will permanently delete the lounge and kick all its members.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 18, right: 18, bottom: 15),
                        child: const Text('Are you sure?',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ),
                      SizedBox(
                        child: Container(
                          color: orange,
                          child: Column(
                            children: <Widget>[
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
                                            child: const Text(
                                                'No, Take Me Back',
                                                style: TextStyle(
                                                    color: orange,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500)))),
                                  )),
                              Container(
                                  padding:
                                      const EdgeInsets.only(bottom: 5, top: 5),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: FlatButton(
                                        onPressed: () async {
                                          await showLoaderAnimation(
                                              context, this,
                                              animationDuration: 600);
                                          for (final String memberId
                                              in widget.lounge.memberIds) {
                                            await dispatchFuture(
                                                LoungeKickUserAction(
                                                    memberId, widget.lounge));
                                          }
                                          dispatch(LoungeRemoveAction(
                                              widget.lounge));

                                          Navigator.pop(context);
                                          dispatch(redux
                                              .NavigateAction<AppState>.pop());
                                          dispatch(redux
                                              .NavigateAction<AppState>.pop());
                                        },
                                        child: const Text('YES, Delete Lounge',
                                            style: TextStyle(
                                                color: white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500))),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ));
      },
    );
  }

  Widget _buildHeader(
      AppState state,
      void Function(redux.ReduxAction<AppState>) dispatch,
      Future<void> Function(redux.ReduxAction<AppState>) dispatchFuture) {
    final User owner = widget.lounge.members.firstWhere(
        (User member) => member.id == widget.lounge.owner,
        orElse: () => null);

    return Container(
        padding: const EdgeInsets.all(15.0),
        child: Row(children: <Widget>[
          Flexible(
              flex: 2,
              child: Stack(alignment: Alignment.center, children: <Widget>[
                Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            left: BorderSide(color: orange, width: 5.0))),
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
                                  fontWeight: FontWeight.w500),
                            ))
                      ])),
                    Wrap(children: <Widget>[
                      RichText(
                          text: TextSpan(
                              text:
                                  '${widget.lounge.members.length.toString()} member${widget.lounge.members.length > 1 ? 's' : ''} ',
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
                  ]))),
          Flexible(
              flex: 2,
              child: GestureDetector(
                  onTap: () async {
                    _showConfirmPopup(dispatch, dispatchFuture);
                  },
                  child: Container(
                      margin:
                          const EdgeInsets.only(left: 5, right: 10, top: 10),
                      child: Column(children: const <Widget>[
                        Icon(MdiIcons.trashCan, color: orange),
                        Text('REMOVE',
                            style: TextStyle(
                                color: orange,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                        Text('LOUNGE',
                            style: TextStyle(
                                color: orange,
                                fontSize: 10,
                                fontWeight: FontWeight.bold))
                      ]))))
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
                    Container(
                        child: const Text('MEMBERS',
                            style: TextStyle(
                                color: black,
                                fontSize: 15,
                                fontWeight: FontWeight.w700))),
                    Container(
                        child: GestureDetector(
                            child: Row(children: <Widget>[
                      Container(
                          child: const Text('PUBLIC',
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500))),
                      Container(
                          child: const IconButton(
                              iconSize: 20,
                              icon: Icon(Icons.lock_open, color: Colors.orange),
                              onPressed: null))
                    ])))
                  ])),
          Container(
              child: Column(children: <Widget>[
            for (User member in widget.lounge.members)
              // if (member.id != lounge.owner)
              Container(
                  child: Row(
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
                        ]))
                  ]))
          ])),
          Row(children: <Widget>[
            Container(
                child: IconButton(
                    iconSize: 40,
                    icon: Icon(Icons.add_circle, color: orange),
                    onPressed: null)),
            Container(
                child: const Text('INVITE MORE PEOPLE',
                    style: TextStyle(
                        color: orange,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)))
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
                    const Text('MAX MEMBER COUNT',
                        style: TextStyle(
                            color: black,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                    Container(
                        padding: const EdgeInsets.all(10),
                        color: pinkLight.withOpacity(0.4),
                        child: GestureDetector(
                            child: const Text('UPGRADE FOR MORE!',
                                style: TextStyle(
                                    color: pink,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500)))),
                    // Container(
                    //     child: const Button(
                    //   fontSize: 13,
                    //   fontWeight: FontWeight.w500,
                    //   backgroundColor: pink,
                    //   text: 'UPGRADE FOR MORE!',
                    //   colorText: black87,
                    //   width: 180,
                    // ))
                  ])),
          Slider(
              value: _limit,
              label: _limit.toInt().toString(),
              min: 2,
              max: 5,
              activeColor: orange,
              inactiveColor: orangeLight,
              divisions: 3,
              onChanged: (double value) {
                setState(() {
                  _limit = value;
                });
              })
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
                height:
                    Theme.of(context).textTheme.display1.fontSize * 1.1 + 100,
              ),
              padding: const EdgeInsets.only(left: 10.0, top: 1.0, right: 10.0),
              color: orangeLight,
              child: TextField(
                  controller: _descriptionController,
                  keyboardType: TextInputType.text,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(100),
                  ],
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Brief description of your group.')))
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
          title: 'EDIT LOUNGE',
          child: Column(children: <Widget>[
            Expanded(
                child: Column(children: <Widget>[
              _buildHeader(state, dispatch, store.dispatchFuture),
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
                          LoungeMeetupWidget(widget.lounge, false,
                              key: _meetupWidget)
                        ])
                      ]))),
              Expanded(
                  child: Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                    Button(
                        text: 'SAVE CHANGES',
                        onPressed: () {
                          final Map<String, dynamic> _meetupEdits =
                              _meetupWidget.currentState.saveMeetupOptions();
                          dispatch(LoungeEditMeetupAction(
                              widget.lounge,
                              _meetupEdits['date'] as DateTime,
                              _meetupEdits['location'] as GeoPoint,
                              _meetupEdits['notes'] as String));
                          dispatch(LoungeEditDetailsAction(
                              widget.lounge,
                              _visibility,
                              _limit.toInt(),
                              _descriptionController.text));
                          dispatch(redux.NavigateAction<AppState>.pop());
                        },
                        paddingLeft: 5)
                  ])))
            ]))
          ]));
    });
  }
}
