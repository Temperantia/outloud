import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';
import 'package:business/classes/user_event_state.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/events/event_screen.dart';
import 'package:inclusive/lounges/lounge_chat_screen.dart';
import 'package:inclusive/lounges/lounge_create_screen.dart';
import 'package:inclusive/lounges/lounges_screen.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/button.dart';
import 'package:inclusive/widgets/cached_image.dart';
import 'package:inclusive/widgets/circular_image.dart';
import 'package:inclusive/widgets/loading.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class LoungesWidget extends StatefulWidget {
  @override
  _LoungesWidgetState createState() => _LoungesWidgetState();
}

class _LoungesWidgetState extends State<LoungesWidget>
    with AutomaticKeepAliveClientMixin<LoungesWidget> {
  @override
  bool get wantKeepAlive => true;

  Widget _buildLounges(
      List<Lounge> lounges,
      Map<String, List<Lounge>> userEventLounges,
      void Function(redux.ReduxAction<AppState>) dispatch,
      ThemeStyle themeStyle) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: ListView.builder(
            itemCount: lounges.length,
            itemBuilder: (BuildContext context, int index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildLounge(lounges[index], dispatch, themeStyle)
                    ])));
  }

  Widget _buildInfoLoungeLayout(
      Lounge lounge, void Function(redux.ReduxAction<AppState>) dispatch) {
    // TODO(robin): bring the state user here to compare if user.id == owner.id so you write "Your Lounge" instead
    final User owner =
        lounge.members.firstWhere((User member) => member.id == lounge.owner);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: <Widget>[
            Container(
                child: CircularImage(
              imageUrl: owner.pics.isNotEmpty ? owner.pics[0] : null,
              imageRadius: 20.0,
            )),
            Container(
                margin: const EdgeInsets.only(left: 5.0),
                child: RichText(
                    text: TextSpan(
                  text: owner.name + '\'s Lounge',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ))),
          ]),
          Row(children: <Widget>[
            Container(
                child: RichText(
                    text: TextSpan(
                        text:
                            '${lounge.members.length.toString()} member${lounge.members.length > 1 ? 's ' : ' '}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                        children: <TextSpan>[
                  TextSpan(
                      text: lounge.event.name,
                      style: TextStyle(
                          color: orange,
                          fontSize: 14,
                          fontWeight: FontWeight.w800)),
                ]))),
          ]),
          Container(
              child: GestureDetector(
                  onTap: () {
                    print('il doit se passer un truc');
                    dispatch(redux.NavigateAction<AppState>.pushNamed(
                        EventScreen.id,
                        arguments: lounge.event));
                  },
                  child: Row(children: <Widget>[
                    // TODO(robin): go to event listing gesture detector
                    Image.asset('images/arrowForward.png',
                        width: 10.0, height: 10.0),
                    Text(' GO TO EVENT LISTING',
                        style: TextStyle(
                            color: orange, fontWeight: FontWeight.bold))
                  ])))
        ]);
  }

  Widget _buildLounge(Lounge lounge,
      void Function(redux.ReduxAction<AppState>) dispatch, ThemeStyle theme) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(children: <Widget>[
          // TODO(me): later default event pic ?
          if (lounge.event != null && lounge.event.pic.isNotEmpty)
            Flexible(
                child: Stack(alignment: Alignment.center, children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      border:
                          Border(left: BorderSide(color: orange, width: 7.0))),
                  child: CachedImage(
                    lounge.event.pic,
                    width: 70.0,
                    height: 70.0,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(5.0),
                        topRight: Radius.circular(5.0)),
                  )),
              GestureDetector(
                  onTap: () => dispatch(
                      redux.NavigateAction<AppState>.pushNamed(
                          LoungeChatScreen.id,
                          arguments: lounge)),
                  child: Container(
                      width: 40.0,
                      height: 40.0,
                      child: Image.asset('images/chatIcon.png'))),
            ])),
          Expanded(
              flex: 3,
              child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: _buildInfoLoungeLayout(lounge, dispatch))),
        ]));
  }

  Widget _buildEvents(
      List<Event> userEvents,
      Map<String, UserEventState> userEventStates,
      Map<String, List<Lounge>> userEventLounges,
      void Function(redux.ReduxAction<AppState>) dispatch,
      ThemeStyle themeStyle) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: ListView.builder(
            itemCount: userEvents.length,
            itemBuilder: (BuildContext context, int index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildEvent(userEvents[index], userEventStates,
                          userEventLounges, dispatch, themeStyle),
                    ])));
  }

  Widget _buildEvent(
      Event event,
      Map<String, UserEventState> userEventStates,
      Map<String, List<Lounge>> userEventLounges,
      void Function(redux.ReduxAction<AppState>) dispatch,
      ThemeStyle theme) {
    final UserEventState state = userEventStates[event.id];
    String stateMessage;
    if (state == UserEventState.Attending) {
      stateMessage = 'You\'re attending this event';
    } else if (state == UserEventState.Liked) {
      stateMessage = 'You liked this event';
    }
    final List<Lounge> lounges = userEventLounges[event.id];

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(children: <Widget>[
          // TODO(me): later default event pic ?
          if (event.pic.isNotEmpty)
            Flexible(
                child: Stack(alignment: Alignment.center, children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      border:
                          Border(left: BorderSide(color: orange, width: 7.0))),
                  child: CachedImage(
                    event.pic,
                    width: 70.0,
                    height: 70.0,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(5.0),
                        topRight: Radius.circular(5.0)),
                  )),
              if (state == UserEventState.Attending)
                Icon(Icons.check, size: 40.0, color: white)
              else
                Icon(MdiIcons.heart, size: 40.0, color: white),
            ])),
          Expanded(
              flex: 3,
              child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(stateMessage,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        Text(event.name,
                            style: TextStyle(
                                color: orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                        GestureDetector(
                            onTap: () {
                              dispatch(redux.NavigateAction<AppState>.pushNamed(
                                  LoungesScreen.id,
                                  arguments: event));
                            },
                            child: Row(children: <Widget>[
                              Image.asset('images/arrowForward.png',
                                  width: 10.0, height: 10.0),
                              Expanded(
                                  child: Text(
                                      ' FIND LOUNGES (${lounges == null ? '0' : lounges.length} AVAILABLE)',
                                      style: TextStyle(
                                          color: orange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)))
                            ]))
                      ]))),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<dynamic>) dispatch,
        Widget child) {
      final ThemeStyle themeStyle = state.theme;
      final List<Lounge> userLounges = state.userState.lounges;
      final List<Event> userEvents = state.userState.events;
      final Map<String, UserEventState> userEventStates =
          state.userState.user.events;
      final Map<String, List<Lounge>> userEventLounges =
          state.userState.eventLounges;
      if (userEventStates == null ||
          userEvents == null ||
          userLounges == null) {
        return Loading();
      }

      return DefaultTabController(
          length: 2,
          child: Column(children: <Widget>[
            const Expanded(
                child:
                    TabBar(indicatorColor: Colors.transparent, tabs: <Widget>[
              Tab(text: 'MY LOUNGES'),
              Tab(text: 'FIND LOUNGES'),
            ])),
            Expanded(
                flex: 8,
                child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      _buildLounges(
                          userLounges, userEventLounges, dispatch, themeStyle),
                      _buildEvents(userEvents, userEventStates,
                          userEventLounges, dispatch, themeStyle),
                    ])),
            Expanded(
                child: Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                  Button(
                      text: 'CREATE LOUNGE',
                      width: 250,
                      icon: Icon(Icons.add),
                      onPressed: () => dispatch(
                          redux.NavigateAction<AppState>.pushNamed(
                              LoungeCreateScreen.id))),
                ]))),
          ]));
    });
  }
}
