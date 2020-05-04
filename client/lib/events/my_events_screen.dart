import 'package:async_redux/async_redux.dart'
    show ReduxAction, NavigateAction, Store;
import 'package:auto_size_text/auto_size_text.dart' show AutoSizeText;
import 'package:business/app_state.dart' show AppState;
import 'package:business/classes/event.dart' show Event;
import 'package:business/classes/user_event_state.dart' show UserEventState;
import 'package:flutter/material.dart'
    show
        AutomaticKeepAliveClientMixin,
        BuildContext,
        Column,
        Container,
        CrossAxisAlignment,
        EdgeInsets,
        FontWeight,
        Icon,
        Icons,
        Image,
        MainAxisAlignment,
        Row,
        State,
        StatefulWidget,
        TextStyle,
        Widget;
import 'package:flutter_i18n/flutter_i18n.dart' show FlutterI18n;
import 'package:outloud/events/event_screen.dart' show EventScreen;
import 'package:outloud/theme.dart' show grey;
import 'package:intl/intl.dart' show DateFormat;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'
    show MdiIcons;
import 'package:outloud/widgets/content_list.dart' show ContentList;
import 'package:outloud/widgets/content_list_item.dart' show ContentListItem;
import 'package:outloud/widgets/event_image.dart' show EventImage;
import 'package:provider_for_redux/provider_for_redux.dart' show ReduxConsumer;

class MyEventsScreen extends StatefulWidget {
  @override
  _MyEventsScreen createState() => _MyEventsScreen();
}

class _MyEventsScreen extends State<MyEventsScreen>
    with AutomaticKeepAliveClientMixin<MyEventsScreen> {
  void Function(ReduxAction<AppState>) _dispatch;
  @override
  bool get wantKeepAlive => true;

  Widget _buildUserEvent(
      Event event,
      Map<String, UserEventState>
          userEventStates /* , List<Lounge> userLounges */) {
    String time = '';
    String timeEnd = '';

    if (event.dateStart != null) {
      time = DateFormat('Hm').format(event.dateStart);

      if (event.dateEnd != null) {
        timeEnd = DateFormat('Hm').format(event.dateEnd);
      }
    }

    final UserEventState state = userEventStates[event.id];
    String stateMessage = '';
    if (state == UserEventState.Attending) {
      stateMessage = FlutterI18n.translate(context, 'MY_EVENTS.GOING');
    } else if (state == UserEventState.Liked) {
      stateMessage = FlutterI18n.translate(context, 'MY_EVENTS.LIKED');
    }

    /*   final Lounge lounge = userLounges.firstWhere(
        (Lounge lounge) => lounge.eventId == event.id,
        orElse: () => null); */

    if (event == null) {
      return Container(width: 0.0, height: 0.0);
    }
    return ContentListItem(
      onTap: () => _dispatch(
          NavigateAction<AppState>.pushNamed(EventScreen.id, arguments: event)),
      leading: EventImage(
          image: event.pic, dateStart: event.dateStart, dateEnd: event.dateEnd),
      title: AutoSizeText(event.name,
          style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            AutoSizeText('$time - $timeEnd'),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  if (state == UserEventState.Attending)
                    const Icon(Icons.check)
                  else if (state == UserEventState.Liked)
                    const Icon(MdiIcons.heart),
                  AutoSizeText(stateMessage)
                ])
          ]),
      /*  buttons: lounge == null
          ? Button(
              text: FlutterI18n.translate(context, 'MY_EVENTS.FIND_LOUNGES'),
              height: 30.0,
              backgroundColor: orange,
              backgroundOpacity: 1.0,
              onPressed: () => _dispatch(NavigateAction<AppState>.pushNamed(
                  LoungesScreen.id,
                  arguments: event)))
          : Button(
              text: FlutterI18n.translate(context, 'MY_EVENTS.VIEW_LOUNGE'),
              height: 30.0,
              backgroundColor: pinkBright,
              backgroundOpacity: 1.0,
              onPressed: () => _dispatch(NavigateAction<AppState>.pushNamed(
                  LoungeChatScreen.id,
                  arguments: lounge))), */
    );
  }

  Widget _buildUserEvents(
      List<Event> userEvents,
      Map<String, UserEventState>
          userEventStates /* , List<Lounge> userLounges */) {
    return ContentList<Event>(
        items: userEvents,
        builder: (Event event) =>
            _buildUserEvent(event, userEventStates /* , userLounges */),
        whenEmpty: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                            FlutterI18n.translate(
                                context, 'MY_EVENTS.MY_EVENTS_EMPTY_TITLE'),
                            style: const TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold)),
                        AutoSizeText(
                            FlutterI18n.translate(context,
                                'MY_EVENTS.MY_EVENTS_EMPTY_DESCRIPTION'),
                            style: const TextStyle(color: grey))
                      ])),
              Image.asset('images/catsIllus4.png')
            ]));
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
      return _buildUserEvents(state.userState.events,
          state.userState.user.events /* , state.userState.lounges */);
    });
  }
}
