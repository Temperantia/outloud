import 'package:business/classes/user.dart';
import 'package:flutter/widgets.dart';
import 'package:business/app_state.dart';
import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/classes/lounge.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/cached_image.dart';
import 'package:inclusive/widgets/circular_image.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class LoungeEditScreen extends StatefulWidget {
  const LoungeEditScreen(this.lounge);
  final Lounge lounge;
  static const String id = 'LoungeEditScreen';

  @override
  _LoungeEditScreenState createState() => _LoungeEditScreenState(lounge);
}

class _LoungeEditScreenState extends State<LoungeEditScreen> {
  _LoungeEditScreenState(this.lounge);
  final Lounge lounge;

  Widget _buildHeader(BuildContext context, AppState state) {
    final User owner =
        lounge.members.firstWhere((User member) => member.id == lounge.owner);
    return Container(
        padding: const EdgeInsets.all(15.0),
        child: Row(children: <Widget>[
          if (lounge.event.pic.isNotEmpty)
            Flexible(flex: 2, child: CachedImage(lounge.event.pic)),
          Flexible(
              flex: 8,
              child: Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(children: <Widget>[
                    Container(
                        child: Row(children: <Widget>[
                      Container(
                          child: CircularImage(
                        imageUrl: owner.pics.isNotEmpty ? owner.pics[0] : null,
                        imageRadius: 40.0,
                      )),
                      Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: RichText(
                              text: TextSpan(
                            text: state.userState.user.id == owner.id
                                ? 'Your Lounge'
                                : owner.name + '\'s Lounge',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          ))),
                    ])),
                    Container(
                        child: Row(children: <Widget>[
                      Container(
                          child: RichText(
                              text: TextSpan(
                                  text: lounge.members.length.toString() +
                                      ' member' +
                                      (lounge.members.length > 1 ? 's ' : ' '),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                  children: <TextSpan>[
                            TextSpan(
                                text: lounge.event.name,
                                style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800)),
                          ]))),
                    ])),
                  ]))),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<dynamic>) dispatch,
        Widget child) {
      return View(
          title: 'EDIT LOUNGE',
          child: Container(
              child: Column(children: <Widget>[
            Expanded(
                child: Container(
                    color: white,
                    child: Container(
                        child: Column(children: <Widget>[
                      _buildHeader(context, state),
                      const Divider(),
                    ])))),
          ])));
    });
  }
}
