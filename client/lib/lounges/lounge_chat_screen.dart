import 'package:async_redux/async_redux.dart';
import 'package:business/classes/user.dart';
import 'package:flutter/widgets.dart';
import 'package:business/app_state.dart';
import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/classes/lounge.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/message.dart';
import 'package:business/models/message.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/lounges/lounge_edit_screen.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/cached_image.dart';
import 'package:inclusive/widgets/circular_image.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class LoungeChatScreen extends StatefulWidget {
  const LoungeChatScreen(this.lounge);
  final Lounge lounge;
  static const String id = 'LoungeChatScreen';

  @override
  _LoungeChatScreenState createState() => _LoungeChatScreenState();
}

class _LoungeChatScreenState extends State<LoungeChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Widget _buildHeader(
      AppState state, void Function(ReduxAction<AppState>) dispatch) {
    final User owner = widget.lounge.members
        .firstWhere((User member) => member.id == widget.lounge.owner);
    return Container(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: <Widget>[
            if (widget.lounge.event.pic.isNotEmpty)
              Flexible(flex: 2, child: CachedImage(widget.lounge.event.pic)),
            Flexible(
                flex: 8,
                child: Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      children: <Widget>[
                        Container(
                            child: Row(
                          children: <Widget>[
                            Container(
                                child: CircularImage(
                              imageUrl:
                                  owner.pics.isNotEmpty ? owner.pics[0] : null,
                              imageRadius: 40.0,
                            )),
                            Container(
                                padding: const EdgeInsets.only(left: 10),
                                child: RichText(
                                  text: TextSpan(
                                    text: state.userState.user.id == owner.id
                                        ? 'Your Lounge'
                                        : owner.name + '\'s Lounge',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ))
                          ],
                        )),
                        Container(
                            child: Row(
                          children: <Widget>[
                            Container(
                                child: RichText(
                              text: TextSpan(
                                  text:
                                      widget.lounge.members.length.toString() +
                                          ' member' +
                                          (widget.lounge.members.length > 1
                                              ? 's '
                                              : ' '),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: widget.lounge.event.name,
                                        style: TextStyle(
                                            color: Colors.greenAccent,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800))
                                  ]),
                            ))
                          ],
                        ))
                      ],
                    ))),
            Flexible(
                flex: 1,
                child: Container(
                    child: state.userState.user.id == owner.id
                        ? IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              dispatch(redux.NavigateAction<AppState>.pushNamed(
                                  LoungeEditScreen.id,
                                  arguments: widget.lounge));
                            })
                        : IconButton(icon: Icon(Icons.block), onPressed: null)))
          ],
        ));
  }

  Widget _buildChat(Chat chat) {
    return ListView.builder(
        reverse: true,
        itemCount: chat.messages.length,
        itemBuilder: (BuildContext context, int index) =>
            _buildMessage(chat.messages[index]));
  }

  Widget _buildMessage(Message message) {
    return Text(message.content);
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<dynamic>) dispatch,
        Widget child) {
      final Chat chat = state.chatsState.loungeChats
          .firstWhere((Chat chat) => chat.id == widget.lounge.id);
      return View(
          title: 'LOUNGE CHAT',
          child: Container(
              child: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                      color: white,
                      child: Container(
                          child: Column(
                        children: <Widget>[
                          _buildHeader(state, dispatch),
                          const Divider(),
                          Expanded(child: _buildChat(chat))
                        ],
                      )))),
              Row(
                children: <Widget>[
                  Expanded(child: TextField(controller: _messageController)),
                  GestureDetector(
                      onTap: () {
                        addMessage(widget.lounge.id, state.loginState.id,
                            _messageController.text);
                        _messageController.clear();
                      },
                      child: Icon(Icons.message)),
                ],
              )
            ],
          )));
    });
  }
}
