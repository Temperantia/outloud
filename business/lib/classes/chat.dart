import 'package:business/classes/entity.dart';
import 'package:business/classes/message.dart';

class Chat {
  factory Chat(String id, String userId, {int pings = 0, bool pinned = false}) {
    final List<String> ids = id.split('-');

    return ids.length == 1
        ? Chat.group(id, pings: pings, pinned: pinned)
        : Chat.user(userId == ids[0] ? ids[0] : ids[1],
            userId == ids[0] ? ids[1] : ids[0],
            pings: pings, pinned: pinned);
  }

  Chat.user(String idMy, this.idPeer, {this.pings = 0, this.pinned = false})
      : isGroup = false,
        id = getUserChatId(idMy, idPeer),
        messages = const <Message>[];
  Chat.group(this.id, {this.pings = 0, this.pinned = false})
      : isGroup = true,
        idPeer = id,
        messages = const <Message>[];

  final bool isGroup;
  final String id;
  final String idPeer;

  Entity entity;
  int pings;
  bool pinned;
  List<Message> messages;

  static String getUserChatId(String id1, String id2) =>
      id1.compareTo(id2) < 0 ? '$id1-$id2' : '$id2-$id1';

  Future<void> markAsRead() async {
    pings = 0;
    if (!isGroup) {
      //await _userProvider.markPingAsRead(_authService.identifier, idPeer);
    }
  }
}
