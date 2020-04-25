import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:business/classes/chat_state.dart';
import 'package:business/classes/message_state.dart';
import 'package:business/classes/user.dart';
import 'package:business/lounges/actions/lounge_leave_action.dart';
import 'package:business/chats/actions/chats_lounge_read_action.dart';
import 'package:flutter/widgets.dart';
import 'package:business/app_state.dart';
import 'package:async_redux/async_redux.dart'
    show ReduxAction, NavigateAction, Store;
import 'package:business/classes/lounge.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/message.dart';
import 'package:business/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:outloud/lounges/lounge_view_screen.dart';
import 'package:outloud/profile/profile_screen.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/button.dart';
import 'package:outloud/widgets/cached_image.dart';
import 'package:outloud/widgets/content_list.dart';
import 'package:outloud/widgets/event_image.dart';
import 'package:outloud/widgets/view.dart';
import 'package:intl/intl.dart' as date_formater;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class LoungeChatScreen extends StatefulWidget {
  const LoungeChatScreen(this.lounge);
  final Lounge lounge;
  static const String id = 'LoungeChatScreen';

  @override
  _LoungeChatScreenState createState() => _LoungeChatScreenState();
}

class _LoungeChatScreenState extends State<LoungeChatScreen>
    with TickerProviderStateMixin {
  void Function(ReduxAction<AppState>) _dispatch;
  Lounge _lounge;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _markAsRead(
      Map<String, Map<String, ChatState>> loungesChatsStates, String userId) {
    final bool isReceived = loungesChatsStates[userId][widget.lounge.id]
        ?.messageStates
        ?.containsValue(MessageState.Received);
    if (isReceived != null) {
      _dispatch(ChatsLoungeReadAction(widget.lounge.id));
    }
  }

  void _showConfirmPopup(String userId) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => Dialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Stack(children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: const Offset(0.0, 10.0))
                      ]),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    const Icon(MdiIcons.trashCan, color: orange, size: 60),
                    AutoSizeText(
                        FlutterI18n.translate(
                            context, 'LOUNGE_CHAT.LEAVE_LOUNGE'),
                        style: const TextStyle(
                            color: orange,
                            fontSize: 26,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 15),
                    Container(
                        padding: const EdgeInsets.only(left: 18, right: 18),
                        child: AutoSizeText(
                            FlutterI18n.translate(
                                context, 'LOUNGE_CHAT.LEAVE_WARNING'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500))),
                    Container(
                        padding: const EdgeInsets.only(
                            left: 18, right: 18, bottom: 15),
                        child: AutoSizeText(
                            FlutterI18n.translate(
                                context, 'LOUNGE_CHAT.LEAVE_CONFIRMATION'),
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500))),
                    SizedBox(
                        child: Container(
                            color: orange,
                            child: Column(children: <Widget>[
                              Container(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: FlatButton(
                                          color: white,
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: AutoSizeText(
                                                  FlutterI18n.translate(context,
                                                      'LOUNGE_CHAT.TAKE_ME_BACK'),
                                                  style: const TextStyle(
                                                      color: orange,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500)))))),
                              Container(
                                  padding:
                                      const EdgeInsets.only(bottom: 5, top: 5),
                                  child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: FlatButton(
                                          onPressed: () async {
                                            /* await showLoaderAnimation(
                                                context, this,
                                                animationDuration: 600); */
                                            _dispatch(LoungeLeaveAction(
                                                userId, _lounge));
                                            Navigator.pop(context);
                                            _dispatch(
                                                NavigateAction<AppState>.pop());
                                          },
                                          child: AutoSizeText(
                                              FlutterI18n.translate(context,
                                                  'LOUNGE_CHAT.LEAVE_YES'),
                                              style: const TextStyle(
                                                  color: white,
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.w500)))))
                            ])))
                  ]))
            ])));
  }

  Widget _buildHeader(String userId) {
    if (_lounge == null || _lounge.members == null) {
      return Container(width: 0.0, height: 0.0);
    }
    final User owner = _lounge.members.firstWhere(
        (User member) => member.id == _lounge.owner,
        orElse: () => null);
    if (owner == null) {
      return Container(width: 0.0, height: 0.0);
    }
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            EventImage(image: _lounge.event.pic, hasOverlay: false, size: 40.0),
            if (userId == owner.id)
              GestureDetector(
                  onTap: () => _dispatch(NavigateAction<AppState>.pushNamed(
                          LoungeViewScreen.id,
                          arguments: <String, dynamic>{
                            'lounge': _lounge,
                            'isEdit': true
                          })),
                  child: Column(children: <Widget>[
                    const Icon(MdiIcons.calendarEdit, color: orange),
                    AutoSizeText(
                        FlutterI18n.translate(context, 'LOUNGE_CHAT.EDIT'),
                        style: const TextStyle(
                            color: orange, fontWeight: FontWeight.bold))
                  ]))
            else
              Row(children: <Widget>[
                Button(
                    text: FlutterI18n.translate(context, 'LOUNGE_CHAT.VIEW'),
                    colorText: white,
                    backgroundOpacity: 1.0,
                    backgroundColor: orange),
                /* GestureDetector(
                    onTap: () => _showConfirmPopup(userId),
                    child: Container(
                        margin:
                            const EdgeInsets.only(left: 5, right: 10, top: 10),
                        child: Column(children: <Widget>[
                          const Icon(MdiIcons.arrowLeftBoldCircleOutline,
                              color: orange),
                          AutoSizeText(
                              FlutterI18n.translate(context, 'LOUNGE_CHAT.LEAVE'),
                              style: const TextStyle(
                                  color: orange,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold)),
                          AutoSizeText(
                              FlutterI18n.translate(
                                  context, 'LOUNGE_CHAT.LOUNGE'),
                              style: const TextStyle(
                                  color: orange,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold))
                        ]))),
                GestureDetector(
                    onTap: () => _dispatch(NavigateAction<AppState>.pushNamed(
                            LoungeViewScreen.id,
                            arguments: <String, dynamic>{
                              'lounge': _lounge,
                              'isEdit': false
                            })),
                    child: Container(
                        margin: const EdgeInsets.only(left: 5, top: 10),
                        child: Column(children: <Widget>[
                          const Icon(MdiIcons.viewCarousel, color: orange),
                          AutoSizeText(
                              FlutterI18n.translate(context, 'LOUNGE_CHAT.VIEW'),
                              style: const TextStyle(
                                  color: orange,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold)),
                          AutoSizeText(
                              FlutterI18n.translate(
                                  context, 'LOUNGE_CHAT.DETAILS'),
                              style: const TextStyle(
                                  color: orange,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold))
                        ]))) */
              ])
          ]),
    );
  }

  Widget _buildChat(Chat chat) => ContentList(
      controller: _scrollController,
      withBorders: false,
      items: chat.messages,
      builder: (dynamic message) => _buildMessage(message as Message));

  String _dateFormatter(int timestamp) {
    final DateTime time = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final int daysDifference = DateTime.now().difference(time).inDays;
    if (daysDifference < 7) {
      return date_formater.DateFormat(' E \'at\' kk:mm').format(time);
    }
    return date_formater.DateFormat('yyyy-MM-dd \'at\' kk:mm').format(time);
  }

  Widget _buildMessage(Message message) {
    final User user = _lounge.members.firstWhere(
        (User user) => user.id == message.idFrom,
        orElse: () => null);
    if (user == null) {
      return Container(width: 0.0, height: 0.0);
    }
    return Container(
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.all(4),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            textDirection: _lounge.owner == user.id
                ? TextDirection.rtl
                : TextDirection.ltr,
            children: <Widget>[
              GestureDetector(
                  onTap: () => _dispatch(NavigateAction<AppState>.pushNamed(
                      ProfileScreen.id,
                      arguments: <String, dynamic>{'user': user})),
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      child: CachedImage(
                          user.pics.isEmpty ? null : user.pics[0],
                          width: 35.0,
                          height: 35.0,
                          borderRadius: BorderRadius.circular(20.0),
                          imageType: ImageType.User))),
              Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          color: pinkLight.withOpacity(
                              _lounge.owner == user.id ? 0.7 : 0.4),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 10, bottom: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  AutoSizeText(user.name,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                  AutoSizeText(
                                      _dateFormatter(message.timestamp),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400))
                                ]),
                            Container(
                                padding: const EdgeInsets.only(top: 5),
                                child: AutoSizeText(message.content,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400)))
                          ])))
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<AppState>) dispatch,
        Widget child) {
      _dispatch = dispatch;
      _lounge = state.userState.lounges.firstWhere(
          (Lounge lounge) => lounge.id == widget.lounge.id,
          orElse: () => null);
      Chat chat;
      if (_lounge != null) {
        chat = state.chatsState.loungeChats.firstWhere(
            (Chat chat) => chat.id == _lounge.id,
            orElse: () => null);
      }
      final String userId = state.userState.user.id;

      _markAsRead(state.chatsState.loungesChatsStates, userId);

      return View(
          title: FlutterI18n.translate(context, 'LOUNGE_CHAT.LOUNGE_CHAT'),
          buttons: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                  color: orangeLight.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(5.0)),
              child: Row(children: <Widget>[
                /*   Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {}, child: Icon(Icons.add, color: white))), */
                Expanded(
                    child: Column(children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: _messageController,
                          decoration: InputDecoration.collapsed(
                              hintText: FlutterI18n.translate(
                                  context, 'LOUNGE_CHAT.MESSAGE'),
                              hintStyle: const TextStyle(color: white))))
                ])),
                /*   Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {},
                        child:
                            const Icon(MdiIcons.stickerEmoji, color: white))), */
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {
                          addMessage(_lounge.id, state.loginState.id,
                              _messageController.text, MessageType.Text);
                          _messageController.clear();
                          Timer(
                              const Duration(milliseconds: 250),
                              () => _scrollController.jumpTo(
                                  _scrollController.position.maxScrollExtent));
                        },
                        child: Icon(Icons.send, color: white)))
              ])),
          child: Column(children: <Widget>[
            _buildHeader(userId),
            const Divider(color: orange),
            if (chat != null) Expanded(child: _buildChat(chat)),
          ]));
    });
  }
}
