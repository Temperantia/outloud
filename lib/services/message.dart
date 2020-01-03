import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/services/appdata.dart';
import 'package:inclusive/models/groupModel.dart';
import 'package:inclusive/models/userModel.dart';
import 'package:inclusive/models/messageModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Conversation {
  final AppDataService appDataService = locator<AppDataService>();
  final UserModel userProvider = locator<UserModel>();
  final GroupModel groupProvider = locator<GroupModel>();
  final MessageModel messageProvider = locator<MessageModel>();
  final String id;
  bool isGroup;
  String idPeer;
  Group group;
  User userPeer;

  int lastRead = 0;
  List<Message> messages = [];
  int pings;

  Conversation(this.id, this.lastRead, {this.pings = 0}) {
    isGroup = !id.contains('-');
    if (isGroup) {
      idPeer = id;
    } else {
      idPeer = getPeerId(id);
    }
  }

  String toString() {
    return 'pings : ' + pings.toString();
  }

  String getPeerId(final String conversationId) {
    final List<String> ids = conversationId.split('-');
    return locator<AppDataService>().identifier == ids[0] ? ids[1] : ids[0];
  }

  Future getPeerInfo() async {
    if (isGroup) {
      group = await groupProvider.getGroup(idPeer);
    } else {
      userPeer = await userProvider.getUser(idPeer);
    }
  }

  Stream<List<Message>> streamMessages() {
    final Stream<List<Message>> stream = messageProvider.streamMessages(id);
    stream.listen((final List<Message> messages) {
      this.messages = messages;
    });
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

class MessageService extends ChangeNotifier {
  final AppDataService appDataService = locator<AppDataService>();
  final UserModel userProvider = locator<UserModel>();
  final MessageModel messageProvider = locator<MessageModel>();

  Conversation currentConversation;
  List<Conversation> conversations = [
    /*  Conversation('BHpAnkWabxJFoY1FbM57', 0),
    Conversation('apmbMHvueWZDLeAOxaxI-cx0hEmwDTLWYy3COnvPL', 0), */
  ];
  Completer completer = Completer();
  int pings = 0;

  MessageService() {
    getConversations().then((conversations) {
      completer.complete();
    });
  }

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

  Future<Stream> streamAll() async {
    StreamGroup group = StreamGroup();

    await appDataService.completer.future;
    await completer.future;

    Stream pingStream = appDataService.user.streamPings();
    group.add(pingStream);
    var pings = await pingStream.first;
    for (var ping in pings) {
      final int index = conversations.indexWhere(
          (final Conversation conversation) => conversation.idPeer == ping.id);
      if (index == -1) {
        conversations.insert(0, Conversation(ping.id, 0, pings: ping.value));
      } else {
        conversations[index].pings = ping.value;
      }
      ++this.pings;
    }

    int index = 0;
    Stream conversationStream;
    Stream pingGroupStream;
    for (Conversation conversation in conversations) {
      await conversation.getPeerInfo();
      conversationStream = conversation.streamMessages();
      group.add(conversationStream);

      List<Message> messages = await conversationStream.first;
      
      if (conversation.isGroup) {
        List<String> ids = messages.map((mess) => mess.idFrom).toSet().toList();
        List<User> users = await Future.wait(ids.map((id) => userProvider.getUser(id)));
        users = List.from(users);
        users.removeWhere((user) => user == null);

        for (Message mess in messages) {
          int index = users.indexWhere((user) => user.id == mess.idFrom);
          mess.author = index == -1 ? null : users[index];
        }
        pingGroupStream = conversation.streamGroupPings();
        group.add(pingGroupStream);
      }
      conversations[index].messages = messages;
      ++index;
    }
    return group.stream;
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
