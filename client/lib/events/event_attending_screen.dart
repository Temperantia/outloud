import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/cached_image.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class EventAttendingScreen extends StatefulWidget {
  const EventAttendingScreen(this.event);
  final Event event;

  static const String id = 'EventAttendingScreen';

  @override
  _EventAttendingScreenState createState() => _EventAttendingScreenState();
}

class _EventAttendingScreenState extends State<EventAttendingScreen> {
  Widget _buildHeader() {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(children: <Widget>[
          Row(children: const <Widget>[
            Text('FOR THE EVENT',
                style: TextStyle(
                    color: black, fontSize: 13, fontWeight: FontWeight.w500)),
          ]),
          Container(
              child: Row(children: <Widget>[
            Flexible(
                child: CachedImage(widget.event.pic,
                    width: 30.0,
                    height: 30.0,
                    borderRadius: BorderRadius.circular(5.0),
                    imageType: ImageType.Event)),
            Expanded(
                flex: 8,
                child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(widget.event.name,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                            color: orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)))),
          ])),
        ]));
  }

  Widget _buildList() {
    final int memberNumber = widget.event.memberIds.length;
    final List<User> members = widget.event.members;
    return Expanded(
        child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
            child: Column(children: <Widget>[
              Container(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                    '${memberNumber.toString()} ${memberNumber <= 1 ? 'person is' : 'people are'} attending this event',
                    style: const TextStyle(
                        color: orange, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20.0,
                              childAspectRatio: 3.0),
                      itemCount: members.length,
                      itemBuilder: (BuildContext context, int index) =>
                          _buildMember(members[index])))
            ])));
  }

  Widget _buildMember(User member) {
    final String pic = member.pics.isEmpty ? null : member.pics[0];
    return GestureDetector(
        child: Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: orangeLight, borderRadius: BorderRadius.circular(5.0)),
            child: Row(children: <Widget>[
              CachedImage(pic,
                  width: 40.0,
                  height: 40.0,
                  borderRadius: BorderRadius.circular(20.0),
                  imageType: ImageType.User),
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(member.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))
                          ])))
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<AppState>) dispatch,
        Widget child) {
      return View(
          child: Column(children: <Widget>[
        _buildHeader(),
        const Divider(),
        _buildList()
      ]));
    });
  }
}
