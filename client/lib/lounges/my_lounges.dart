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
import 'package:outloud/widgets/button.dart';
import 'package:outloud/widgets/content_list.dart';
import 'package:outloud/widgets/content_list_item.dart';
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
    return ContentList(
        items: lounges,
        builder: (dynamic lounge) => _buildLounge(
            loungeChatStates[lounge.id]?.countNewMessages(),
            lounge as Lounge,
            userId),
        whenEmpty: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
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
            ]));
  }

  Widget _buildLounge(int newMessageCount, Lounge lounge, String userId) {
    if (lounge.event == null) {
      return Container(width: 0.0, height: 0.0);
    }

    final User owner = lounge.members.firstWhere(
        (User member) => member.id == lounge.owner,
        orElse: () => null);

    return ContentListItem(
        onTap: () => _dispatch(NavigateAction<AppState>.pushNamed(
            LoungeChatScreen.id,
            arguments: lounge)),
        leading: EventImage(
            image: lounge.event.pic,
            thumbnail: lounge.event.thumbnail,
            isChat: true,
            newMessageCount: newMessageCount),
        title: LoungeHeader(lounge: lounge, owner: owner, userId: userId),
        buttons: Button(
            text:
                FlutterI18n.translate(context, 'LOUNGES_TAB.GO_EVENT_LISTING'),
            height: 30.0,
            backgroundColor: blue,
            backgroundOpacity: 1.0,
            onPressed: () => _dispatch(NavigateAction<AppState>.pushNamed(
                EventScreen.id,
                arguments: lounge.event))));
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
