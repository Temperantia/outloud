import 'package:async_redux/async_redux.dart';
import 'package:business/classes/user.dart';
import 'package:business/lounges/actions/lounge_leave_action.dart';
import 'package:flutter/widgets.dart';
import 'package:business/app_state.dart';
import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/classes/lounge.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/message.dart';
import 'package:business/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:outloud/functions/loader_animation.dart';
import 'package:outloud/lounges/lounge_edit_screen.dart';
import 'package:outloud/lounges/lounge_view_screen.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/cached_image.dart';
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
  Lounge _lounge;
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Widget _buildHeader(
      AppState state, void Function(ReduxAction<AppState>) dispatch) {
    if (_lounge == null || _lounge.members == null) {
      return Container();
    }
    final User owner = _lounge.members.firstWhere(
        (User member) => member.id == _lounge.owner,
        orElse: () => null);
    if (owner == null) {
      return Container();
    }
    return Container(
        padding: const EdgeInsets.all(15.0),
        child: Row(children: <Widget>[
          Flexible(
              flex: 2,
              child: Stack(alignment: Alignment.center, children: <Widget>[
                Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            left: BorderSide(color: orange, width: 5.0))),
                    child: CachedImage(_lounge.event.pic,
                        width: 40.0,
                        height: 40.0,
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(5.0),
                            topRight: Radius.circular(5.0)),
                        imageType: ImageType.Event))
              ])),
          Flexible(
              flex: 11,
              child: Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(children: <Widget>[
                    Container(
                        child: Row(children: <Widget>[
                      CachedImage(owner.pics.isEmpty ? null : owner.pics[0],
                          width: 20.0,
                          height: 20.0,
                          borderRadius: BorderRadius.circular(20.0),
                          imageType: ImageType.User),
                      Expanded(
                          child: Wrap(
                              direction: Axis.horizontal,
                              children: <Widget>[
                            Container(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  state.userState.user.id == owner.id
                                      ? FlutterI18n.translate(
                                          context, 'LOUNGE_CHAT.YOUR_LOUNGE')
                                      : owner.name +
                                          FlutterI18n.translate(context,
                                              'LOUNGE_CHAT.SOMEONES_LOUNGE'),
                                  style: const TextStyle(
                                      color: black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ))
                          ]))
                    ])),
                    Wrap(children: <Widget>[
                      RichText(
                          text: TextSpan(
                              text: _lounge.members.length.toString() +
                                  ' ' +
                                  FlutterI18n.translate(
                                      context, 'LOUNGE_CHAT.MEMBER') +
                                  (_lounge.members.length > 1 ? 's ' : ' '),
                              style: const TextStyle(
                                  color: black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                              children: <TextSpan>[
                            TextSpan(
                                text: _lounge.event.name,
                                style: TextStyle(
                                    color: orange,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800))
                          ]))
                    ])
                  ]))),
          if (state.userState.user.id == owner.id)
            Flexible(
                flex: 2,
                child: GestureDetector(
                    onTap: () => dispatch(
                        redux.NavigateAction<AppState>.pushNamed(
                            LoungeEditScreen.id,
                            arguments: _lounge)),
                    child: Column(children: <Widget>[
                      const Icon(MdiIcons.calendarEdit, color: orange),
                      Text(FlutterI18n.translate(context, 'LOUNGE_CHAT.EDIT'),
                          style: const TextStyle(
                              color: orange, fontWeight: FontWeight.bold))
                    ])))
          else
            Flexible(
                flex: 5,
                child: Row(children: <Widget>[
                  GestureDetector(
                      onTap: () async {
                        await showLoaderAnimation(context, this,
                            animationDuration: 600);
                        dispatch(LoungeLeaveAction(
                            state.userState.user.id, _lounge));
                        dispatch(NavigateAction<AppState>.pop());
                      },
                      child: Container(
                          margin: const EdgeInsets.only(
                              left: 5, right: 10, top: 10),
                          child: Column(children: <Widget>[
                            const Icon(MdiIcons.arrowLeftBoldCircleOutline,
                                color: orange),
                            Text(
                                FlutterI18n.translate(
                                    context, 'LOUNGE_CHAT.LEAVE'),
                                style: const TextStyle(
                                    color: orange,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                FlutterI18n.translate(
                                    context, 'LOUNGE_CHAT.LOUNGE'),
                                style: const TextStyle(
                                    color: orange,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold))
                          ]))),
                  GestureDetector(
                      onTap: () => dispatch(NavigateAction<AppState>.pushNamed(
                          LoungeViewScreen.id,
                          arguments: _lounge)),
                      child: Container(
                          margin: const EdgeInsets.only(left: 5, top: 10),
                          child: Column(children: <Widget>[
                            const Icon(MdiIcons.viewCarousel, color: orange),
                            Text(
                                FlutterI18n.translate(
                                    context, 'LOUNGE_CHAT.VIEW'),
                                style: const TextStyle(
                                    color: orange,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                FlutterI18n.translate(
                                    context, 'LOUNGE_CHAT.DETAILS'),
                                style: const TextStyle(
                                    color: orange,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold))
                          ])))
                ]))
        ]));
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
    final User user = _lounge.members.firstWhere(
        (User user) => user.id == message.idFrom,
        orElse: () => null);
    if (user == null) {
      return Container();
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
              Container(
                  padding: const EdgeInsets.all(5),
                  child: CachedImage(user.pics.isEmpty ? null : user.pics[0],
                      width: 35.0,
                      height: 35.0,
                      borderRadius: BorderRadius.circular(20.0),
                      imageType: ImageType.User)),
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
                            Container(
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                  Container(
                                      child: Text(user.name,
                                          style: const TextStyle(
                                              color: black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600))),
                                  Container(
                                      child: Text(
                                    _dateFormatter(message.timestamp),
                                    style: const TextStyle(
                                        color: black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ))
                                ])),
                            Container(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  message.content,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      color: black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ))
                          ])))
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<dynamic>) dispatch,
        Widget child) {
      _lounge = state.userState.lounges.firstWhere(
          (Lounge lounge) => lounge.id == widget.lounge.id,
          orElse: () => null);
      Chat chat;
      if (_lounge != null) {
        chat = state.chatsState.loungeChats.firstWhere(
            (Chat chat) => chat.id == _lounge.id,
            orElse: () => null);
      }

      return View(
          title: FlutterI18n.translate(context, 'LOUNGE_CHAT.LOUNGE_CHAT'),
          child: Column(children: <Widget>[
            Expanded(
                child: Column(children: <Widget>[
              _buildHeader(state, dispatch),
              const Divider(),
              if (chat != null) Expanded(child: _buildChat(chat))
            ])),
            Container(
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: orangeLight.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5.0)),
                child: Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {}, child: Icon(Icons.add, color: white)),
                  ),
                  Expanded(
                      child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration.collapsed(
                              hintText: FlutterI18n.translate(
                                  context, 'LOUNGE_CHAT.MESSAGE'),
                              hintStyle: const TextStyle(color: white)))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {},
                        child: const Icon(MdiIcons.stickerEmoji, color: white)),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            addMessage(_lounge.id, state.loginState.id,
                                _messageController.text, MessageType.Text);
                            _messageController.clear();
                          },
                          child: Icon(Icons.send, color: white)))
                ]))
          ]));
    });
  }
}
