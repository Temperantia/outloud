import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inclusive/widgets/background.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:inclusive/classes/conversation.dart';
import 'package:inclusive/classes/message.dart';
import 'package:inclusive/services/app_data.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/services/message.dart';
import 'package:inclusive/theme.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({this.conversation});
  static const String id = 'Conversation';
  final Conversation conversation;
  @override
  ConversationState createState() => ConversationState();
}

class ConversationState extends State<ConversationScreen> {
  final DateFormat messageTimeFormat = DateFormat.jm();
  final DateFormat messageDateFormat = DateFormat.yMd();

  final ScrollController listScrollController = ScrollController();
  final TextEditingController textController = TextEditingController();

  AppDataService appDataService;
  MessageService messageService;
  UserModel userProvider;

  DateTime lastMessageTime;
  Message lastMessage;

  void onSendMessage(final String text) {
    if (text.trim() != '') {
      setState(() {
        textController.clear();
        messageService.sendMessage(text);
        listScrollController.animateTo(0.0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }
/* 
  Widget buildConversationIcons() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
            constraints:
                BoxConstraints(minWidth: MediaQuery.of(context).size.width),
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(children: buildIcons()))));
  }

  List<Widget> buildIcons() {
    final List<Widget> icons = <Widget>[];

    for (final Conversation conversation in conversations) {
      icons.add(GestureDetector(
          onTap: () => onChangeConversation(conversation),
          child: buildIcon(conversation)));
    }
    return icons;
  }

  Widget buildIcon(final Conversation conversation) {
    Widget icon;

    icon = Container(
        decoration: BoxDecoration(
            color: conversation == messageService.currentConversation
                ? orange
                : Colors.transparent,
            borderRadius: BorderRadius.circular(90.0)),
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(Icons.person, color: white));
    if (conversation.pings > 0) {
      if (messageService.currentConversation == conversation &&
          !conversation.isGroup) {
        userProvider.markPingAsRead(
            appDataService.identifier, conversation.idPeer);
      } else {
        icon = Badge(
            badgeColor: orange,
            badgeContent: Text(conversation.pings.toString(),
                style: Theme.of(context).textTheme.caption),
            child: icon);
      }
    }

    return icon;
  } */

  Widget buildConversation() {
    return Expanded(
        child: ListView.builder(
            reverse: true,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) => buildItem(index),
            itemCount: widget.conversation.messageList.messages.length,
            controller: listScrollController));
  }

  Widget buildInput() {
    return Row(children: <Widget>[
      Flexible(
          flex: 6,
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(controller: textController))),
      Material(
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textController.text),
                color: orange,
              )),
          color: Colors.white)
    ]);
  }

  Widget buildItem(int index) {
    final Message message = widget.conversation.messageList.messages[index];
    final DateTime messageDateTime =
        DateTime.fromMillisecondsSinceEpoch(message.timestamp);
    final String messageTime = messageTimeFormat.format(messageDateTime);
    final List<Widget> items = <Widget>[];

    if (index == 0 ||
        (lastMessageTime.day != messageDateTime.day ||
            lastMessageTime.month != messageDateTime.month ||
            lastMessageTime.year != messageDateTime.year)) {
      items.add(Text(messageDateFormat.format(messageDateTime),
          style: Theme.of(context).textTheme.caption));
    }

    Widget messageWidget;
    if (appDataService.identifier == message.idFrom) {
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
      if (messageService.currentConversation.isGroup &&
          (index == 0 || message.idFrom != lastMessage.idFrom)) {
        items.add(Container(
            margin: const EdgeInsets.only(left: 20.0),
            child: Row(children: <Widget>[
              Text(message.author == null ? 'Anonymous' : message.author.name,
                  style: Theme.of(context).textTheme.caption)
            ])));
      }
    }

    items.add(messageWidget);
    lastMessageTime = messageDateTime;
    lastMessage = message;
    return Column(children: items);
  }

  @override
  Widget build(final BuildContext context) {
    appDataService = Provider.of<AppDataService>(context);
    messageService = Provider.of<MessageService>(context);
    userProvider = Provider.of<UserModel>(context);

    return Scaffold(
        appBar: AppBar(
            centerTitle: true, title: Text(widget.conversation.peerData.name)),
        body: SafeArea(
            child: Container(
                decoration: background,
                child: Column(
                    children: <Widget>[buildConversation(), buildInput()]))));
  }
}
