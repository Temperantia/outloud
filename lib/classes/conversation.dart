import 'package:flutter/cupertino.dart';

import 'package:inclusive/classes/entity.dart';
import 'package:inclusive/classes/group_ping.dart';
import 'package:inclusive/classes/message.dart';
import 'package:inclusive/classes/message_list.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/services/app_data.dart';
import 'package:inclusive/models/group.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/models/message.dart';

class Conversation with ChangeNotifier {
  factory Conversation(String id, {int lastRead = 0, int pings = 0}) {
    final List<String> ids = id.split('-');
    return ids.length == 1
        ? Conversation.group(id, lastRead: lastRead, pings: pings)
        : Conversation.user(ids[0], ids[1], lastRead: lastRead, pings: pings);
  }

  Conversation.user(String idMy, this.idPeer,
      {this.lastRead = 0, this.pings = 0})
      : isGroup = false,
        id = getUserConversationId(idMy, idPeer);

  Conversation.group(this.id, {this.lastRead = 0, this.pings = 0})
      : isGroup = true,
        idPeer = id;

  final bool isGroup;
  final String id;
  final String idPeer;
  int lastRead;
  int pings;

  final AppDataService _appDataService = locator<AppDataService>();
  final UserModel _userProvider = locator<UserModel>();
  final GroupModel _groupProvider = locator<GroupModel>();
  final MessageModel _messageProvider = locator<MessageModel>();

  static String getUserConversationId(String id1, String id2) {
    return id1.compareTo(id2) < 0 ? '$id1-$id2' : '$id2-$id1';
  }

  Stream<Entity> streamEntity() {
    if (isGroup) {
      return _groupProvider.streamGroup(idPeer);
    }
    return _userProvider.streamUser(idPeer);
  }

  Stream<MessageList> streamMessageList() {
    return _messageProvider.streamMessageList(id);
  }

  Stream<GroupPing> streamGroupPings() {
    return _messageProvider.streamGroupPings(this, _appDataService.identifier);
  }

  Future<void> getGroupUsers(MessageList messageList) async {
    final List<String> ids = messageList.messages
        .map<String>((Message message) => message.idFrom)
        .toSet()
        .toList();
    List<User> users =
        await Future.wait(ids.map((String id) => _userProvider.getUser(id)));
    users = List<User>.from(users);
    users.removeWhere((User user) => user == null);

    for (final Message mess in messageList.messages) {
      final int index = users.indexWhere((User user) => user.id == mess.idFrom);
      mess.author = index == -1 ? null : users[index];
    }
  }

  Stream<Message> streamLastMessage() {
    return _messageProvider.streamLastMessage(id);
  }

  void markAsRead() {
    lastRead = DateTime.now().millisecondsSinceEpoch;
    pings = 0;
  }
}
