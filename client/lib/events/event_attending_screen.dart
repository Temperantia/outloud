import 'package:async_redux/async_redux.dart'
    show ReduxAction, NavigateAction, Store;
import 'package:auto_size_text/auto_size_text.dart' show AutoSizeText;
import 'package:business/app_state.dart' show AppState;
import 'package:business/classes/event.dart' show Event;
import 'package:business/classes/user.dart' show User;
import 'package:flutter/material.dart'
    show
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Column,
        Container,
        Divider,
        EdgeInsets,
        Expanded,
        Flexible,
        FontWeight,
        GestureDetector,
        GridView,
        Row,
        SliverGridDelegateWithFixedCrossAxisCount,
        State,
        StatefulWidget,
        TextAlign,
        TextOverflow,
        TextStyle,
        Widget,
        Wrap;
import 'package:flutter_i18n/flutter_i18n.dart' show FlutterI18n;
import 'package:outloud/profile/profile_screen.dart' show ProfileScreen;
import 'package:outloud/theme.dart' show black, orange, orangeLight;
import 'package:outloud/widgets/cached_image.dart' show CachedImage, ImageType;
import 'package:outloud/widgets/view.dart' show View;
import 'package:provider_for_redux/provider_for_redux.dart' show ReduxConsumer;

class EventAttendingScreen extends StatefulWidget {
  const EventAttendingScreen(this.event);
  final Event event;

  static const String id = 'EventAttendingScreen';

  @override
  _EventAttendingScreenState createState() => _EventAttendingScreenState();
}

class _EventAttendingScreenState extends State<EventAttendingScreen> {
  Widget _buildHeader() {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            AutoSizeText(
                FlutterI18n.translate(
                    context, 'EVENTS_ATTENDING.FOR_THE_EVENT'),
                style: const TextStyle(
                    color: black, fontSize: 13, fontWeight: FontWeight.bold)),
          ]),
          Row(children: <Widget>[
            Flexible(
                child: CachedImage(widget.event.pic,
                    width: 30.0,
                    height: 30.0,
                    borderRadius: BorderRadius.circular(5.0),
                    imageType: ImageType.Event)),
            Expanded(
                flex: 8,
                child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: AutoSizeText(widget.event.name,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                            color: orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w700))))
          ])
        ]));
  }

  Widget _buildList(void Function(ReduxAction<AppState>) dispatch) {
    final int memberNumber = widget.event.memberIds.length;
    final List<User> members = widget.event.members;

    if (widget.event.members == null) {
      return Container(width: 0.0, height: 0.0);
    }

    return Expanded(
        child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
            child: Column(children: <Widget>[
              Container(
                  padding: const EdgeInsets.all(5.0),
                  child: AutoSizeText(
                      '${memberNumber.toString()} ${memberNumber <= 1 ? FlutterI18n.translate(context, "EVENTS_ATTENDING.PEOPLE_SINGULAR") : FlutterI18n.translate(context, "EVENTS_ATTENDING.PEOPLE_PLURAL")} ${FlutterI18n.translate(context, "EVENTS_ATTENDING.ATTENDING")}',
                      style: const TextStyle(
                          color: orange, fontWeight: FontWeight.bold))),
              Expanded(
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 10.0,
                              childAspectRatio: 3.0),
                      itemCount: members.length,
                      itemBuilder: (BuildContext context, int index) =>
                          _buildMember(members[index], dispatch)))
            ])));
  }

  Widget _buildMember(
      User member, void Function(ReduxAction<AppState>) dispatch) {
    final String pic = member.pics.isEmpty ? null : member.pics[0];
    return GestureDetector(
        onTap: () => dispatch(NavigateAction<AppState>.pushNamed(
            ProfileScreen.id,
            arguments: <String, dynamic>{'user': member})),
        child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: orangeLight, borderRadius: BorderRadius.circular(5.0)),
            child: Row(children: <Widget>[
              CachedImage(pic,
                  width: 40.0,
                  height: 40.0,
                  borderRadius: BorderRadius.circular(20.0),
                  imageType: ImageType.User),
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Wrap(children: <Widget>[
                        AutoSizeText(member.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold))
                      ])))
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<AppState>) dispatch,
        Widget child) {
      return View(
          title: 'LISTE DE PARTICIPANTS',
          child: Column(children: <Widget>[
            _buildHeader(),
            const Divider(color: orange),
            _buildList(dispatch)
          ]));
    });
  }
}
