import 'package:async_redux/async_redux.dart'
    show NavigateAction, ReduxAction, Store;
import 'package:auto_size_text/auto_size_text.dart' show AutoSizeText;
import 'package:business/app_state.dart' show AppState;
import 'package:business/chats/actions/chats_read_action.dart'
    show ChatsReadAction;
import 'package:business/classes/chat.dart' show Chat;
import 'package:business/classes/chat_state.dart' show ChatState;
import 'package:business/classes/message.dart' show Message;
import 'package:business/classes/message_state.dart' show MessageState;
import 'package:business/classes/user.dart' show User;
import 'package:flutter/material.dart'
    show
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Column,
        Container,
        CrossAxisAlignment,
        EdgeInsets,
        Expanded,
        FontWeight,
        GestureDetector,
        MainAxisAlignment,
        Padding,
        Row,
        ScrollController,
        State,
        StatefulWidget,
        TextEditingController,
        TextStyle,
        Widget;
import 'package:outloud/profile/profile_screen.dart' show ProfileScreen;
import 'package:outloud/theme.dart' show pink, pinkLight;
import 'package:outloud/widgets/cached_image.dart' show CachedImage, ImageType;
import 'package:outloud/widgets/content_list.dart' show ContentList;
import 'package:outloud/widgets/message_bar.dart' show MessageBar;
import 'package:outloud/widgets/view.dart' show View;
import 'package:intl/intl.dart' show DateFormat;
import 'package:provider_for_redux/provider_for_redux.dart' show ReduxConsumer;

class ChatScreen extends StatefulWidget {
  const ChatScreen(this.chat);
  final Chat chat;
  static const String id = 'Chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void Function(ReduxAction<AppState>) _dispatch;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Chat _chat;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _markAsRead(
      Map<String, Map<String, ChatState>> usersChatsStates, String userId) {
    if (usersChatsStates[userId][_chat.id]
        .messageStates
        .containsValue(MessageState.Received)) {
      _dispatch(ChatsReadAction(_chat.id));
    }
  }

  String _dateFormatter(int timestamp) {
    final DateTime time = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final int daysDifference = DateTime.now().difference(time).inDays;
    if (daysDifference < 7) {
      return DateFormat(' E kk:mm').format(time);
    }
    return DateFormat('yy-MM-dd kk:mm').format(time);
  }

  Widget _buildChat(User user, String userId, String picture) {
    return ContentList<Message>(
        reverse: true,
        withBorders: false,
        controller: _scrollController,
        items: _chat.messages,
        builder: (Message message) =>
            _buildItem(message, user, userId, picture));
  }

  Widget _buildItem(Message message, User user, String userId, String picture) {
    final User userPeer = _chat.entity as User;
    final List<String> pictures = userPeer.pics;
    final String picturePeer = pictures.isEmpty ? null : pictures[0];

    return Container(
        padding: const EdgeInsets.all(5.0),
        child: Row(children: <Widget>[
          if (userId != message.idFrom)
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: () => _dispatch(NavigateAction<AppState>.pushNamed(
                        ProfileScreen.id,
                        arguments: <String, dynamic>{'user': userPeer})),
                    child: CachedImage(picturePeer,
                        width: 35.0,
                        height: 35.0,
                        borderRadius: BorderRadius.circular(20.0),
                        imageType: ImageType.User))),
          Expanded(
              child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      color: userId == message.idFrom
                          ? pink.withOpacity(0.8)
                          : pinkLight.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              AutoSizeText(
                                  userId == message.idFrom
                                      ? user.name
                                      : userPeer.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              AutoSizeText(_dateFormatter(message.timestamp))
                            ]),
                        AutoSizeText(message.content)
                      ]))),
          if (userId == message.idFrom)
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: () => _dispatch(NavigateAction<AppState>.pushNamed(
                        ProfileScreen.id,
                        arguments: <String, dynamic>{'user': user})),
                    child: CachedImage(picture,
                        width: 35.0,
                        height: 35.0,
                        borderRadius: BorderRadius.circular(20.0),
                        imageType: ImageType.User)))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<AppState>) dispatch,
        Widget child) {
      _dispatch = dispatch;
      final User user = state.userState.user;
      final String picture = user.pics.isEmpty ? null : user.pics[0];
      final String userId = user.id;

      final List<Chat> chats = state.chatsState.chats;
      _chat = chats.firstWhere((Chat chat) => chat.id == widget.chat.id,
          orElse: () => null);
      if (_chat == null || _chat.entity == null) {
        return Container(width: 0.0, height: 0.0);
      }
      _markAsRead(state.chatsState.usersChatsStates, userId);
      final String namePeer = (_chat.entity as User).name.split(' ')[0];
      return View(
          title: 'CHAT AVEC ${namePeer.toUpperCase()}',
          buttons: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: MessageBar(
                  chatId: _chat.id,
                  userId: userId,
                  messageController: _messageController,
                  scrollController: _scrollController,
                  hint: 'Message pour $namePeer')),
          child: _buildChat(user, userId, picture));
    });
  }
}
