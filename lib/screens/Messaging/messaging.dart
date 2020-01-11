import 'package:flutter/material.dart';
import 'package:inclusive/classes/conversation.dart';
import 'package:inclusive/classes/conversation_list.dart';
import 'package:inclusive/classes/entity.dart';
import 'package:inclusive/screens/Messaging/conversation.dart';
import 'package:inclusive/services/message.dart';
import 'package:inclusive/theme.dart';
import 'package:provider/provider.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({Key key}) : super(key: key);

  @override
  MessagingState createState() => MessagingState();
}

class MessagingState extends State<MessagingScreen> {
  MessageService messageService;
  ConversationList conversationList;

  void onCloseConversation() {
    setState(() {
      messageService.closeCurrentConversation(conversationList.conversations);
    });
  }

  Widget buildConversation(BuildContext context, int index) {
    final Conversation conversation = conversationList.conversations[index];
    return StreamBuilder<Entity>(
        stream: conversation.streamPeerInfo(),
        builder: (BuildContext context, AsyncSnapshot<Entity> snap) =>
            snap.connectionState == ConnectionState.waiting
                ? Container()
                : Card(
                    color: orange,
                    child: GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, ConversationScreen.id,
                            arguments: conversation),
                        child: Container(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: <Widget>[Text(snap.data.name)],
                            )))));
  }

  @override
  Widget build(BuildContext context) {
    messageService = Provider.of<MessageService>(context);
    conversationList = Provider.of<ConversationList>(context);

    return conversationList.conversations.isEmpty
        ? Center(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('Swipe right to find someone to chat with',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.title)))
        : ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                buildConversation(context, index),
            itemCount: conversationList.conversations.length);
  }
}
