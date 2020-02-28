import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/event_group.dart';
import 'package:business/classes/interest.dart';
import 'package:business/classes/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/circular_image.dart';
import 'package:inclusive/widgets/image_stack.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class EventGroupsScreen extends StatefulWidget {
  static const String id = 'EventGroupsScreen';

  @override
  _EventGroupsScreenState createState() => _EventGroupsScreenState();
}

class _EventGroupsScreenState extends State<EventGroupsScreen> {
  EventGroup group;
  ThemeStyle _themeStyle;

  Widget _buildGroup(EventGroup group, BuildContext context,
      void Function(redux.ReduxAction<AppState>) dispatch) {
    if (group.members == null) {
      return const CircularProgressIndicator(backgroundColor: pink);
    }
    final List<String> imageList =
        group.members.map<String>((User user) => user.pics[0]).toList();
    return GestureDetector(
        onTap: () => setState(() => this.group = group),
        child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
                gradient: gradient, borderRadius: BorderRadius.circular(10.0)),
            padding: const EdgeInsets.all(10.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  if (imageList.isNotEmpty)
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          ImageStack(
                            imageList: imageList,
                            imageRadius: 50.0,
                            imageBorderWidth: 0.0,
                            imageCount: 3,
                            totalCount: imageList.length,
                          ),
                        ]),
                  Text(
                    group.name,
                    style: textStyleCardTitleAlt,
                    textAlign: TextAlign.center,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(group.memberIds.length.toString(),
                            style: textStyleCardTitleAlt),
                        Container(
                            width: 25.0,
                            child: Image.asset('images/usuario_alt.png',
                                color: white)),
                      ]),
                ])));
  }

  Widget _buildSelectedGroup(EventGroup group) {
    return Flexible(
        child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      if (group.interests.isNotEmpty) _buildInterests(group.interests),
      if (group.members != null && group.members.isNotEmpty)
        _buildMembers(group.members),
    ])));
  }

  Widget _buildInterests(List<Interest> interests) {
    return Card(
        color: white,
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text('Interests', style: textStyleCardTitle(_themeStyle)),
              Flexible(
                  child: Container(
                height: 50.0,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: interests.length,
                    itemBuilder: (BuildContext context, int index) => Container(
                        width: 50.0,
                        height: 50.0,
                        margin: const EdgeInsets.only(right: 10.0),
                        child: CachedNetworkImage(
                            imageUrl:
                                'https://firebasestorage.googleapis.com/v0/b/incl-9b378.appspot.com/o/images%2Finterests%2F${interests[index].name}.png?alt=media',
                            placeholder: (BuildContext context, String url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (BuildContext context, String url,
                                    Object error) =>
                                Icon(Icons.error)))),
              ))
            ])));
  }

  Widget _buildMembers(List<User> members) {
    return Card(
        color: white,
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(children: <Widget>[
              Flexible(
                  flex: 2,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Members', style: textStyleCardTitle(_themeStyle)),
                        for (final User member in members)
                          if (member != null)
                            Row(children: <Widget>[
                              Container(
                                  margin: const EdgeInsets.all(5.0),
                                  child: CircularImage(
                                    imageUrl: member.pics[0],
                                    imageRadius: 50.0,
                                  )),
                              Text(member.name),
                            ])
                      ])),
              Flexible(
                  child: Column(
                children: <Widget>[
                  GestureDetector(
                      onTap: () {},
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(180.0),
                              color: pink),
                          width: 100.0,
                          height: 100.0,
                          padding: const EdgeInsets.all(20.0),
                          child: const Center(
                              child: Text(
                            'JOIN',
                            style: textStyleButton,
                            textAlign: TextAlign.center,
                          ))))
                ],
              ))
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<AppState>) dispatch,
        Widget child) {
      final Event event = state.eventsState.event;
      final List<EventGroup> groups = state.eventsState.groups;
      _themeStyle = state.theme;

      return View(
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${event.name} Groups', style: textStyleTitle),
                    if (groups == null)
                      const CircularProgressIndicator(backgroundColor: pink)
                    else
                      Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: groups.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  _buildGroup(
                                      groups[index], context, dispatch))),
                    if (groups.isNotEmpty)
                      _buildSelectedGroup(group ?? groups[0]),
                  ])));
    });
  }
}
