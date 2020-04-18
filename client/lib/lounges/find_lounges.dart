import 'package:async_redux/async_redux.dart'
    show ReduxAction, NavigateAction, Store;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user_event_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:outloud/events/event_screen.dart';
import 'package:outloud/lounges/lounges_screen.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/event_image.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class FindLoungesScreen extends StatefulWidget {
  @override
  _FindLoungesScreenState createState() => _FindLoungesScreenState();
}

class _FindLoungesScreenState extends State<FindLoungesScreen>
    with AutomaticKeepAliveClientMixin<FindLoungesScreen> {
  void Function(ReduxAction<AppState>) _dispatch;
  @override
  bool get wantKeepAlive => true;

  Widget _buildEvents(
      List<Lounge> userLounges,
      List<Event> userEvents,
      Map<String, UserEventState> userEventStates,
      Map<String, List<Lounge>> userEventLounges) {
    return userEvents.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: AutoSizeText(
                                  FlutterI18n.translate(context,
                                      'LOUNGES_TAB.FIND_LOUNGES_EMPTY_TITLE'),
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold))),
                          AutoSizeText(
                              FlutterI18n.translate(context,
                                  'LOUNGES_TAB.FIND_LOUNGES_EMPTY_DESCRIPTION'),
                              style: const TextStyle(color: grey))
                        ])),
                Image.asset('images/catsIllus2.png')
              ])
        : ListView.builder(
            itemCount: userEvents.length,
            itemBuilder: (BuildContext context, int index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildEvent(userLounges, userEvents[index],
                          userEventStates, userEventLounges),
                    ]));
  }

  Widget _buildEvent(
      List<Lounge> userLounges,
      Event event,
      Map<String, UserEventState> userEventStates,
      Map<String, List<Lounge>> userEventLounges) {
    final UserEventState state = userEventStates[event.id];
    String stateMessage = '';
    if (state == UserEventState.Attending) {
      stateMessage =
          FlutterI18n.translate(context, 'LOUNGES_TAB.ATTENDING_EVENT');
    } else if (state == UserEventState.Liked) {
      stateMessage = FlutterI18n.translate(context, 'LOUNGES_TAB.LIKED_EVENT');
    }

    return GestureDetector(
        onTap: () => _dispatch(NavigateAction<AppState>.pushNamed(
            EventScreen.id,
            arguments: event)),
        child: Container(
            decoration: BoxDecoration(color: Colors.transparent),
            padding: const EdgeInsets.all(10.0),
            child: Row(children: <Widget>[
              Flexible(child: EventImage(image: event.pic, state: state)),
              Expanded(
                  flex: 3,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AutoSizeText(stateMessage,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13)),
                            AutoSizeText(event.name,
                                style: const TextStyle(
                                    color: orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13)),
                            Row(children: <Widget>[
                              GestureDetector(
                                  onTap: () => _dispatch(
                                      NavigateAction<AppState>.pushNamed(
                                          LoungesScreen.id,
                                          arguments: event)),
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 5.0),
                                      decoration:
                                          const BoxDecoration(color: blue),
                                      child: AutoSizeText(
                                          FlutterI18n.translate(context,
                                              'LOUNGES_TAB.FIND_LOUNGES'),
                                          style: const TextStyle(
                                              color: white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14))))
                            ])
                          ])))
            ])));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<AppState>) dispatch,
        Widget child) {
      _dispatch = dispatch;
      final List<Event> eventsWithoutLounge =
          state.userState.events.where((Event _event) {
        final List<Lounge> _lounges = state.userState.eventLounges[_event.id];
        if (_lounges != null) {
          for (final Lounge _lounge in _lounges) {
            for (final Lounge _userLounge in state.userState.lounges) {
              if (_userLounge.id == _lounge.id) {
                return false;
              }
            }
          }
        }
        return true;
      }).toList();

      return _buildEvents(state.userState.lounges, eventsWithoutLounge,
          state.userState.user.events, state.userState.eventLounges);
    });
  }
}
