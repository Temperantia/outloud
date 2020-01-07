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

  Conversation currentConversation;
  /*
  List<Conversation> conversations = [
    Conversation('BHpAnkWabxJFoY1FbM57', 0),
    Conversation('apmbMHvueWZDLeAOxaxI-cx0hEmwDTLWYy3COnvPL', 0),
  ];*/
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
      setConversations(conversations);
    }
    return conversations;
  }

  Future setConversations(conversations) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final List<String> conversationIDs = conversations
        .map((final Conversation conversation) => conversation.id)
        .toList().cast<String>();
    sharedPreferences.setStringList('conversationIDs', conversationIDs);

    final List<String> conversationLastReads = conversations
        .map((final Conversation conversation) =>
            conversation.lastRead.toString())
        .toList().cast<String>();
    sharedPreferences.setStringList(
        'conversationLastReads', conversationLastReads);
  }

  void changeConversation(final Conversation conversation, conversations) {
    currentConversation = conversation;
    currentConversation.markAsRead();
    setConversations(conversations);
  }

  Future sendMessage(final String text) async {
    await messageProvider.addMessage(
        currentConversation.id, appDataService.identifier, text);
    if (!currentConversation.isGroup) {
      userProvider.ping(appDataService.identifier, currentConversation.idPeer);
    }
  }

  List<Conversation> closeCurrentConversation(List<Conversation> conversations) {
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
    for (Conversation conversation in conversations) {
      if (conversation.pings > 0) {
        ++pings;
      }
    }
  }
}
