import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart';

import 'package:inclusive/classes/conversation.dart';
import 'package:inclusive/classes/conversation_list.dart';
import 'package:inclusive/classes/entity.dart';
import 'package:inclusive/classes/message.dart';
import 'package:inclusive/screens/Messaging/conversation.dart';
import 'package:inclusive/services/message.dart';
import 'package:inclusive/theme.dart';

class Messaging extends StatefulWidget {
  const Messaging({Key key}) : super(key: key);

  @override
  _MessagingState createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  MessageService _messageService;
  ConversationList _conversationList;

  Widget _streamConversation(BuildContext context, int index) {
    final Conversation conversation = _conversationList.conversations[index];
    return MultiProvider(
        providers: <StreamProvider<dynamic>>[
          StreamProvider<Entity>.value(
            value: conversation.streamEntity(),
          ),
          StreamProvider<Message>.value(
            value: conversation.streamLastMessage(),
          )
        ],
        child: Consumer2<Entity, Message>(
            builder: (BuildContext context, Entity entity, Message lastMessage,
                    Widget w) =>
                entity == null
                    ? Container()
                    : _buildConversation(conversation, entity, lastMessage)));
  }

  Widget _buildConversation(
      Conversation conversation, Entity entity, Message lastMessage) {
    final String lastMessageDateTime = lastMessage == null
        ? null
        : format(DateTime.fromMillisecondsSinceEpoch(lastMessage.timestamp));
    return Slidable(
        actionPane: const SlidableDrawerActionPane(),
        secondaryActions: <Widget>[
          IconSlideAction(
              caption: 'Close',
              icon: Icons.close,
              onTap: () => setState(() => _messageService.closeConversation(
                  conversation, _conversationList)))
        ],
        child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, ConversationScreen.id,
                arguments: conversation),
            child: Card(
                color: orange,
                child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(entity.name),
                          Text(lastMessage == null ? '' : lastMessage.content),
                          Text(lastMessageDateTime ?? '')
                        ])))));
  }

  @override
  Widget build(BuildContext context) {
    _messageService = Provider.of<MessageService>(context);
    _conversationList = Provider.of<ConversationList>(context);
    return _conversationList.conversations.isEmpty
        ? Center(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('Swipe right to find someone to chat with',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.title)))
        : ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                _streamConversation(context, index),
            itemCount: _conversationList.conversations.length);
  }
}
