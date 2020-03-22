import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/message.dart';
import 'package:business/models/message.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/view.dart';
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
  final DateFormat _messageTimeFormat = DateFormat.jm();
  final DateFormat _messageDateFormat = DateFormat.yMd();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _listScrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  void _onSendMessage(String text, String userId) {
    if (text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Nothing to send');
    } else {
      _textController.clear();
      addMessage(widget.chat.id, userId, text.trim());
      _listScrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  Widget _buildChat(String userId) {
    final List<Message> messages = widget.chat.messages;
    return Expanded(
        child: ListView.builder(
            reverse: true,
            itemBuilder: (BuildContext context, int index) => _buildItem(
                messages[index],
                index < messages.length - 1 ? messages[index + 1] : null,
                userId),
            itemCount: messages.length,
            controller: _listScrollController));
  }

  Widget _buildItem(Message message, Message nextMessage, String userId) {
    final DateTime messageDateTime =
        DateTime.fromMillisecondsSinceEpoch(message.timestamp);

    final String messageTime = _messageTimeFormat.format(messageDateTime);
    final List<Widget> items = <Widget>[];

    if (nextMessage == null) {
      items.add(Text(_messageDateFormat.format(messageDateTime),
          style: Theme.of(context).textTheme.caption));
    } else {
      final DateTime nextMessageDateTime =
          DateTime.fromMillisecondsSinceEpoch(nextMessage.timestamp);

      if (nextMessageDateTime.day != messageDateTime.day ||
          nextMessageDateTime.month != messageDateTime.month ||
          nextMessageDateTime.year != messageDateTime.year) {
        items.add(Text(_messageDateFormat.format(messageDateTime),
            style: Theme.of(context).textTheme.caption));
      }
    }

    Widget messageWidget;
    if (userId == message.idFrom) {
      messageWidget = Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            Text(messageTime, style: Theme.of(context).textTheme.caption),
            Flexible(
                child: Container(
                    child: Text(
                      message.content,
                      style: const TextStyle(color: white),
                    ),
                    padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    decoration: BoxDecoration(
                        color: orange,
                        borderRadius: BorderRadius.circular(8.0)),
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0)))
          ]));
    } else {
      messageWidget = Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(
                    child: Container(
                  child: Text(
                    message.content,
                    style: const TextStyle(color: orange),
                  ),
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  decoration: BoxDecoration(
                      color: white, borderRadius: BorderRadius.circular(8.0)),
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                )),
                Text(messageTime, style: Theme.of(context).textTheme.caption)
              ]));
      if (widget.chat.isGroup &&
          (nextMessage == null || message.idFrom != nextMessage.idFrom)) {
        items.add(Container(
            margin: const EdgeInsets.only(left: 20.0),
            child: Row(children: <Widget>[
              Text(message.author == null ? 'Anonymous' : message.author.name,
                  style: Theme.of(context).textTheme.caption)
            ])));
      }
    }

    items.add(messageWidget);
    return Column(children: items);
  }

  Widget _buildInput(String userId) {
    return Row(children: <Widget>[
      Flexible(
          flex: 6,
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                  controller: _textController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline))),
      Material(
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => _onSendMessage(_textController.text, userId),
                color: orange,
              )),
          color: Colors.white)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<AppState>) dispatch,
        Widget child) {
      return View(
          child: Column(children: <Widget>[
        _buildChat(state.loginState.id),
        _buildInput(state.loginState.id),
      ]));
    });
  }
}
