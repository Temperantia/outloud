import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/models/message.dart';

class ChatsMessageSendAction extends ReduxAction<AppState> {
  ChatsMessageSendAction(this.content, this.chatId);

  final String content;
  final String chatId;

  @override
  AppState reduce() {
    addMessage(chatId, state.loginState.id, content);
    return null;
  }
}
