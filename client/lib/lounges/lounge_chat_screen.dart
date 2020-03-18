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
import 'package:intl/intl.dart' as date_formater;
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
                                    style: const TextStyle(
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
                                  style: const TextStyle(
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
        reverse: false,
        itemCount: chat.messages.length,
        itemBuilder: (BuildContext context, int index) =>
            _buildMessage(chat.messages[chat.messages.length - index - 1]));
  }

  String _dateFormatter(int timestamp) {
    final DateTime time = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final int daysDifference = DateTime.now().difference(time).inDays;
    if (daysDifference < 7) {
      return date_formater.DateFormat(' E \'at\' kk:mm').format(time);
    }
    return date_formater.DateFormat('yyyy-MM-dd \'at\' kk:mm').format(time);
  }

  Widget _buildMessage(Message message) {
    final User user = widget.lounge.members.firstWhere((User user) {
      return user.id == message.idFrom;
    });
    return Container(
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.all(4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          textDirection: widget.lounge.owner == user.id
              ? TextDirection.rtl
              : TextDirection.ltr,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.all(5),
                child: CircularImage(
                  imageUrl: user.pics.isNotEmpty ? user.pics[0] : null,
                  imageRadius: 35.0,
                )),
            Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        color: pinkLight.withOpacity(
                            widget.lounge.owner == user.id ? 0.7 : 0.4),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                child: RichText(
                              text: TextSpan(
                                text: widget.lounge.members
                                    .firstWhere((User user) {
                                  return user.id == message.idFrom;
                                }).name,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                            )),
                            Container(
                                child: RichText(
                              text: TextSpan(
                                text: _dateFormatter(message.timestamp),
                                style: const TextStyle(
                                    color: Colors.black38,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                            )),
                          ],
                        )),
                        Container(
                            padding: const EdgeInsets.only(top: 5),
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                text: message.content,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                            ))
                      ],
                    )))
          ],
        ));
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
                          Expanded(child: Container(child: _buildChat(chat)))
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
