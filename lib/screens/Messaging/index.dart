import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inclusive/screens/appdata.dart';
import 'package:inclusive/theme.dart';

class MessagingScreen extends StatefulWidget {
  @override
  _MessagingState createState() => _MessagingState();
}

class _MessagingState extends State<MessagingScreen> {
  String current;
  List<String> conversations = [
    'ea23JLKjsdjf',
    'jsldjfkljezer',
    'sdjkfjk',
    'sdlkfjlkj',
    'sdfkljlskdjf',
    'jsldkjflk',
    'jlskjdflkj',
    'sjdlfjlkej',
    'sjdflmkjmlk',
    'sjdlfjs',
  ];

  final ScrollController listScrollController = ScrollController();
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    current = conversations[0];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildConversationIcons(),
        buildConversation(),
        buildInput(),
      ],
    );
  }

  onSendMessage(String text) {
    if (text.trim() != '') {
      textController.clear();

      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      var documentReference = Firestore.instance
          .collection('messages')
          .document(current)
          .collection(current)
          .document(timestamp);

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': appData.identifier,
            'timestamp': timestamp,
            'content': text,
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Widget buildConversationIcons() {
    List<Widget> conversationIcons = [];

    for (int i = 0; i < conversations.length; i++) {
      conversationIcons.add(GestureDetector(
        onTap: () {
          setState(() {
            current = conversations[i];
            textController.clear();
          });
        },
        child: Container(
          decoration: BoxDecoration(
              color: conversations[i] == current ? orange : Colors.transparent,
              borderRadius: BorderRadius.circular(90.0)),
          padding: EdgeInsets.all(20),
          child: SvgPicture.asset(
            'images/profile.svg',
            color: white,
          ),
        ),
      ));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: conversationIcons,
          )),
    );
  }

  Widget buildConversation() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('messages')
          .document(current)
          .collection(current)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(orange)));
        } else {
          return Expanded(
              child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) =>
                buildItem(index, snapshot.data.documents[index]),
            itemCount: snapshot.data.documents.length,
            controller: listScrollController,
          ));
        }
      },
    );
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

  Widget buildItem(int index, DocumentSnapshot document) {
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
