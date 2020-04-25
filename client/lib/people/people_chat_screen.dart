import 'package:async_redux/async_redux.dart'
    show ReduxAction, NavigateAction, Store;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/chat_state.dart';
import 'package:business/classes/message.dart';
import 'package:business/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:outloud/people/chat_screen.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/cached_image.dart';
import 'package:outloud/widgets/content_list.dart';
import 'package:outloud/widgets/content_list_item.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class PeopleChatScreen extends StatefulWidget {
  @override
  _PeopleChatScreenState createState() => _PeopleChatScreenState();
}

class _PeopleChatScreenState extends State<PeopleChatScreen>
    with AutomaticKeepAliveClientMixin<PeopleChatScreen> {
  void Function(ReduxAction<AppState>) _dispatch;

  @override
  bool get wantKeepAlive => true;

  Widget _buildChat(Chat chat, int newMessageCount) {
    if (chat.entity == null) {
      return Container(width: 0.0, height: 0.0);
    }

    final Message lastMessage = chat.messages.isEmpty ? null : chat.messages[0];
    final String pic = (chat.entity as User).pics.isEmpty
        ? null
        : (chat.entity as User).pics[0];
    return ContentListItem(
        onTap: () => _dispatch(
            NavigateAction<AppState>.pushNamed(ChatScreen.id, arguments: chat)),
        leading: CachedImage(pic,
            width: 50.0,
            height: 50.0,
            borderRadius: BorderRadius.circular(60.0),
            imageType: ImageType.User),
        title: AutoSizeText(chat.entity.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: lastMessage == null
            ? null
            : AutoSizeText(lastMessage.getTimeAgo(),
                style: textStyleListItemSubtitle),
        buttons: lastMessage == null
            ? null
            : Wrap(children: <Widget>[
                AutoSizeText(lastMessage.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: orange, fontSize: 20.0))
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
      final Map<String, ChatState> chatStates =
          state.chatsState.usersChatsStates[state.userState.user.id];
      return ContentList(
          items: state.chatsState.chats,
          builder: (dynamic chat) =>
              _buildChat(chat as Chat, chatStates[chat.id].countNewMessages()));
    });
  }
}
