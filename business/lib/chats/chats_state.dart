import 'package:business/classes/chat.dart';
import 'package:business/classes/chat_state.dart';

class ChatsState {
  ChatsState(
      {this.chats,
      this.loungeChats,
      this.usersChatsStates,
      this.loungesChatsStates});

  ChatsState copy(
          {List<String> chatIds,
          List<Chat> chats,
          List<Chat> loungeChats,
          Map<String, Map<String, ChatState>> usersChatsStates,
          Map<String, Map<String, ChatState>> loungesChatsStates}) =>
      ChatsState(
          chats: chats ?? this.chats,
          loungeChats: loungeChats ?? this.loungeChats,
          usersChatsStates: usersChatsStates ?? this.usersChatsStates,
          loungesChatsStates: loungesChatsStates ?? this.loungesChatsStates);

  final List<Chat> chats;
  final List<Chat> loungeChats;
  final Map<String, Map<String, ChatState>> usersChatsStates;
  final Map<String, Map<String, ChatState>> loungesChatsStates;

  static ChatsState initialState(
          {Map<String, Map<String, ChatState>> usersChatsStates,
          Map<String, Map<String, ChatState>> loungesChatsStates}) =>
      ChatsState(
          usersChatsStates:
              usersChatsStates ?? <String, Map<String, ChatState>>{},
          loungesChatsStates:
              loungesChatsStates ?? <String, Map<String, ChatState>>{});
}
