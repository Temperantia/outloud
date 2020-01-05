import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/cupertino.dart';
import 'package:inclusive/models/messageModel.dart';
import 'package:inclusive/models/userModel.dart';
import 'package:inclusive/screens/Landing/index.dart';
import 'package:inclusive/services/appdata.dart';
import 'package:inclusive/services/message.dart';
import 'package:provider/provider.dart';
import 'package:inclusive/screens/app.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppDataService appDataService = Provider.of<AppDataService>(context);
    final MessageService messageService = Provider.of<MessageService>(context);

    return MultiProvider(
        providers: [
          StreamProvider<User>.value(value: appDataService.getUser()),
          FutureProvider<List<Conversation>>.value(
              value: messageService.getConversations()),
        ],
        child: Builder(builder: (BuildContext context) {
          final User user = Provider.of<User>(context);
          if (user == null) {
            return LandingScreen();
          }
          return MultiProvider(
              providers: [
                StreamProvider<List<Ping>>.value(value: user.streamPings())
              ],
              child: Builder(builder: (context) {
                final List<Conversation> conversations =
                    Provider.of<List<Conversation>>(context);
                final List<Ping> pings = Provider.of<List<Ping>>(context) ?? [];

                for (var ping in pings) {
                  final int index = conversations.indexWhere(
                      (final Conversation conversation) =>
                          conversation.idPeer == ping.id);
                  if (index == -1) {
                    conversations.insert(
                        0, Conversation(ping.id, 0, pings: ping.value));
                  } else {
                    conversations[index].pings = ping.value;
                  }
                  ++messageService.pings;
                }

                List<Stream> streams = [];
                List<Stream> peerInfoStreams = [];
                List<Stream> groupPingStreams = [];

                for (Conversation conversation in conversations) {
                  peerInfoStreams.add(conversation.streamPeerInfo());
                  streams.add(conversation.streamMessages());
                  if (conversation.isGroup) {
                    groupPingStreams.add(conversation.streamGroupPings());
                  }
                }
                messageService.conversations = conversations;
                return MultiProvider(
                    providers: [
                      StreamProvider<List<List<Message>>>.value(
                          value: CombineLatestStream(streams,
                              (List<dynamic> messages) {
                        int index = 0;
                        for (var conv in conversations) {
                          messageService.conversations[index].messages =
                              messages[index];
                          ++index;
                        }
                        return messages.cast<List<Message>>();
                      })),
                      StreamProvider<dynamic>.value(
                          value: CombineLatestStream(peerInfoStreams,
                              (List<dynamic> peerInfo) {
                        int index = 0;
                        for (var conv in conversations) {
                          messageService.conversations[index].peerData =
                              peerInfo[index];
                          ++index;
                        }
                        return peerInfo;
                      })),
                      StreamProvider<List<Ping>>.value(
                          value: CombineLatestStream(groupPingStreams,
                              (List messages) {
                        int index = 0;
                        int j = 0;
                        for (var conv in conversations) {
                          if (conv.isGroup) {
                            messageService.conversations[index].pings =
                                messages[j].length;
                            if (messages[j].length > 0) {
                              ++messageService.pings;
                            }
                            ++j;
                          }

                          ++index;
                        }
                        return messages.cast<Ping>();
                      }))
                    ],
                    child: Builder(
                        builder: (context) => FutureBuilder(future: () async {
                              final userProvider =
                                  Provider.of<UserModel>(context);

                              int index = 0;
                              for (var c in conversations) {
                                List<String> ids = c.messages
                                    .map((mess) => mess.idFrom)
                                    .toSet()
                                    .toList();
                                List<User> users = await Future.wait(
                                    ids.map((id) => userProvider.getUser(id)));
                                users = List.from(users);
                                users.removeWhere((user) => user == null);

                                for (Message mess in c.messages) {
                                  int index = users.indexWhere(
                                      (user) => user.id == mess.idFrom);
                                  mess.author =
                                      index == -1 ? null : users[index];
                                }
                                conversations[index] = c;
                                ++index;
                              }
                            }(), builder: (context, snapshost) {
                              return AppScreen();
                            })));
              }));
        }));
  }
}
