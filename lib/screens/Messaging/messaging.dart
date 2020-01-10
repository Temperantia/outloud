import 'package:flutter/material.dart';
import 'package:inclusive/classes/conversation.dart';
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
  List<Conversation> conversations;

  void onCloseConversation() {
    setState(() {
      messageService.closeCurrentConversation(conversations);
    });
  }

  Widget buildConversation(BuildContext context, int index) {
    final Conversation conversation = conversations[index];
    return Card(
        color: orange,
        child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, ConversationScreen.id,
                arguments: conversation),
            child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[Text(conversation.peerData.name)],
                ))));
  }

  @override
  Widget build(BuildContext context) {
    messageService = Provider.of<MessageService>(context);
    conversations = Provider.of<List<Conversation>>(context);
    return conversations.isEmpty
        ? Center(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('Swipe right to find someone to chat with',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.title)))
        : ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                buildConversation(context, index),
            itemCount: conversations.length);
  }
}
