import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:inclusive/classes/interest.dart';
import 'package:inclusive/classes/search_preferences.dart';
import 'package:inclusive/widgets/loading.dart';
import 'package:provider/provider.dart';

import 'package:inclusive/screens/Profile/profile.dart';
import 'package:inclusive/classes/conversation_list.dart';
import 'package:inclusive/services/app_data.dart';
import 'package:inclusive/services/message.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/models/user.dart';

class Search extends StatefulWidget {
  const Search({this.onCreateUserConversation});
  final void Function(int) onCreateUserConversation;
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin {
  AppDataService _appDataService;
  MessageService _messageService;
  UserModel _userProvider;

  Widget _buildUser(User user, ConversationList conversationList, User me) {
    return FutureBuilder<double>(
        future: me.location == null || user.location == null
            ? Future<double>(null)
            : _appDataService.locator.distanceBetween(
                me.location.latitude,
                me.location.longitude,
                user.location.latitude,
                user.location.longitude),
        builder: (BuildContext context, AsyncSnapshot<double> distance) =>
            _buildUserDetails(user, conversationList, me, distance));
  }

  Widget _buildUserDetails(User user, ConversationList conversationList,
      User me, AsyncSnapshot<double> distance) {
    final int commonInterests = me.interests.isEmpty
        ? 0
        : me.interests
            .map<int>((Interest interest) =>
                user.interests.contains(interest) ? 1 : 0)
            .reduce((int curr, int next) => curr + next);

    return GestureDetector(
        onTap: () =>
            Navigator.pushNamed(context, ProfileScreen.id, arguments: user),
        child: Card(
            color: orange,
            child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          width: 100.0,
                          child: user.pics.isEmpty
                              ? Image.asset(
                                  'images/default-user-profile-image-png-7.png',
                                  fit: BoxFit.fill)
                              : Image.network(user.pics[0].toString())),
                      Text(user.name.isEmpty ? 'Anonymous' : user.name,
                          style: Theme.of(context).textTheme.title),
                      Column(children: <Widget>[
                        if (commonInterests > 0)
                          Container(
                              child: Row(children: <Widget>[
                            Text(commonInterests.toString(),
                                style: Theme.of(context).textTheme.caption),
                            Icon(Icons.category, color: white),
                            Text('in common',
                                style: Theme.of(context).textTheme.caption),
                          ])),
                        if (distance.hasData)
                          if (distance.data / 1000 > 3000)
                            FutureBuilder<List<Address>>(
                                future: Geocoder.local
                                    .findAddressesFromCoordinates(Coordinates(
                                        user.location.latitude,
                                        user.location.longitude)),
                                builder: (BuildContext context, AsyncSnapshot<List<Address>> address) =>
                                    address.hasData
                                        ? address.data.isEmpty || address.data[0].countryCode == null
                                            ? Text('${(distance.data / 1000).round().toString()} km',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption)
                                            : Text('Location (${address.data[0].countryName.toString()})',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption)
                                        : Container())
                          else
                            Text('${(distance.data / 1000).round().toString()} km',
                                style: Theme.of(context).textTheme.caption)
                      ]),
                      ButtonBar(children: <IconButton>[
                        if (!conversationList.hasUserConversation(user.id))
                          IconButton(
                              icon: Icon(Icons.add, color: white),
                              onPressed: () async {
                                await _messageService.addUserConversation(
                                    conversationList,
                                    _appDataService.identifier,
                                    user.id);
                                setState(() {
                                  widget.onCreateUserConversation(1);
                                });
                              }),
                      ]),
                    ]))));
  }

  @override
  Widget build(BuildContext context) {
    _appDataService = Provider.of(context);
    _messageService = Provider.of(context);
    _userProvider = Provider.of(context);
    final User user = Provider.of(context);
    final ConversationList conversationList =
        Provider.of(context);
    final SearchPreferences searchPreferences =
        Provider.of(context);
    return FutureBuilder<List<User>>(
        future: _userProvider.getUsers(_appDataService.identifier,
            interests: searchPreferences.interests,
            ageStart: searchPreferences.ageRange.start.toInt(),
            ageEnd: searchPreferences.ageRange.end.toInt()),
        builder: (BuildContext context, AsyncSnapshot<List<User>> users) =>
            users.hasData
                ? ListView.builder(
                    itemBuilder: (BuildContext context, int index) =>
                        _buildUser(users.data[index], conversationList, user),
                    itemCount: users.data.length,
                  )
                : Loading());
  }
}
