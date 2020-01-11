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
  Conversation(this.id, this.lastRead, {this.pings = 0}) {
    isGroup = !id.contains('-');
    if (isGroup) {
      idPeer = id;
    } else {
      idPeer = getPeerId(id);
    }
  }
  final AppDataService appDataService = locator<AppDataService>();
  final UserModel userProvider = locator<UserModel>();
  final GroupModel groupProvider = locator<GroupModel>();
  final MessageModel messageProvider = locator<MessageModel>();
  final String id;
  bool isGroup;
  Entity entity;
  String idPeer;

  int lastRead = 0;
  int pings = 0;
  Stream<Entity> peerData;
  Stream<MessageList> messageList;
  Stream<GroupPing> groupPings;

  @override
  String toString() {
    return 'pings : ' +
        pings.toString() +
        ' messages : ' +
        messageList.toString();
  }

  Future<void> getGroupUsers(MessageList messageList) async {
    final List<String> ids = messageList.messages
        .map<String>((Message message) => message.idFrom)
        .toSet()
        .toList();
    List<User> users =
        await Future.wait(ids.map((String id) => userProvider.getUser(id)));
    users = List<User>.from(users);
    users.removeWhere((User user) => user == null);

    for (final Message mess in messageList.messages) {
      final int index = users.indexWhere((User user) => user.id == mess.idFrom);
      mess.author = index == -1 ? null : users[index];
    }
  }

  String getPeerId(final String conversationId) {
    final List<String> ids = conversationId.split('-');
    return appDataService.identifier == ids[0] ? ids[1] : ids[0];
  }

  Stream<Entity> streamPeerInfo() {
    if (isGroup) {
      return groupProvider.streamGroup(idPeer);
    }
    return userProvider.streamUser(idPeer);
  }

  Stream<MessageList> streamMessageList() {
    return messageProvider.streamMessageList(id);
  }

  Stream<GroupPing> streamGroupPings() {
    return messageProvider.streamGroupPings(this, appDataService.identifier);
  }

  void markAsRead() {
    lastRead = DateTime.now().millisecondsSinceEpoch;
    pings = 0;
  }
}
