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
      AppState state,
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
                      _buildLounge(state, lounges[index], dispatch, themeStyle)
                    ])));
  }

  Widget _buildInfoLoungeLayout(AppState state, Lounge lounge,
      void Function(redux.ReduxAction<AppState>) dispatch) {
    final User owner = lounge.members.firstWhere(
        (User member) => member.id == lounge.owner,
        orElse: () => null);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (owner != null)
            Row(children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: CachedImage(owner.pics.isEmpty ? null : owner.pics[0],
                      width: 20.0,
                      height: 20.0,
                      borderRadius: BorderRadius.circular(20.0),
                      imageType: ImageType.User)),
              Expanded(
                  child: RichText(
                      text: TextSpan(
                text: state.userState.user.id == owner.id
                    ? 'Your Lounge'
                    : owner.name + '\'s Lounge',
                style: const TextStyle(
                    color: black, fontSize: 13, fontWeight: FontWeight.w500),
              ))),
            ]),
          Row(children: <Widget>[
            Container(
                child: RichText(
                    text: TextSpan(
                        text:
                            '${lounge.members.length.toString()} member${lounge.members.length > 1 ? 's ' : ' '}',
                        style: const TextStyle(
                            color: black,
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
                    dispatch(redux.NavigateAction<AppState>.pushNamed(
                        EventScreen.id,
                        arguments: lounge.event));
                  },
                  child: Row(children: <Widget>[
                    // TODO(robin): go to event listing gesture detector
                    Image.asset('images/arrowForward.png',
                        width: 10.0, height: 10.0),
                    const Text(' GO TO EVENT LISTING',
                        style: TextStyle(
                            color: orange, fontWeight: FontWeight.bold))
                  ])))
        ]);
  }

  Widget _buildLounge(AppState state, Lounge lounge,
      void Function(redux.ReduxAction<AppState>) dispatch, ThemeStyle theme) {
    if (lounge.event == null) {
      return Container();
    }
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  child: Stack(alignment: Alignment.center, children: <Widget>[
                Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            left: BorderSide(color: orange, width: 7.0))),
                    child: CachedImage(lounge.event.pic,
                        width: 70.0,
                        height: 70.0,
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(5.0),
                            topRight: Radius.circular(5.0)),
                        imageType: ImageType.Event)),
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
              if (lounge.members.isNotEmpty)
                Expanded(
                    child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child:
                            _buildInfoLoungeLayout(state, lounge, dispatch))),
            ]));
  }

  Widget _buildEvents(
      List<Lounge> userLounges,
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
                      _buildEvent(
                          userLounges,
                          userEvents[index],
                          userEventStates,
                          userEventLounges,
                          dispatch,
                          themeStyle),
                    ])));
  }

  Widget _buildEvent(
      List<Lounge> userLounges,
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

    return GestureDetector(
        onTap: () {
          dispatch(redux.NavigateAction<AppState>.pushNamed(LoungesScreen.id,
              arguments: event));
        },
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(children: <Widget>[
              Flexible(
                  child: Stack(alignment: Alignment.center, children: <Widget>[
                Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            left: BorderSide(color: orange, width: 7.0))),
                    child: CachedImage(event.pic,
                        width: 70.0,
                        height: 70.0,
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(5.0),
                            topRight: Radius.circular(5.0)),
                        imageType: ImageType.Event)),
                if (state == UserEventState.Attending)
                  Icon(Icons.check, size: 40.0, color: white)
                else if (state == UserEventState.Liked)
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
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13)),
                            Text(event.name,
                                style: const TextStyle(
                                    color: orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13)),
                            Row(children: <Widget>[
                              Image.asset('images/arrowForward.png',
                                  width: 10.0, height: 10.0),
                              const Expanded(
                                  child: Text(' FIND LOUNGES ',
                                      style: TextStyle(
                                          color: blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)))
                            ])
                          ]))),
            ])));
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

      final List<Event> eventsWithoutLounge = userEvents.where((Event _event) {
        final List<Lounge> _lounges = userEventLounges[_event.id];
        if (_lounges != null) {
          for (final Lounge _lounge in _lounges) {
            for (final Lounge _userLounge in userLounges) {
              if (_userLounge.id == _lounge.id) {
                return false;
              }
            }
          }
        }
        return true;
      }).toList();

      return DefaultTabController(
          length: 2,
          child: Column(children: <Widget>[
            const Expanded(
                child: TabBar(
                    labelColor: white,
                    indicatorColor: Colors.transparent,
                    tabs: <Widget>[
                  Tab(text: 'MY LOUNGES'),
                  Tab(text: 'FIND LOUNGES'),
                ])),
            Expanded(
                flex: 8,
                child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      _buildLounges(state, userLounges, userEventLounges,
                          dispatch, themeStyle),
                      _buildEvents(
                          userLounges,
                          eventsWithoutLounge,
                          userEventStates,
                          userEventLounges,
                          dispatch,
                          themeStyle),
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
