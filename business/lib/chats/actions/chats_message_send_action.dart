import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/message.dart';
import 'package:business/models/message.dart';

class ChatsMessageSendAction extends ReduxAction<AppState> {
  ChatsMessageSendAction(this._content, this._chatId);

  final String _content;
  final String _chatId;

  @override
  AppState reduce() {
    addMessage(_chatId, state.loginState.id, _content, MessageType.Text);
    return null;
  }
}
