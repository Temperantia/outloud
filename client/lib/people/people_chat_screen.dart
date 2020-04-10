import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/message.dart';
import 'package:business/classes/message_state.dart';
import 'package:business/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:outloud/people/chat_screen.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/cached_image.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class PeopleChatScreen extends StatefulWidget {
  @override
  _PeopleChatScreenState createState() => _PeopleChatScreenState();
}

class _PeopleChatScreenState extends State<PeopleChatScreen>
    with AutomaticKeepAliveClientMixin<PeopleChatScreen> {
  @override
  bool get wantKeepAlive => true;

  Widget _buildChat(Chat chat, Map<String, MessageState> messageStates,
      ThemeStyle theme, void Function(redux.ReduxAction<AppState>) dispatch) {
    if (chat.entity == null) {
      return Container();
    }
    int newMessageCount = 0;
    for (final MessageState messageState in messageStates.values) {
      if (messageState == MessageState.Received) {
        newMessageCount++;
      }
    }
    final Message lastMessage = chat.messages.isEmpty ? null : chat.messages[0];
    final String pic = (chat.entity as User).pics.isEmpty
        ? null
        : (chat.entity as User).pics[0];
    return Column(children: <Widget>[
      GestureDetector(
          onTap: () => dispatch(redux.NavigateAction<AppState>.pushNamed(
              ChatScreen.id,
              arguments: chat)),
          child: Container(
              decoration: BoxDecoration(color: Colors.transparent),
              padding: const EdgeInsets.all(20.0),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CachedImage(pic,
                        width: 50.0,
                        height: 50.0,
                        borderRadius: BorderRadius.circular(60.0),
                        imageType: ImageType.User),
                    Expanded(
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(chat.entity.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  if (lastMessage != null)
                                    Text(lastMessage.getTimeAgo(),
                                        style: textStyleListItemSubtitle),
                                  if (lastMessage != null)
                                    Row(children: <Widget>[
                                      Text(lastMessage.content,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: orange, fontSize: 20.0))
                                    ])
                                ]))),
                    if (newMessageCount > 0)
                      Container(
                          width: 40.0,
                          height: 40.0,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                              color: blue,
                              borderRadius: BorderRadius.circular(60.0)),
                          child: Center(
                            child: Text(newMessageCount.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: white, fontWeight: FontWeight.bold)),
                          )),
/*                     Image.asset('images/hamburger.png', color: orange), */
                  ]))),
      const Divider()
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
      return ListView.builder(
          itemCount: state.chatsState.chats.length,
          itemBuilder: (BuildContext context, int index) {
            final Chat chat = state.chatsState.chats[index];
            return _buildChat(
                chat,
                state
                    .chatsState
                    .usersChatsStates[state.userState.user.id][chat.id]
                    .messageStates,
                state.theme,
                dispatch);
          });
    });
  }
}
