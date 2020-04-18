import 'package:async_redux/async_redux.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:business/app_state.dart';
import 'package:business/chats/actions/chats_read_action.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/chat_state.dart';
import 'package:business/classes/message.dart';
import 'package:business/classes/message_state.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:outloud/profile/profile_screen.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/cached_image.dart';
import 'package:outloud/widgets/view.dart';
import 'package:intl/intl.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

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
      return DateFormat(' E \'at\' kk:mm').format(time);
    }
    return DateFormat('yyyy-MM-dd \'at\' kk:mm').format(time);
  }

  void _onSendMessage(String text, String userId) {
    if (text.trim().isEmpty) {
      Fluttertoast.showToast(
          msg: FlutterI18n.translate(context, 'CHAT.NO_MESSAGE'));
    } else {
      _messageController.clear();
      addMessage(_chat.id, userId, text.trim(), MessageType.Text);
      _scrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  Widget _buildChat(User user, String userId, String picture) {
    final List<Message> messages = _chat.messages;
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) => _buildItem(
            messages[messages.length - index - 1], user, userId, picture),
        itemCount: messages.length,
        controller: _scrollController);
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
                          arguments: <String, dynamic>{
                            'user': userPeer,
                          })),
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
                      AutoSizeText(message.content),
                    ]))),
        if (userId == message.idFrom)
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () => _dispatch(NavigateAction<AppState>.pushNamed(
                          ProfileScreen.id,
                          arguments: <String, dynamic>{
                            'user': user,
                          })),
                  child: CachedImage(picture,
                      width: 35.0,
                      height: 35.0,
                      borderRadius: BorderRadius.circular(20.0),
                      imageType: ImageType.User))),
      ]),
    );
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
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                  color: orangeLight.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(5.0)),
              child: Row(children: <Widget>[
                /*   Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {}, child: Icon(Icons.add, color: white))), */
                Expanded(
                    child: Column(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: _messageController,
                            decoration: InputDecoration.collapsed(
                                hintText: 'Message pour $namePeer',
                                hintStyle: const TextStyle(color: white))))
                  ],
                )),
                /*   Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {},
                        child:
                            const Icon(MdiIcons.stickerEmoji, color: white))), */
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () => _onSendMessage(
                            _messageController.text, state.userState.user.id),
                        child: Icon(Icons.send, color: white)))
              ])),
          child: _buildChat(user, userId, picture));
    });
  }
}
