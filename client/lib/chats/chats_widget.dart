import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/message.dart';
import 'package:business/classes/user.dart';
import 'package:business/people/actions/people_get_action.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/widgets/circular_image.dart';
import 'package:inclusive/widgets/loading.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

import '../theme.dart';

class ChatsWidget extends StatefulWidget {
  @override
  _ChatsWidgetState createState() => _ChatsWidgetState();
}

class _ChatsWidgetState extends State<ChatsWidget>
    with AutomaticKeepAliveClientMixin<ChatsWidget> {
  @override
  bool get wantKeepAlive => true;

  Widget _buildChat(Chat chat) {
    final Message lastMessage = chat.messages.isEmpty ? null : chat.messages[0];
    final String pic = (chat.entity as User).pics.isEmpty
        ? null
        : (chat.entity as User).pics[0];
    return Container(
        decoration: BoxDecoration(
            gradient: gradient, borderRadius: BorderRadius.circular(10.0)),
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(children: <Widget>[
          CircularImage(imageUrl: pic, imageRadius: 50.0),
          Expanded(
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(chat.entity.name,
                                  style: textStyleListItemTitle),
                              if (lastMessage != null)
                                Text(lastMessage.getTimeAgo(),
                                    style: textStyleListItemSubtitle),
                            ]),
                        if (lastMessage != null)
                          Row(children: <Widget>[
                            Text(lastMessage.content,
                                maxLines: 2, overflow: TextOverflow.ellipsis)
                          ]),
                      ]))),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<AppState>) dispatch,
        Widget child) {
      final List<Chat> chats = state.chatsState.chats;
      if (chats == null) {
        return Loading();
      }

      return RefreshIndicator(
          onRefresh: () => store.dispatchFuture(PeopleGetAction()),
          child: Container(
              decoration: const BoxDecoration(color: white),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Chats', style: textStyleTitle),
                    Expanded(
                        child: ListView.builder(
                            itemCount: chats.length,
                            itemBuilder: (BuildContext context, int index) =>
                                _buildChat(chats[index]))),
                  ])));
    });
  }
}
