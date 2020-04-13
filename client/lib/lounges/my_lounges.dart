import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:outloud/events/event_screen.dart';
import 'package:outloud/lounges/lounge_chat_screen.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/cached_image.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class MyLoungesScreen extends StatefulWidget {
  @override
  _MyLoungesScreenState createState() => _MyLoungesScreenState();
}

class _MyLoungesScreenState extends State<MyLoungesScreen>
    with AutomaticKeepAliveClientMixin<MyLoungesScreen> {
  @override
  bool get wantKeepAlive => true;

  Widget _buildLounges(
      AppState state,
      List<Lounge> lounges,
      Map<String, List<Lounge>> userEventLounges,
      void Function(redux.ReduxAction<AppState>) dispatch,
      ThemeStyle themeStyle) {
    return lounges.isEmpty
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
                              child: Text(
                                  FlutterI18n.translate(context,
                                      'LOUNGES_TAB.MY_LOUNGES_EMPTY_TITLE'),
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold))),
                          Text(
                              FlutterI18n.translate(context,
                                  'LOUNGES_TAB.MY_LOUNGES_EMPTY_DESCRIPTION'),
                              style: const TextStyle(color: grey))
                        ])),
                Image.asset('images/catsIllus1.png')
              ])
        : ListView.builder(
            itemCount: lounges.length,
            itemBuilder: (BuildContext context, int index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildLounge(
                          state,
                          state
                                  .chatsState
                                  .loungesChatsStates[state.userState.user.id]
                                  .isNotEmpty
                              ? state
                                  .chatsState
                                  .loungesChatsStates[state.userState.user.id]
                                      [lounges[index].id]
                                  ?.countNewMessages()
                              : 0,
                          lounges[index],
                          dispatch,
                          themeStyle)
                    ]));
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
                  child: I18nText(
                      state.userState.user.id == owner.id
                          ? 'LOUNGE_CHAT.YOUR_LOUNGE'
                          : 'LOUNGE_CHAT.SOMEONES_LOUNGE',
                      child: const Text('',
                          style: TextStyle(
                              color: black,
                              fontSize: 13,
                              fontWeight: FontWeight.w500)),
                      translationParams: <String, String>{'user': owner.name})),
            ]),
          Wrap(children: <Widget>[
            RichText(
                text: TextSpan(
                    text:
                        '${lounge.members.length.toString()} ${FlutterI18n.translate(context, "LOUNGES_TAB.MEMBER")}${lounge.members.length > 1 ? 's ' : ' '}',
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
                ]))
          ]),
          GestureDetector(
              onTap: () => dispatch(redux.NavigateAction<AppState>.pushNamed(
                  EventScreen.id,
                  arguments: lounge.event)),
              child: Row(children: <Widget>[
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
                    decoration: const BoxDecoration(color: blue),
                    child: Text(
                        FlutterI18n.translate(
                            context, 'LOUNGES_TAB.GO_EVENT_LISTING'),
                        style: const TextStyle(
                            color: white, fontWeight: FontWeight.bold)))
              ]))
        ]);
  }

  Widget _buildLounge(AppState state, int newMessageCount, Lounge lounge,
      void Function(redux.ReduxAction<AppState>) dispatch, ThemeStyle theme) {
    if (lounge.event == null) {
      return Container(width: 0.0, height: 0.0);
    }
    return GestureDetector(
        onTap: () => dispatch(redux.NavigateAction<AppState>.pushNamed(
            LoungeChatScreen.id,
            arguments: lounge)),
        child: Container(
            decoration: const BoxDecoration(),
            padding: const EdgeInsets.all(10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Stack(alignment: Alignment.center, children: <Widget>[
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
                    Container(
                        width: 40.0,
                        height: 40.0,
                        child: Image.asset('images/chatIcon.png')),
                    if ((newMessageCount ?? 0) > 0)
                      Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                              width: 30.0,
                              height: 30.0,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                  color: blue,
                                  borderRadius: BorderRadius.circular(60.0)),
                              child: Center(
                                child: Text(newMessageCount.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: white,
                                        fontWeight: FontWeight.bold)),
                              )))
                  ]),
                  if (lounge.members.isNotEmpty)
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.all(10.0),
                            child: _buildInfoLoungeLayout(
                                state, lounge, dispatch))),
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
      return _buildLounges(state, state.userState.lounges,
          state.userState.eventLounges, dispatch, state.theme);
    });
  }
}
