import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:inclusive/classes/conversation_list.dart';
import 'package:inclusive/classes/conversation.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/services/app_data.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/models/message.dart';

class MessageService extends ChangeNotifier {
  final AppDataService appDataService = locator<AppDataService>();
  final UserModel userProvider = locator<UserModel>();
  final MessageModel messageProvider = locator<MessageModel>();

  int pings = 0;

  Future<ConversationList> getConversationList() async {
    final List<Conversation> conversations = <Conversation>[
      /* Conversation('BHpAnkWabxJFoY1FbM57', 0),
      Conversation('apmbMHvueWZDLeAOxaxI-cx0hEmwDTLWYy3COnvPL', 0), */
    ];

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final List<String> conversationIDs =
        sharedPreferences.getStringList('conversationIDs');
    final List<String> conversationLastReads =
        sharedPreferences.getStringList('conversationLastReads');
    if (conversationIDs == null || conversationLastReads == null) {
      return ConversationList(conversations: conversations);
    }
    conversationIDs.asMap().forEach((final int index, final String id) =>
        conversations
            .add(Conversation(id, int.parse(conversationLastReads[index]))));
    return ConversationList(conversations: conversations);
  }

  Future<void> setConversations(ConversationList conversationList) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final List<String> conversationIDs = conversationList.conversations
        .map<String>((final Conversation conversation) => conversation.id)
        .toList();
    sharedPreferences.setStringList('conversationIDs', conversationIDs);
    final List<String> conversationLastReads = conversationList.conversations
        .map<String>((final Conversation conversation) =>
            conversation.lastRead.toString())
        .toList();
    sharedPreferences.setStringList(
        'conversationLastReads', conversationLastReads);
  }

  void addUserConversation(
      ConversationList conversationList, String id, String idPeer) {
    final String conversationId =
        Conversation.makeUserConversationId(id, idPeer);
    conversationList.conversations.add(Conversation(conversationId, 0));
    setConversations(conversationList);
  }

  void closeConversation(
      Conversation conversation, ConversationList conversationList) {
    conversationList.conversations.remove(conversation);
    setConversations(conversationList);
  }

  Future<void> sendMessage(Conversation conversation, String text) async {
    await messageProvider.addMessage(
        conversation.id, appDataService.identifier, text);
    if (!conversation.isGroup) {
      userProvider.ping(appDataService.identifier, conversation.idPeer);
    }
  }

  void refreshPings(List<Conversation> conversations) {
    pings = 0;
    for (final Conversation conversation in conversations) {
      if (conversation.pings > 0) {
        ++pings;
      }
    }
  }
}
