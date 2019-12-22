import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inclusive/theme.dart';

class Message {
  String text;
  Message(this.text);
}

class Conversation {
  List<Message> messages;
  Conversation(this.messages);
}

class MessagingScreen extends StatefulWidget {
  @override
  _MessagingState createState() => _MessagingState();
}

class _MessagingState extends State<MessagingScreen> {
  List<Conversation> conversations = [
    Conversation([
      Message('ok'),
    ]),
    Conversation([
      Message('ko'),
      Message('k'),
    ])
  ];
  int current = 0;
  String message = '';

  List<Widget> buildConversationIcons() {
    List<Widget> conversationIcons = [];

    for (int i = 0; i < conversations.length; i++) {
      conversationIcons.add(GestureDetector(
        onTap: () {
          setState(() => current = i);
        },
        child: Container(
          padding: EdgeInsets.all(30),
          child: SvgPicture.asset(
            'images/profile.svg',
            color: white,
          ),
        ),
      ));
    }

    return conversationIcons;
  }

  List<Widget> buildConversation() {
    List<Widget> conversation = [];
    if (conversations.length == 0) {
      return conversation;
    }
    Conversation currentConversation = conversations[current];
    for (int i = 0; i < currentConversation.messages.length; i++) {
      conversation.add(Text(currentConversation.messages[i].text));
    }
    return conversation;
  }

  @override
  Widget build(BuildContext context) {
    /* return Column(children: [Flexible(child: StreamBuilder(
      stream: Firestore.instance
          .collection('messages')
          //.document(groupChatId)
          //.collection(groupChatId)
          .orderBy('timestamp', descending: true)
          .limit(20)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(orange)));
        } else {
          return ListView.builder(
            itemBuilder: (context, index) =>
                buildItem(index, snapshot.data.documents[index]),
            itemCount: snapshot.data.documents.length,
          );
        }
      },
    ))]); */
    return Stack(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: buildConversationIcons(),
            ),
          ),
              Flexible(child: StreamBuilder(
                stream: Firestore.instance
                    .collection('messages')
                    //.document(groupChatId)
                    //.collection(groupChatId)
                    .limit(20)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(orange)));
                  } else {
                    return ListView.builder(
                      itemBuilder: (context, index) =>
                          buildItem(index, snapshot.data.documents[index]),
                      itemCount: snapshot.data.documents.length,
                    );
                  }
                },
              )),
          /*
        SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: buildConversation(),
            )),
            */
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Row(children: [
              Flexible(
                  flex: 6,
                  child: TextField(onChanged: (value) => message = value)),
              Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => null,
                color: orange,
              ),
            ),
            color: Colors.white,
          ),
            ]),
          )
        ],
      )
    ]);
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    // Right (my message)
    return Row(
      children: <Widget>[
        Container(
          child: Text(
            document['content'],
            style: TextStyle(color: white),
          ),
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          decoration: BoxDecoration(
              color: orange, borderRadius: BorderRadius.circular(8.0)),
          margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
            )
      ],
      mainAxisAlignment: MainAxisAlignment.end,
    );
  }
}
