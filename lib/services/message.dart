import 'dart:async';
import 'package:flutter/material.dart';
import 'package:inclusive/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:inclusive/classes/conversation_list.dart';
import 'package:inclusive/classes/conversation.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/models/message.dart';

class MessageService extends ChangeNotifier {
  final AuthService _authService = locator<AuthService>();
  final UserModel userProvider = locator<UserModel>();
  final MessageModel messageProvider = locator<MessageModel>();

  int pings = 0;

  Future<ConversationList> getConversationList() async {
    final List<Conversation> conversations = <Conversation>[
      //Conversation('BHpAnkWabxJFoY1FbM57'),
    ];

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final List<String> conversationIDs =
        sharedPreferences.getStringList('conversationIDs');
    final List<String> conversationLastReads =
        sharedPreferences.getStringList('conversationLastReads');
    final List<String> conversationPinneds =
        sharedPreferences.getStringList('conversationPinneds');

    if (conversationIDs == null ||
        conversationLastReads == null ||
        conversationPinneds == null) {
      return ConversationList(conversations: conversations);
    }

    conversationIDs.asMap().forEach((final int index, final String id) =>
        conversations.add(Conversation(id,
            lastRead: int.parse(conversationLastReads[index]),
            pinned: conversationPinneds[index] == 'true')));
    return ConversationList(conversations: conversations);
  }

  Future<void> setConversations(ConversationList conversationList) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final List<String> conversationIDs = conversationList.conversations
        .map<String>((final Conversation conversation) => conversation.id)
        .toList();
    await sharedPreferences.setStringList('conversationIDs', conversationIDs);

    final List<String> conversationLastReads = conversationList.conversations
        .map<String>((final Conversation conversation) =>
            conversation.lastRead.toString())
        .toList();
    await sharedPreferences.setStringList(
        'conversationLastReads', conversationLastReads);

    final List<String> conversationPinneds = conversationList.conversations
        .map<String>((final Conversation conversation) =>
            conversation.pinned ? 'true' : 'false')
        .toList();
    await sharedPreferences.setStringList(
        'conversationPinneds', conversationPinneds);
  }

  ConversationList sortConversationList(ConversationList conversationList) {
    conversationList.conversations
        .sort((Conversation conversation1, Conversation conversation2) {
      if (conversation1.pinned && !conversation2.pinned) {
        return -1;
      } else if (!conversation1.pinned && conversation2.pinned) {
        return 1;
      }
      if (conversation1.lastMessage != null &&
          conversation2.lastMessage != null) {
        if (conversation1.lastMessage.timestamp >
            conversation2.lastMessage.timestamp) {
          return -1;
        } else if (conversation1.lastMessage.timestamp <
            conversation2.lastMessage.timestamp) {
          return 1;
        }
      }

      return 0;
    });
    return conversationList;
  }

  Future<void> addUserConversation(
      ConversationList conversationList, String id, String idPeer) async {
    conversationList.conversations.add(Conversation.user(id, idPeer));
    await setConversations(conversationList);
  }

  Future<void> closeConversation(
      Conversation conversation, ConversationList conversationList) async {
    await conversation.markAsRead();
    conversationList.conversations.remove(conversation);
    await setConversations(conversationList);
  }

  Future<void> pinConversation(
      Conversation conversation, ConversationList conversationList) async {
    conversation.pinned = !conversation.pinned;
    await setConversations(conversationList);
  }

  Future<void> sendMessage(Conversation conversation, String text) async {
    await messageProvider.addMessage(
        conversation.id, _authService.identifier, text);
    if (!conversation.isGroup) {
      userProvider.ping(_authService.identifier, conversation.idPeer);
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
