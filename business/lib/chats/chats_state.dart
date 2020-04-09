import 'package:business/classes/chat.dart';

class ChatsState {
  ChatsState({this.chatIds, this.chats, this.loungeChats});

  ChatsState copy(
          {List<String> chatIds, List<Chat> chats, List<Chat> loungeChats}) =>
      ChatsState(
          chatIds: chatIds ?? this.chatIds,
          chats: chats ?? this.chats,
          loungeChats: loungeChats ?? this.loungeChats);

  final List<String> chatIds;
  final List<Chat> chats;
  final List<Chat> loungeChats;
  // final Map<String, Map<String, Map<int, Map<String, bool>>>>
  //     usersChatsMessagesStates = [] as Map<String, Map<String, Map<int, Map<String, bool>>>>;

  static ChatsState initialState({List<String> chatIds = const <String>[]}) =>
      ChatsState(chatIds: chatIds);
}
