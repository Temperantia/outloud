import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inclusive/services/appdata.dart';
import 'package:inclusive/models/messageModel.dart';
import 'package:inclusive/models/userModel.dart';
import 'package:inclusive/models/groupModel.dart';
import 'package:inclusive/services/message.dart';
import 'package:inclusive/theme.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MessagingScreen extends StatefulWidget {
  MessagingScreen({Key key}) : super(key: key);

  @override
  MessagingState createState() => MessagingState();
}

class MessagingState extends State<MessagingScreen> {
  AppDataService appDataService;
  MessageService messageService;
  MessageModel messageProvider;
  UserModel userProvider;
  GroupModel groupProvider;

  DateTime lastMessageTime;
  Message lastMessage;

  final DateFormat messageTimeFormat = DateFormat.jm();
  final DateFormat messageDateFormat = DateFormat.yMd();

  final ScrollController listScrollController = ScrollController();
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    appDataService = Provider.of<AppDataService>(context);
    messageService = Provider.of<MessageService>(context);
    messageProvider = Provider.of<MessageModel>(context);
    userProvider = Provider.of<UserModel>(context);
    groupProvider = Provider.of<GroupModel>(context);

    return messageService.currentConversation == null
        ? Center(
            child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('Swipe right to find someone to chat with',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.title)))
        : Column(
            children: [
              buildConversationIcons(),
              buildConversation(),
              buildInput()
            ],
          );
  }

  void onChangeConversation(final Conversation conversation) {
    if (conversation == messageService.currentConversation) {
      return;
    }
    setState(() {
      messageService.changeConversation(conversation);
    });
  }

  void onSendMessage(final String text) {
    if (text.trim() != '') {
      setState(() {
        textController.clear();
        messageService.sendMessage(text);
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  void onCloseConversation() {
    setState(() {
      messageService.closeCurrentConversation();
    });
  }

  Widget buildConversationIcons() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minWidth: MediaQuery.of(context).size.width),
          child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: buildIcons(),
              )),
        ));
  }

  List<Widget> buildIcons() {
    final List<Widget> icons = [];

    for (final Conversation conversation in messageService.conversations) {
      icons.add(conversation.isGroup
          ? GestureDetector(
              onTap: () => onChangeConversation(conversation),
              child: buildIcon(conversation,
                  0)) //query.data == null ? 0 : query.data.length, pings))
          : GestureDetector(
              onTap: () => onChangeConversation(conversation),
              child: buildIcon(conversation, 0)));
    }
    return icons;
  }

  Widget buildIcon(
      final Conversation conversation, final int newGroupMessages) {
    Widget icon;

    icon = Container(
      decoration: BoxDecoration(
          color: conversation == messageService.currentConversation
              ? orange
              : Colors.transparent,
          borderRadius: BorderRadius.circular(90.0)),
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Icon(
        Icons.person,
        color: white,
      ),
    );
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
          child: icon,
        );
      }
    }

    return icon;
  }

  Widget buildConversation() {
    return Expanded(
        child: Column(children: [
      buildBanner(),
      Expanded(
          child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) => buildItem(index),
        itemCount: messageService.currentConversation.messages.length,
        controller: listScrollController,
      ))
    ]));
  }

  Widget buildBanner() {
    return Row(children: [
      Expanded(
          child: Container(
              decoration: BoxDecoration(color: orange),
              child: Text(
                messageService.currentConversation.isGroup
                    ? messageService.currentConversation.group.name
                    : messageService.currentConversation.userPeer.name,
                style: Theme.of(context).textTheme.title,
                textAlign: TextAlign.center,
              )))
    ]);
  }

  Widget buildInput() {
    return Row(children: [
      Flexible(
          flex: 6,
          child: Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(controller: textController))),
      Material(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton(
            icon: Icon(Icons.send),
            onPressed: () => onSendMessage(textController.text),
            color: orange,
          ),
        ),
        color: Colors.white,
      ),
    ]);
  }

  Widget buildItem(int index) {
    final Message message = messageService.currentConversation.messages[index];
    final DateTime messageDateTime =
        DateTime.fromMillisecondsSinceEpoch(message.timestamp);
    final String messageTime = messageTimeFormat.format(messageDateTime);
    List<Widget> items = [];

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
          margin: EdgeInsets.only(bottom: 10.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text(messageTime, style: Theme.of(context).textTheme.caption),
            Flexible(
                child: Container(
              child: Text(
                message.content,
                style: TextStyle(color: white),
              ),
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              decoration: BoxDecoration(
                  color: orange, borderRadius: BorderRadius.circular(8.0)),
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
            ))
          ]));
    } else {
      messageWidget = Container(
          margin: EdgeInsets.only(bottom: 10.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Flexible(
                child: Container(
              child: Text(
                message.content,
                style: TextStyle(color: orange),
              ),
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              decoration: BoxDecoration(
                  color: white, borderRadius: BorderRadius.circular(8.0)),
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
            )),
            Text(messageTime, style: Theme.of(context).textTheme.caption)
          ]));
      if (messageService.currentConversation.isGroup &&
          (index == 0 || message.idFrom != lastMessage.idFrom)) {
        items.add(Container(
            margin: EdgeInsets.only(left: 20.0),
            child: Row(children: [
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
}
