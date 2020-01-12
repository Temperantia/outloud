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
      idPeer = _getPeerId(id);
    }
  }
  final String id;

  final AppDataService _appDataService = locator<AppDataService>();
  final UserModel _userProvider = locator<UserModel>();
  final GroupModel _groupProvider = locator<GroupModel>();
  final MessageModel _messageProvider = locator<MessageModel>();

  bool isGroup;
  String idPeer;
  int lastRead = 0;
  int pings = 0;

  static String makeUserConversationId(String id, String idPeer) {
    return id + '-' + idPeer;
  }

  String _getPeerId(final String conversationId) {
    final List<String> ids = conversationId.split('-');
    return _appDataService.identifier == ids[0] ? ids[1] : ids[0];
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
