import 'package:async_redux/async_redux.dart'
    show ReduxAction, NavigateAction, Store;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/chat_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:outloud/events/event_screen.dart';
import 'package:outloud/widgets/event_image.dart';
import 'package:outloud/widgets/lounge_header.dart';
import 'package:outloud/lounges/lounge_chat_screen.dart';
import 'package:outloud/theme.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class MyLoungesScreen extends StatefulWidget {
  @override
  _MyLoungesScreenState createState() => _MyLoungesScreenState();
}

class _MyLoungesScreenState extends State<MyLoungesScreen>
    with AutomaticKeepAliveClientMixin<MyLoungesScreen> {
  void Function(ReduxAction<AppState>) _dispatch;

  @override
  bool get wantKeepAlive => true;

  Widget _buildLounges(
      List<Lounge> lounges,
      Map<String, List<Lounge>> userEventLounges,
      Map<String, ChatState> loungeChatStates,
      String userId) {
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
                              child: AutoSizeText(
                                  FlutterI18n.translate(context,
                                      'LOUNGES_TAB.MY_LOUNGES_EMPTY_TITLE'),
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold))),
                          AutoSizeText(
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
                          loungeChatStates[lounges[index].id]
                              ?.countNewMessages(),
                          lounges[index],
                          userId)
                    ]));
  }

  Widget _buildInfoLoungeLayout(Lounge lounge, String userId) {
    final User owner = lounge.members.firstWhere(
        (User member) => member.id == lounge.owner,
        orElse: () => null);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LoungeHeader(lounge: lounge, owner: owner, userId: userId),
          GestureDetector(
              onTap: () => _dispatch(NavigateAction<AppState>.pushNamed(
                  EventScreen.id,
                  arguments: lounge.event)),
              child: Row(children: <Widget>[
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
                    decoration: const BoxDecoration(color: blue),
                    child: AutoSizeText(
                        FlutterI18n.translate(
                            context, 'LOUNGES_TAB.GO_EVENT_LISTING'),
                        style: const TextStyle(
                            color: white, fontWeight: FontWeight.bold)))
              ]))
        ]);
  }

  Widget _buildLounge(int newMessageCount, Lounge lounge, String userId) {
    if (lounge.event == null) {
      return Container(width: 0.0, height: 0.0);
    }
    return GestureDetector(
        onTap: () => _dispatch(NavigateAction<AppState>.pushNamed(
            LoungeChatScreen.id,
            arguments: lounge)),
        child: Container(
            decoration: const BoxDecoration(),
            padding: const EdgeInsets.all(10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  EventImage(
                      image: lounge.event.pic,
                      isChat: true,
                      newMessageCount: newMessageCount),
                  if (lounge.members.isNotEmpty)
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.all(10.0),
                            child: _buildInfoLoungeLayout(lounge, userId))),
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
      final String userId = state.userState.user.id;
      final Map<String, ChatState> loungeChatStates =
          state.chatsState.loungesChatsStates[userId];
      return _buildLounges(state.userState.lounges,
          state.userState.eventLounges, loungeChatStates, userId);
    });
  }
}
