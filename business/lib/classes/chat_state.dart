import 'package:business/classes/message_state.dart';
import 'package:enum_to_string/enum_to_string.dart';

class ChatState {
  ChatState(
      {this.lastRead = 0, this.messageStates = const <String, MessageState>{}});

  ChatState.fromJson(Map<String, dynamic> data) {
    lastRead = data['lastRead'] as int;
    messageStates = <String, MessageState>{};
    for (final MapEntry<String, dynamic> element
        in data['messageStates'].entries) {
      messageStates[element.key] =
          EnumToString.fromString(MessageState.values, element.value as String);
    }
  }

  int lastRead;
  Map<String, MessageState> messageStates;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'lastRead': lastRead,
      'messageStates': messageStates.map<String, String>(
          (String key, MessageState value) =>
              MapEntry<String, String>(key, EnumToString.parse(value)))
    };
  }
}
