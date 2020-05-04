import 'package:async_redux/async_redux.dart'
    show ReduxAction, NavigateAction, Store;
import 'package:auto_size_text/auto_size_text.dart' show AutoSizeText;
import 'package:business/app_state.dart' show AppState;
import 'package:business/classes/chat.dart' show Chat;
import 'package:business/classes/chat_state.dart' show ChatState;
import 'package:business/classes/message.dart' show Message;
import 'package:business/classes/user.dart' show User;
import 'package:flutter/material.dart'
    show
        AutomaticKeepAliveClientMixin,
        BorderRadius,
        BuildContext,
        Container,
        FontWeight,
        State,
        StatefulWidget,
        TextOverflow,
        TextStyle,
        Widget,
        Wrap;
import 'package:outloud/people/chat_screen.dart' show ChatScreen;
import 'package:outloud/theme.dart' show orange;
import 'package:outloud/widgets/cached_image.dart' show CachedImage, ImageType;
import 'package:outloud/widgets/content_list.dart' show ContentList;
import 'package:outloud/widgets/content_list_item.dart' show ContentListItem;
import 'package:provider_for_redux/provider_for_redux.dart' show ReduxConsumer;

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
        subtitle:
            lastMessage == null ? null : AutoSizeText(lastMessage.getTimeAgo()),
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
      return ContentList<Chat>(
          items: state.chatsState.chats,
          builder: (Chat chat) =>
              _buildChat(chat, chatStates[chat.id].countNewMessages()));
    });
  }
}
