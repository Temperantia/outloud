import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inclusive/appdata.dart';
import 'package:inclusive/models/messageModel.dart';
import 'package:inclusive/models/userModel.dart';
import 'package:inclusive/models/groupModel.dart';
import 'package:inclusive/theme.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Conversation {
  final String id;
  int lastRead = 0;

  Conversation(this.id);
}

class MessagingScreen extends StatefulWidget {
  @override
  _MessagingState createState() => _MessagingState();
}

class _MessagingState extends State<MessagingScreen> {
  AppData appDataProvider;
  MessageModel messageProvider;
  UserModel userProvider;
  GroupModel groupProvider;

  Conversation current;
  String peerId;
  bool isGroup;
  List<Conversation> conversations = [
    Conversation('apmbMHvueWZDLeAOxaxI-cx0hEmwDTLWYy3COnvPL'),
    Conversation('BHpAnkWabxJFoY1FbM57'),
  ];
  DateTime lastMessageTime;
  Message lastMessage;

  final DateFormat messageTimeFormat = DateFormat.jm();
  final DateFormat messageDateFormat = DateFormat.yMd();

  final ScrollController listScrollController = ScrollController();
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (conversations.isNotEmpty) {
      current = conversations[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    messageProvider = Provider.of<MessageModel>(context);
    appDataProvider = Provider.of<AppData>(context);
    userProvider = Provider.of<UserModel>(context);
    groupProvider = Provider.of<GroupModel>(context);

    return current == null
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
            ],
          );
  }

  getPeerInfo() async {
    if (current.id.contains('-')) {
      peerId = getPeerId(current.id);
      isGroup = false;
      return userProvider.getUser(peerId);
    }
    peerId = current.id;
    isGroup = true;
    return groupProvider.getGroup(peerId);
  }

  String getPeerId(String conversation) {
    final List<String> ids = conversation.split('-');

    return appDataProvider.identifier == ids[0] ? ids[1] : ids[0];
  }

  void onChangeConversation(Conversation conversation) {
    current = conversation;
    setState(() {
      textController.clear();
    });
  }

  void onSendMessage(String text) {
    if (text.trim() != '') {
      textController.clear();

      messageProvider.addMessage(current.id, appDataProvider.identifier, text);
      if (!isGroup) {
        userProvider.ping(appDataProvider.identifier, peerId);
      }
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  void onCloseConversation(Conversation conversation) {
    final int index = conversations.indexOf(conversation);
    setState(() {
      conversations.remove(conversation);
      if (conversations.isEmpty) {
        current = null;
      } else if (index == conversations.length) {
        current = conversations[index - 1];
      } else {
        current = conversations[index];
      }
    });
  }

  Widget buildConversationIcons() {
    return StreamBuilder(
        stream: userProvider.streamPings(appDataProvider.identifier),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> query) =>
            query.connectionState == ConnectionState.waiting
                ? CircularProgressIndicator(
                    backgroundColor: orange,
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width),
                      child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            children: buildIcons(query.data.documents),
                          )),
                    )));
  }

  List<Widget> buildIcons(List<DocumentSnapshot> pings) {
    List<Widget> icons = [];
    Widget icon;

    for (final Conversation conversation in conversations) {
      icon = Container(
        decoration: BoxDecoration(
            color: conversation == current ? orange : Colors.transparent,
            borderRadius: BorderRadius.circular(90.0)),
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: SvgPicture.asset(
          'images/profile.svg',
          color: white,
        ),
      );
      if (current == conversation) {
        icon = GestureDetector(
            onTap: () => onCloseConversation(conversation),
            child: Badge(
                position: BadgePosition.bottomRight(),
                badgeColor: Colors.orange,
                padding: EdgeInsets.all(0.0),
                badgeContent: Icon(Icons.close, color: white, size: 20.0),
                child: icon));
      }
      if (pings.isNotEmpty) {
        final String conversationPeerId = getPeerId(conversation.id);
        final int index = pings
            .map((DocumentSnapshot doc) => doc.documentID)
            .toList()
            .indexOf(conversationPeerId);
        if (index != -1) {
          if (current == conversation) {
            userProvider.markPingAsRead(
                appDataProvider.identifier, conversationPeerId);
          } else {
            icon = Badge(
              badgeColor: orange,
              badgeContent: Text(pings[index]['value'].toString(),
                  style: Theme.of(context).textTheme.caption),
              child: icon,
            );
          }
        }
      }
      icons.add(GestureDetector(
        onTap: () => onChangeConversation(conversation),
        child: icon,
      ));
    }
    return icons;
  }

  Widget buildConversation() {
    return FutureBuilder(
        future: getPeerInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(
              backgroundColor: orange,
            );
          }
          final dynamic peerData = snapshot.data;
          return Expanded(
              child: Column(children: [
            buildBanner(peerData),
            Expanded(
                child: StreamBuilder(
              stream: messageProvider.streamMessages(current.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(orange)));
                } else {
                  final List<dynamic> messages = snapshot.data.documents
                      .map((final DocumentSnapshot doc) =>
                          Message.fromMap(doc.data))
                      .toList();
                  return ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => buildItem(
                        index, messages[index], messages.length, peerData),
                    itemCount: messages.length,
                    controller: listScrollController,
                  );
                }
              },
            )),
            buildInput()
          ]));
        });
  }

  Widget buildBanner(final dynamic data) {
    return Row(children: [
      Expanded(
          child: Container(
              decoration: BoxDecoration(color: orange),
              child: Text(
                data.name,
                style: Theme.of(context).textTheme.title,
                textAlign: TextAlign.center,
              )))
    ]);
  }

  Widget buildInput() {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Row(children: [
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
      ]),
    );
  }

  Widget buildItem(int index, Message message, int total, dynamic peerData) {
    final DateTime messageDateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(message.timestamp));
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
    if (appDataProvider.identifier == message.idFrom) {
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
      if (isGroup && (index == 0 || message.idFrom != lastMessage.idFrom)) {
        items.add(FutureBuilder(
            future: userProvider.getUser(message.idFrom),
            builder: (BuildContext context, AsyncSnapshot<User> user) =>
                Row(children: [
                  Text(
                      user.connectionState == ConnectionState.waiting
                          ? ''
                          : user.data == null ? 'Anonymous' : user.data.name,
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
