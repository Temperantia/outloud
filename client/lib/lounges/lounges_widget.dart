import 'dart:math' as math;

import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';
import 'package:business/classes/user_event_state.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/lounges/lounge_chat_screen.dart';
import 'package:inclusive/lounges/lounge_create_screen.dart';
import 'package:inclusive/lounges/lounge_screen.dart';
import 'package:inclusive/lounges/lounges_screen.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/cached_image.dart';
import 'package:inclusive/widgets/circular_image.dart';
import 'package:inclusive/widgets/loading.dart';
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
    final List<Lounge> _lounges = <Lounge>[];
    userEventLounges.forEach((String eventKey, List<Lounge> lounges) {
      lounges.forEach(_lounges.add);
    });
    return ListView.builder(
      itemCount: _lounges.length,
      itemBuilder: (BuildContext context, int index) => Container(
        decoration: const BoxDecoration(color: white),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildLounge(_lounges[index], dispatch, themeStyle)
            ]),
      ),
    );
  }

  Widget _buildInfoLoungeLayout(Lounge lounge) {
    final User owner =
        lounge.members.firstWhere((User member) => member.id == lounge.owner);
    return Column(
      children: <Widget>[
        Container(
            child: Row(
          children: <Widget>[
            Container(
                child: CircularImage(
              imageUrl: owner.pics.isNotEmpty ? owner.pics[0] : null,
              imageRadius: 40.0,
            )),
            Container(
                child: RichText(
              text: TextSpan(
                text: owner.name + '\'s Lounge',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            )),
          ],
        )),
        Container(
            child: Row(
          children: <Widget>[
            Container(
                child: RichText(
              text: TextSpan(
                  text: lounge.members.length.toString() +
                      ' member' +
                      (lounge.members.length > 1 ? 's ' : ' '),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                  children: <TextSpan>[
                    TextSpan(
                        text: lounge.event.name,
                        style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.w800))
                  ]),
            ))
          ],
        )),
        Container(
          //   child: GestureDetector(
          // onTap: () {
          //   print('ok GO TO EVENT LISTENING');
          // },
          child: const Text('> GO TO EVENT LISTING'),
        )
        // )
      ],
    );
  }

  Widget _buildLounge(Lounge lounge,
      void Function(redux.ReduxAction<AppState>) dispatch, ThemeStyle theme) {
    return GestureDetector(
        onTap: () {
          dispatch(redux.NavigateAction<AppState>.pushNamed(LoungeChatScreen.id,
              arguments: lounge));
        },
        child: Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
              if (lounge.event.pic.isNotEmpty)
                Flexible(
                    child: GestureDetector(
                      onTap: () {
                        dispatch(redux.NavigateAction<AppState>.pushNamed(LoungeChatScreen.id,
              arguments: lounge));
                      },
                      child: Container(
                        child: Stack(
                  children: <Widget>[
                    Container(
                      child: CachedImage(
                        lounge.event.pic,
                      ),
                    ),
                    Positioned(
                        top: 15,
                        left: 20,
                        child: Container(
                            child: IconButton(
                          iconSize: 40,
                          icon: Icon(Icons.chat_bubble),
                          color: white,
                          onPressed: () {
                            dispatch(redux.NavigateAction<AppState>.pushNamed(LoungeChatScreen.id,
              arguments: lounge));
                          },
                        ))),
                    Positioned(
                        top: 30,
                        left: 40,
                        child: Container(
                            child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(math.pi),
                                child: IconButton(
                                  iconSize: 40,
                                  icon: Icon(Icons.chat_bubble_outline),
                                  color: white,
                                  onPressed: () {
                                    dispatch(redux.NavigateAction<AppState>.pushNamed(LoungeChatScreen.id,
              arguments: lounge));
                                  },
                                ))))
                  ],
                ))
                    )
                ),
              Flexible(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: _buildInfoLoungeLayout(lounge),
                  )),
            ])));
  }

  Widget _buildEvents(
      List<Event> userEvents,
      Map<String, UserEventState> userEventStates,
      Map<String, List<Lounge>> userEventLounges,
      void Function(redux.ReduxAction<AppState>) dispatch,
      ThemeStyle themeStyle) {
    return ListView.builder(
      itemCount: userEvents.length,
      itemBuilder: (BuildContext context, int index) => Container(
        decoration: const BoxDecoration(color: white),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildEvent(userEvents[index], userEventStates, userEventLounges,
                  dispatch, themeStyle)
            ]),
      ),
    );
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

    return GestureDetector(
        onTap: () {
          dispatch(redux.NavigateAction<AppState>.pushNamed(LoungesScreen.id,
              arguments: event));
        },
        child: Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
              if (event.pic.isNotEmpty)
                Expanded(
                    child: CachedImage(
                  event.pic,
                )),
              Expanded(
                  flex: 2,
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(stateMessage),
                            Text(event.name),
                            Text(
                                ' > FIND LOUNGES (${lounges == null ? '0' : lounges.length} AVAILABLE)')
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
      // print('userLOUNGES : ' + userLounges.toString());
      // userLounges.forEach((Lounge lounge)  {
      //   print('I am a user lounge : ' + lounge.toJson().toString());
      // });
      // print('userEventLOunge : '+ userEventLounges.toString());
      // userEventLounges.forEach((String key,List<Lounge> lounges ) {
      //   lounges.forEach((Lounge lounge) {
      //     print('for KEY : ' + key + ' I AM THE LOUNGE : ' + lounge.toJson().toString());
      //   });
      // });

      return DefaultTabController(
          length: 2,
          child: Column(
            children: <Widget>[
              const Expanded(
                  child: TabBar(
                tabs: <Widget>[
                  Tab(text: 'MY LOUNGES'),
                  Tab(text: 'FIND LOUNGES'),
                ],
              )),
              Expanded(
                  flex: 6,
                  child: Container(
                      color: white,
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          _buildLounges(userLounges, userEventLounges, dispatch,
                              themeStyle),
                          _buildEvents(userEvents, userEventStates,
                              userEventLounges, dispatch, themeStyle),
                        ],
                      ))),
              Expanded(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 45,
                        width: 200,
                        margin: const EdgeInsets.all(10.0),
                        child: RaisedButton.icon(
                            color: orangeLight.withOpacity(0.5),
                            textColor: white,
                            onPressed: () => dispatch(
                                redux.NavigateAction<AppState>.pushNamed(
                                    LoungeCreateScreen.id)),
                            icon: Icon(Icons.add),
                            label: const Text('CREATE LOUNGE')),
                      )
                    ],
                  ),
                ),
              )
            ],
          ));
    });
  }
}
