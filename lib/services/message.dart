import 'dart:async';
import 'package:flutter/material.dart';
import 'package:inclusive/classes/conversation_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:inclusive/classes/conversation.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/services/app_data.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/models/message.dart';

class MessageService extends ChangeNotifier {
  final AppDataService appDataService = locator<AppDataService>();
  final UserModel userProvider = locator<UserModel>();
  final MessageModel messageProvider = locator<MessageModel>();

  Conversation currentConversation;
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
    if (conversations.isNotEmpty) {
      currentConversation = conversations[0];
      currentConversation.markAsRead();
      setConversations(conversations);
    }
    return ConversationList(conversations: conversations);
  }

  Future<void> setConversations(List<Conversation> conversations) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final List<String> conversationIDs = conversations
        .map((final Conversation conversation) => conversation.id)
        .toList()
        .cast<String>();
    sharedPreferences.setStringList('conversationIDs', conversationIDs);

    final List<String> conversationLastReads = conversations
        .map((final Conversation conversation) =>
            conversation.lastRead.toString())
        .toList()
        .cast<String>();
    sharedPreferences.setStringList(
        'conversationLastReads', conversationLastReads);
  }

  void changeConversation(
      Conversation conversation, List<Conversation> conversations) {
    currentConversation = conversation;
    currentConversation.markAsRead();
    setConversations(conversations);
  }

  Future<void> sendMessage(String text) async {
    await messageProvider.addMessage(
        currentConversation.id, appDataService.identifier, text);
    if (!currentConversation.isGroup) {
      userProvider.ping(appDataService.identifier, currentConversation.idPeer);
    }
  }

  List<Conversation> closeCurrentConversation(
      List<Conversation> conversations) {
    final int index = conversations.indexOf(currentConversation);
    conversations.remove(currentConversation);
    if (conversations.isEmpty) {
      currentConversation = null;
    } else if (index == conversations.length) {
      currentConversation = conversations[index - 1];
    } else {
      currentConversation = conversations[index];
    }
    setConversations(conversations);
    return conversations;
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
