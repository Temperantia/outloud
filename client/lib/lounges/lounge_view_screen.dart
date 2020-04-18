import 'package:async_redux/async_redux.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:business/classes/lounge_visibility.dart';
import 'package:business/classes/user.dart';
import 'package:business/lounges/actions/lounge_edit_details_action.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:business/app_state.dart';
import 'package:async_redux/async_redux.dart' show ReduxAction, NavigateAction;
import 'package:business/classes/lounge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:outloud/profile/profile_screen.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/button.dart';
import 'package:outloud/widgets/cached_image.dart';
import 'package:outloud/widgets/lounge_banner.dart';
import 'package:outloud/widgets/lounge_member_range_bar.dart';
import 'package:outloud/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class LoungeViewScreen extends StatefulWidget {
  const LoungeViewScreen(this.lounge, this.isEdit);

  final Lounge lounge;
  final bool isEdit;

  static const String id = 'LoungeViewScreen';

  @override
  _LoungeViewScreenState createState() => _LoungeViewScreenState();
}

class _LoungeViewScreenState extends State<LoungeViewScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _descriptionController = TextEditingController();

  void Function(ReduxAction<AppState>) _dispatch;
  int _limit;
  LoungeVisibility _visibility;
/*   final GlobalKey<LoungeMeetupWidgetState> _meetupWidgetKey = GlobalKey();

  LoungeMeetupWidget _meetupWidget; */

  @override
  void initState() {
    super.initState();
    _limit = widget.lounge.memberLimit;
    _visibility = widget.lounge.visibility;

    //_meetupWidget = LoungeMeetupWidget(widget.lounge, true);
    _descriptionController.text = widget.lounge.description;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _buildHeader(String userId) {
    final User owner = widget.lounge.members.firstWhere(
        (User member) => member.id == widget.lounge.owner,
        orElse: () => null);

    return LoungeBanner(lounge: widget.lounge, owner: owner, userId: userId);
  }

  Widget _buildMembers() {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AutoSizeText(FlutterI18n.translate(context, 'LOUNGE.MEMBERS'),
                    style: const TextStyle(
                        color: black,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
                GestureDetector(
                    child: Row(children: <Widget>[
                  AutoSizeText(FlutterI18n.translate(context, 'LOUNGE.PUBLIC'),
                      style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 15,
                          fontWeight: FontWeight.w500)),
                  const IconButton(
                      iconSize: 20,
                      icon: Icon(Icons.lock_open, color: Colors.orange),
                      onPressed: null)
                ]))
              ]),
          Column(children: <Widget>[
            for (User member in widget.lounge.members)
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
                  Widget>[
                GestureDetector(
                  onTap: () => _dispatch(NavigateAction<AppState>.pushNamed(
                      ProfileScreen.id,
                      arguments: <String, dynamic>{'user': member})),
                  child: Container(
                      padding: const EdgeInsets.only(left: 5),
                      child: Row(children: <Widget>[
                        CachedImage(member.pics.isEmpty ? null : member.pics[0],
                            width: 40.0,
                            height: 40.0,
                            borderRadius: BorderRadius.circular(20.0),
                            imageType: ImageType.User),
                        Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: AutoSizeText(member.name,
                                style: const TextStyle(
                                    color: black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700)))
                      ])),
                ),
                if (member.id == widget.lounge.owner)
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                            child: AutoSizeText(
                                FlutterI18n.translate(context, 'LOUNGE.ADMIN'),
                                style: const TextStyle(
                                    color: orange,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700))),
                      ])
              ])
          ]),
          /*  Row(children: <Widget>[
            IconButton(
                iconSize: 40,
                icon: Icon(Icons.add_circle, color: orange),
                onPressed: null),
            AutoSizeText(FlutterI18n.translate(context, 'LOUNGE.INVITE_MORE_PEOPLE'),
                style: const TextStyle(
                    color: orange, fontSize: 15, fontWeight: FontWeight.w700))
          ]) */
        ]));
  }

  Widget _buildLoungeMaxMemberCount() {
    return Container(
        padding: const EdgeInsets.all(15),
        child: widget.isEdit
            ? Column(children: <Widget>[
                AutoSizeText(
                    FlutterI18n.translate(
                        context, 'LOUNGE_CREATE_DETAIL.MAX_MEMBER_COUNT'),
                    style: const TextStyle(
                        color: black,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
                LoungeMemberRangeBar(
                    selected: _limit,
                    max: 5,
                    onUpdate: (int selected) =>
                        setState(() => _limit = selected))
              ])
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    AutoSizeText(
                        '${FlutterI18n.translate(context, "LOUNGE.MAX_PEOPLE_COUNT")} : ${_limit.toInt()}',
                        style: const TextStyle(
                            color: black,
                            fontSize: 15,
                            fontWeight: FontWeight.w700))
                  ]));
  }

  Widget _buildLoungeDescription() {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          AutoSizeText(
              FlutterI18n.translate(context, 'LOUNGE.LOUNGE_DESCRIPTION'),
              style: const TextStyle(
                  color: black, fontSize: 15, fontWeight: FontWeight.w700)),
          if (widget.isEdit)
            Container(
                constraints: BoxConstraints.expand(
                    height:
                        Theme.of(context).textTheme.display1.fontSize * 1.1 +
                            100),
                padding:
                    const EdgeInsets.only(left: 10.0, top: 1.0, right: 10.0),
                color: orangeLight,
                child: TextField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.text,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(100),
                    ],
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: FlutterI18n.translate(
                            context, 'LOUNGE_EDIT.GROUP_DESCRIPTION'))))
          else
            Container(
                constraints: BoxConstraints.expand(
                    height:
                        Theme.of(context).textTheme.display1.fontSize * 1.1 +
                            100),
                padding:
                    const EdgeInsets.only(left: 10.0, top: 1.0, right: 10.0),
                color: orangeLight,
                child: TextField(
                    readOnly: true, controller: _descriptionController))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<AppState>) dispatch,
        Widget child) {
      _dispatch = dispatch;
      return View(
          title: FlutterI18n.translate(context, 'LOUNGE.VIEW_LOUNGE_DETAILS'),
          buttons: widget.isEdit
              ? Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                  Widget>[
                  Button(
                      text: FlutterI18n.translate(context, 'LOUNGE_EDIT.SAVE'),
                      onPressed: () {
                        /*  final Map<String, dynamic> _meetupEdits =
                            _meetupWidgetKey.currentState.saveMeetupOptions();
                        dispatch(LoungeEditMeetupAction(
                            widget.lounge,
                            _meetupEdits['date'] as DateTime,
                            _meetupEdits['location'] as GeoPoint,
                            _meetupEdits['notes'] as String)); */
                        dispatch(LoungeEditDetailsAction(
                            widget.lounge,
                            _visibility,
                            _limit.toInt(),
                            _descriptionController.text));
                        dispatch(NavigateAction<AppState>.pop());
                      },
                      paddingLeft: 5)
                ])
              : null,
          child: Column(children: <Widget>[
            _buildHeader(state.userState.user.id),
            const Divider(),
            Expanded(
                flex: 8,
                child: Scrollbar(
                    controller: _scrollController,
                    child: ListView(children: <Widget>[
                      _buildMembers(),
                      _buildLoungeMaxMemberCount(),
                      _buildLoungeDescription(),
                      /* if (widget.isEdit)
                          LoungeMeetupWidget(widget.lounge, false,
                              key: _meetupWidgetKey)
                        else
                          _meetupWidget */
                    ])))
          ]));
    });
  }
}
