import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/services/appdata.dart';
import 'package:inclusive/models/groupModel.dart';
import 'package:inclusive/models/userModel.dart';
import 'package:inclusive/models/messageModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_transform/stream_transform.dart';

class Conversation {
  final AppData appDataService = locator<AppData>();
  final UserModel userProvider = locator<UserModel>();
  final GroupModel groupProvider = locator<GroupModel>();
  final MessageModel messageProvider = locator<MessageModel>();
  final String id;
  final bool isGroup;
  String idPeer;

  int lastRead = 0;
  List<Message> messages = [];
  List<User> peerUsers = [];
  int pings;

  Conversation(this.id, this.lastRead, {this.pings = 0})
      : isGroup = !id.contains('-'),
        idPeer = id {
    if (isGroup) {
      idPeer = getPeerId(id);
    }
  }

  String toString() {
    return 'pings : ' + pings.toString();
  }

  String getPeerId(final String conversationId) {
    final List<String> ids = conversationId.split('-');

    return locator<AppData>().identifier == ids[0] ? ids[1] : ids[0];
  }

  Future<dynamic> getPeerInfo() async {
    return isGroup
        ? groupProvider.getGroup(idPeer)
        : userProvider.getUser(idPeer);
  }

  Stream<List<Message>> streamMessages() {
    final Stream<List<Message>> stream = messageProvider.streamMessages(id);
    stream.listen((final List<Message> messages) => this.messages = messages);
    return stream;
  }

  Stream<List<Message>> streamGroupPings() {
    final Stream<List<Message>> stream =
        messageProvider.streamGroupPings(this, appDataService.identifier);
    stream.listen((final List<Message> newMessages) {
      pings = newMessages.length;
    });
    return stream;
  }

/*   Stream<List<User>> streamUsers() {
    final Stream<List<Message>> stream = ;
    stream.listen((final List<Message> messages) => this.messages = messages);
    return stream;
  } */
}

class test {
  List<Conversation> conversations;
  List<Ping> pings;
  List<List<Message>> messages;
}

class MessageService extends ChangeNotifier {
  final AppData appDataService = locator<AppData>();
  final UserModel userProvider = locator<UserModel>();
  final MessageModel messageProvider = locator<MessageModel>();

  Conversation currentConversation;
  List<Conversation> conversations = [
    //Conversation('BHpAnkWabxJFoY1FbM57', 0),
    //Conversation('apmbMHvueWZDLeAOxaxI-cx0hEmwDTLWYy3COnvPL', 0),
  ];
  int pings = 0;

  Future getConversations() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final List<String> conversationIDs =
        sharedPreferences.getStringList('conversationIDs');
    final List<String> conversationLastReads =
        sharedPreferences.getStringList('conversationLastReads');
    if (conversationIDs == null || conversationLastReads == null) {
      return;
    }
    conversationIDs.asMap().forEach((final int index, final String id) =>
        conversations
            .add(Conversation(id, int.parse(conversationLastReads[index]))));
    if (conversations.isNotEmpty) {
      currentConversation = conversations[0];
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

  //  1. stream 1-2-1 pings
  //  2. conversation
  //    A. stream messages
  //      a. stream message users
  //    B. stream grp pings
  Stream<test> streamAll() async* {
    test t = test();
     Stream<test> s = getConversations().asStream().map((stream) {
      for (var conversation in stream) {
        stream.combineLatest(conversation.streamMessages(), null);
        if (conversation.isGroup) {
          conversation.streamGroupPings();
        }

      }
      //t.conversations = conversations;
      return stream;
    })/*.combineLatest(appDataService.user.streamPings(),
        (conversations, final List<Ping> pings) {
      for (final Ping ping in pings) {
        final int index = conversations.indexWhere(
            (final Conversation conversation) => conversation.id == ping.id);
        if (index == -1) {
          conversations.insert(0, Conversation(ping.id, 0, pings: ping.value));
        } else {
          conversations[index].pings = ping.value;
        }
        ++this.pings;
      }
      t.conversations = conversations;
      t.pings = pings;
      return t;
    })*/;
    yield* s;
  }

  void changeConversation(final Conversation conversation) {
    currentConversation = conversation;
    currentConversation.lastRead = DateTime.now().millisecondsSinceEpoch;
    currentConversation.pings = 0;
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
}
