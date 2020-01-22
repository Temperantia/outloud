import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:inclusive/classes/interest.dart';
import 'package:provider/provider.dart';
import 'package:rubber/rubber.dart';

import 'package:inclusive/screens/Profile/profile.dart';
import 'package:inclusive/classes/conversation_list.dart';
import 'package:inclusive/services/app_data.dart';
import 'package:inclusive/services/message.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/Search/search_interest.dart';
import 'package:inclusive/widgets/background.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/models/user.dart';

class Search extends StatefulWidget {
  const Search({this.onCreateUserConversation});
  final void Function(int) onCreateUserConversation;
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin {
  RubberAnimationController _controller;

  AppDataService _appDataService;
  MessageService _messageService;
  UserModel _userProvider;
  RangeValues _ages = const RangeValues(25, 60);
  final List<Interest> _interests = <Interest>[];

  @override
  void initState() {
    _controller = RubberAnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
        lowerBoundValue: AnimationControllerValue(percentage: 0.4),
        upperBoundValue: AnimationControllerValue(percentage: 1.0));
    super.initState();
  }

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
            .map<int>(
                (Interest interest) => user.interests.contains(interest) ? 1 : 0)
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
                        child:
                       user.pics.isEmpty ?
                        Image.asset(
                            'images/default-user-profile-image-png-7.png',
                            fit: BoxFit.fill)
                      :
                        Image.network(user.pics[0].toString())),
                      Text(user.name == '' ? 'Anonymous' : user.name, style: Theme.of(context).textTheme.title),
                      //Text(user.getAge().toString(),
                       //   style: Theme.of(context).textTheme.title),
                      Column(children: <Widget>[
                        if (commonInterests > 0)
                          Container(
                              child: Row(children: <Widget>[
                            Text(commonInterests.toString(), style: Theme.of(context)
                                                    .textTheme
                                                    .caption),
                            Icon(Icons.category, color: white),
                             Text('in common', style: Theme.of(context)
                                                    .textTheme
                                                    .caption),
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
                              onPressed: () {
                                setState(() {
                                  _messageService.addUserConversation(
                                      conversationList,
                                      _appDataService.identifier,
                                      user.id);
                                  widget.onCreateUserConversation(1);
                                });
                              }),
                      ]),
                    ]))));
  }

  Widget _buildUpperLayer(AsyncSnapshot<List<User>> users,
      ConversationList conversationList, User user) {
    return Container(
        decoration: BoxDecoration(color: white),
        child: Column(children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Icon(Icons.drag_handle)]),
          Expanded(
              child: users.hasData
                  ? ListView.builder(
                      itemBuilder: (BuildContext context, int index) =>
                          _buildUser(users.data[index], conversationList, user),
                      itemCount: users.data.length,
                    )
                  : Container())
        ]));
  }

  Widget _buildLowerLayer() {
    return Container(
        padding: const EdgeInsets.only(top: 20.0),
        decoration: background,
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            Icon(Icons.category),
            Flexible(
                child: SearchInterest(
                    interests: _interests,
                    ))
          ]),
          Row(children: <Widget>[
            Icon(Icons.cake),
            Flexible(
                child: RangeSlider(
                    labels: RangeLabels(
                      _ages.start.toInt().toString() + 'y',
                      _ages.end.toInt().toString() + 'y',
                    ),
                    min: 13,
                    max: 99,
                    activeColor: orange,
                    inactiveColor: blueLight,
                    values: _ages,
                    divisions: 87,
                    onChanged: (RangeValues values) {
                      // TODO(alex): onChangedEnd should be called instead and update when values are different
                      setState(() => _ages = values);
                    })),
          ])
        ]));
  }

  @override
  Widget build(BuildContext context) {
    _appDataService = Provider.of<AppDataService>(context);
    _messageService = Provider.of<MessageService>(context);
    _userProvider = Provider.of<UserModel>(context);
    final User user = Provider.of<User>(context);
    final ConversationList conversationList =
        Provider.of<ConversationList>(context);
    return FutureBuilder<List<User>>(
        future: _userProvider.getUsers(_appDataService.identifier,
            interests: _interests.map<String>((Interest interest) => interest.name).toList(),
            ageStart: _ages.start.toInt(),
            ageEnd: _ages.end.toInt()),
        builder: (BuildContext context, AsyncSnapshot<List<User>> users) =>
            RubberBottomSheet(
                animationController: _controller,
                upperLayer: _buildUpperLayer(users, conversationList, user),
                lowerLayer: _buildLowerLayer()));
  }
}
