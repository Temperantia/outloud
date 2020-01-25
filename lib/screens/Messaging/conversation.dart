import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inclusive/classes/conversation_list.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:inclusive/classes/entity.dart';
import 'package:inclusive/classes/message_list.dart';
import 'package:inclusive/widgets/loading.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:inclusive/widgets/background.dart';
import 'package:inclusive/classes/conversation.dart';
import 'package:inclusive/classes/message.dart';
import 'package:inclusive/services/app_data.dart';
import 'package:inclusive/services/message.dart';
import 'package:inclusive/theme.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({this.conversation});
  static const String id = 'Conversation';
  final Conversation conversation;
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final DateFormat _messageTimeFormat = DateFormat.jm();
  final DateFormat _messageDateFormat = DateFormat.yMd();

  final ScrollController _listScrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  AppDataService _appDataService;
  MessageService _messageService;

  void _onSendMessage(String text) {
    if (text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Nothing to send');
    } else {
      _textController.clear();
      _messageService.sendMessage(widget.conversation, text);
      _listScrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  Widget _buildConversation() {
    return Expanded(
        child: StreamBuilder<MessageList>(
            stream: widget.conversation.streamMessageList(),
            builder:
                (BuildContext context, AsyncSnapshot<MessageList> messageList) {
              if (messageList.connectionState == ConnectionState.waiting) {
                return Container();
              }
              final List<Message> messages = messageList.data.messages;
              return FutureBuilder<void>(
                  future: widget.conversation.getGroupUsers(messageList.data),
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) =>
                          ListView.builder(
                              reverse: true,
                              itemBuilder: (BuildContext context, int index) =>
                                  _buildItem(
                                    messages[index],
                                    index < messages.length - 1
                                        ? messages[index + 1]
                                        : null,
                                  ),
                              itemCount: messageList.data.messages.length,
                              controller: _listScrollController));
            }));
  }

  Widget _buildItem(Message message, Message nextMessage) {
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
    if (_appDataService.identifier == message.idFrom) {
      messageWidget = Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            Text(messageTime, style: Theme.of(context).textTheme.caption),
            Flexible(
                child: Container(
                    child: Text(
                      message.content,
                      style: TextStyle(color: white),
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
                    style: TextStyle(color: orange),
                  ),
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  decoration: BoxDecoration(
                      color: white, borderRadius: BorderRadius.circular(8.0)),
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                )),
                Text(messageTime, style: Theme.of(context).textTheme.caption)
              ]));
      if (widget.conversation.isGroup &&
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

  Widget _buildInput() {
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
                onPressed: () => _onSendMessage(_textController.text),
                color: orange,
              )),
          color: Colors.white)
    ]);
  }

  @override
  Widget build(final BuildContext context) {
    _appDataService = Provider.of<AppDataService>(context);
    _messageService = Provider.of<MessageService>(context);

    widget.conversation.markAsRead();

    _messageService.setConversations(Provider.of<ConversationList>(context));
    return StreamBuilder<Entity>(
        stream: widget.conversation.streamEntity(),
        builder: (BuildContext context, AsyncSnapshot<Entity> entity) {
          return entity.connectionState == ConnectionState.waiting
              ? Loading()
              : View(
                  title:
                      entity.data.name.isEmpty ? 'Anonymous' : entity.data.name,
                  child: Container(
                      decoration: background,
                      child: Column(children: <Widget>[
                        _buildConversation(),
                        _buildInput(),
                      ])));
        });
  }
}
