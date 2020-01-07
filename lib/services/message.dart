import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inclusive/classes/conversation.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/services/appdata.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/models/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageService extends ChangeNotifier {
  final AppDataService appDataService = locator<AppDataService>();
  final UserModel userProvider = locator<UserModel>();
  final MessageModel messageProvider = locator<MessageModel>();
  final Completer completer = Completer();

  Conversation currentConversation;
  List<Conversation> conversations = [
    Conversation('BHpAnkWabxJFoY1FbM57', 0),
    Conversation('apmbMHvueWZDLeAOxaxI-cx0hEmwDTLWYy3COnvPL', 0),
  ];
  int pings = 0;

  Future<List<Conversation>> getConversations() async {
    List<Conversation> conversations = [];

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final List<String> conversationIDs =
        sharedPreferences.getStringList('conversationIDs');
    final List<String> conversationLastReads =
        sharedPreferences.getStringList('conversationLastReads');
    if (conversationIDs == null || conversationLastReads == null) {
      return List<Conversation>();
    }
    conversationIDs.asMap().forEach((final int index, final String id) =>
        conversations
            .add(Conversation(id, int.parse(conversationLastReads[index]))));
    if (conversations.isNotEmpty) {
      currentConversation = conversations[0];
      currentConversation.markAsRead();
      setConversations();
    }

    return conversations;
  }

  Future setConversations() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final List<String> conversationIDs = conversations
        .map((final Conversation conversation) => conversation.id)
        .toList();
    sharedPreferences.setStringList('conversationIDs', conversationIDs);
    final List<String> conversationLastReads = conversations
        .map((final Conversation conversation) =>
            conversation.lastRead.toString())
        .toList();
    sharedPreferences.setStringList(
        'conversationLastReads', conversationLastReads);
  }

  void changeConversation(final Conversation conversation) {
    currentConversation = conversation;
    currentConversation.markAsRead();
    currentConversation.lastRead = DateTime.now().millisecondsSinceEpoch;
    currentConversation.pings = 0;
    setConversations();
  }

  void sendMessage(final String text) {
    messageProvider.addMessage(
        currentConversation.id, appDataService.identifier, text);
    if (!currentConversation.isGroup) {
      userProvider.ping(appDataService.identifier, currentConversation.idPeer);
    }
  }

  void closeCurrentConversation() {
    final int index = conversations.indexOf(currentConversation);
    conversations.remove(currentConversation);
    if (conversations.isEmpty) {
      currentConversation = null;
    } else if (index == conversations.length) {
      currentConversation = conversations[index - 1];
    } else {
      currentConversation = conversations[index];
    }
    setConversations();
  }

  void refreshPings() {
    pings = 0;
    for (Conversation conversation in conversations) {
      if (conversation.pings > 0) {
        ++pings;
      }
    }
  }
}
