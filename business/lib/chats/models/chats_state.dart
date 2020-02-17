import 'package:business/classes/chat.dart';

class ChatsState {
  ChatsState({
    this.chatIds,
    this.chats,
  });

  ChatsState copy({
    List<String> chatIds,
    List<Chat> chats,
  }) =>
      ChatsState(
        chatIds: chatIds ?? this.chatIds,
        chats: chats ?? this.chats,
      );

  final List<String> chatIds;
  final List<Chat> chats;

  static ChatsState initialState({List<String> chatIds = const <String>[]}) {
    // testing purpose
    chatIds = <String>['b-5450d22a74bb3dee'];

    return ChatsState(
      chatIds: chatIds,
      chats: null,
    );
  }
}
