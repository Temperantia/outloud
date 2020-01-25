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
        actions: <Widget>[
          IconSlideAction(
              caption: conversation.pinned ? 'Unpin' : 'Pin',
              icon: Icons.pin_drop,
              onTap: () async {
                await _messageService.pinConversation(
                    conversation, _conversationList);
                setState(() {});
              })
        ],
        secondaryActions: <Widget>[
          IconSlideAction(
              caption: 'Close',
              icon: Icons.close,
              onTap: () async {
                await _messageService.closeConversation(
                    conversation, _conversationList);
                setState(() {});
              })
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
                          Text(entity.name.isEmpty ? 'Anonymous' : entity.name,
                              style: Theme.of(context).textTheme.caption),
                          Flexible(
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Text(
                                      lastMessage == null
                                          ? ''
                                          : lastMessage.content,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption))),
                          Text(lastMessageDateTime ?? '',
                              style: Theme.of(context).textTheme.caption),
                          if (conversation.pings > 0)
                            Text(conversation.pings.toString())
                        ])))));
  }

  @override
  Widget build(BuildContext context) {
    _messageService = Provider.of<MessageService>(context);
    _conversationList = Provider.of<ConversationList>(context);
    if (_conversationList.conversations.isEmpty)
      return Center(
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('Swipe right to find someone to chat with',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.title)));
    _conversationList.conversations
        .sort((Conversation conversation1, Conversation conversation2) {
      if (conversation1.pinned && !conversation2.pinned) {
        return -1;
      } else if (!conversation1.pinned && conversation2.pinned) {
        return 1;
      }
      return 0;
    });

    return ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            _streamConversation(context, index),
        itemCount: _conversationList.conversations.length);
  }
}
