import 'package:async_redux/async_redux.dart';
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
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _markAsRead(Map<String, Map<String, ChatState>> usersChatsStates,
      String userId, void Function(ReduxAction<AppState>) dispatch) {
    if (usersChatsStates[userId][widget.chat.id]
        .messageStates
        .containsValue(MessageState.Received)) {
      dispatch(ChatsReadAction(widget.chat.id));
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
      addMessage(widget.chat.id, userId, text.trim(), MessageType.Text);
      _scrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  Widget _buildChat(User user, String userId, String picture) {
    final List<Message> messages = widget.chat.messages;
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
              _buildItem(messages[index], user, userId, picture),
          itemCount: messages.length,
          controller: _scrollController),
    );
  }

  Widget _buildItem(Message message, User user, String userId, String picture) {
    final User userPeer = widget.chat.entity as User;
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
                            Text(
                                userId == message.idFrom
                                    ? user.name
                                    : userPeer.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text(_dateFormatter(message.timestamp))
                          ]),
                      Text(message.content),
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
      _markAsRead(state.chatsState.usersChatsStates, userId, dispatch);
      return View(
          title:
              'CHAT WITH ${(widget.chat.entity as User).name.split(' ')[0].toUpperCase()}',
          buttons: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                  color: orangeLight.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(5.0)),
              child: Row(children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {}, child: Icon(Icons.add, color: white))),
                Expanded(
                    child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration.collapsed(
                            hintText: FlutterI18n.translate(
                                context, 'LOUNGE_CHAT.MESSAGE'),
                            hintStyle: const TextStyle(color: white)))),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {},
                        child:
                            const Icon(MdiIcons.stickerEmoji, color: white))),
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
