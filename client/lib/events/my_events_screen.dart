import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user_event_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:outloud/events/event_screen.dart';
import 'package:outloud/lounges/lounge_chat_screen.dart';
import 'package:outloud/lounges/lounges_screen.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/button.dart';
import 'package:outloud/widgets/cached_image.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class MyEventsScreen extends StatefulWidget {
  @override
  _MyEventsScreen createState() => _MyEventsScreen();
}

class _MyEventsScreen extends State<MyEventsScreen>
    with AutomaticKeepAliveClientMixin<MyEventsScreen> {
  @override
  bool get wantKeepAlive => true;

  Widget _buildUserEvent(
      Event event,
      Map<String, UserEventState> userEventStates,
      List<Lounge> userLounges,
      void Function(redux.ReduxAction<AppState>) dispatch,
      ThemeStyle theme) {
    final String date = event.dateStart == null
        ? null
        : DateFormat('dd').format(event.dateStart);
    final String month = event.dateStart == null
        ? null
        : DateFormat('MMM').format(event.dateStart);
    final String time = event.dateStart == null
        ? null
        : DateFormat('jm').format(event.dateStart);
    final String timeEnd =
        event.dateEnd == null ? null : DateFormat('jm').format(event.dateEnd);

    final UserEventState state = userEventStates[event.id];

    String stateMessage = '';
    if (state == UserEventState.Attending) {
      stateMessage = FlutterI18n.translate(context, 'MY_EVENTS.GOING');
    } else if (state == UserEventState.Liked) {
      stateMessage = FlutterI18n.translate(context, 'MY_EVENTS.LIKED');
    }

    final Lounge lounge = userLounges.firstWhere(
        (Lounge lounge) => lounge.eventId == event.id,
        orElse: () => null);

    if (event == null) {
      return Container();
    }
    return Container(
        padding: const EdgeInsets.all(10.0),
        child: Row(children: <Widget>[
          GestureDetector(
            onTap: () => dispatch(redux.NavigateAction<AppState>.pushNamed(
                EventScreen.id,
                arguments: event)),
            child: Stack(alignment: Alignment.center, children: <Widget>[
              CachedImage(event.pic,
                  width: 70.0,
                  height: 70.0,
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(5.0),
                      topRight: Radius.circular(5.0)),
                  imageType: ImageType.Event),
              Container(
                  color: pink.withOpacity(0.5), width: 70.0, height: 70.0),
              Column(children: <Widget>[
                Text(date,
                    style: const TextStyle(
                        color: white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                Text(month,
                    style: const TextStyle(
                        color: white, fontWeight: FontWeight.bold))
              ])
            ]),
          ),
          Expanded(
              child: Container(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(event.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('$time - $timeEnd'),
                              Container(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                    if (state == UserEventState.Attending)
                                      const Icon(Icons.check)
                                    else if (state == UserEventState.Liked)
                                      const Icon(MdiIcons.heart),
                                    Text(stateMessage),
                                  ]))
                            ]),
                        if (lounge == null)
                          Button(
                              text: FlutterI18n.translate(
                                  context, 'MY_EVENTS.FIND_LOUNGES'),
                              height: 30.0,
                              backgroundColor: orange,
                              backgroundOpacity: 1.0,
                              onPressed: () => dispatch(
                                  redux.NavigateAction<AppState>.pushNamed(
                                      LoungesScreen.id,
                                      arguments: event)))
                        else
                          Button(
                              text: FlutterI18n.translate(
                                  context, 'MY_EVENTS.VIEW_LOUNGE'),
                              height: 30.0,
                              backgroundColor: pinkBright,
                              backgroundOpacity: 1.0,
                              onPressed: () => dispatch(
                                  redux.NavigateAction<AppState>.pushNamed(
                                      LoungeChatScreen.id,
                                      arguments: lounge)))
                      ])))
        ]));
  }

  Widget _buildUserEvents(
      List<Event> userEvents,
      Map<String, UserEventState> userEventStates,
      List<Lounge> userLounges,
      ThemeStyle themeStyle,
      void Function(redux.ReduxAction<AppState>) dispatch) {
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
                              child: Text(
                                  FlutterI18n.translate(context,
                                      'MY_EVENTS.MY_EVENTS_EMPTY_TITLE'),
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold))),
                          Text(
                              FlutterI18n.translate(context,
                                  'MY_EVENTS.MY_EVENTS_EMPTY_DESCRIPTION'),
                              style: const TextStyle(color: grey))
                        ])),
                Image.asset('images/catsIllus4.png')
              ])
        : Column(children: <Widget>[
            Expanded(
                flex: 8,
                child: ListView.builder(
                    itemCount: userEvents.length,
                    itemBuilder: (BuildContext context, int index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _buildUserEvent(
                                  userEvents[index],
                                  userEventStates,
                                  userLounges,
                                  dispatch,
                                  themeStyle),
                              const Divider(color: orange),
                            ]))),
            /*  Expanded(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Button(
                text: FlutterI18n.translate(context, 'MY_EVENTS.VIEW_CALENDAR'),
                onPressed: () => null)
          ])) */
          ]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<dynamic>) dispatch,
        Widget child) {
      return _buildUserEvents(
          state.userState.events,
          state.userState.user.events,
          state.userState.lounges,
          state.theme,
          dispatch);
    });
  }
}
