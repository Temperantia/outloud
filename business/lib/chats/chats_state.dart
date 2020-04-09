import 'package:business/classes/chat.dart';
import 'package:business/classes/chat_state.dart';

class ChatsState {
  ChatsState({this.chats, this.loungeChats, this.usersChatsStates});

  ChatsState copy(
          {List<String> chatIds,
          List<Chat> chats,
          List<Chat> loungeChats,
          Map<String, Map<String, ChatState>> usersChatsStates}) =>
      ChatsState(
          chats: chats ?? this.chats,
          loungeChats: loungeChats ?? this.loungeChats,
          usersChatsStates: usersChatsStates ?? this.usersChatsStates);

  final List<Chat> chats;
  final List<Chat> loungeChats;
  final Map<String, Map<String, ChatState>> usersChatsStates;

  static ChatsState initialState(
          {Map<String, Map<String, ChatState>> usersChatsStates =
              const <String, Map<String, ChatState>>{}}) =>
      ChatsState(usersChatsStates: usersChatsStates);
}
