import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:business/lounges/actions/lounge_join_action.dart';
import 'package:business/lounges/actions/lounge_leave_action.dart';

import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/cached_image.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class LoungesScreen extends StatelessWidget {
  const LoungesScreen(this.event);

  final Event event;

  static const String id = 'LoungesScreen';

// TODO(robin): if lounge is full dont show it
  Widget _buildLounge(Lounge lounge,
      void Function(redux.ReduxAction<AppState>) dispatch, AppState state) {
    final User owner =
        lounge.members.firstWhere((User member) => member.id == lounge.owner);
    final int availableSlots = lounge.memberLimit - lounge.members.length;
    final String s = availableSlots <= 1 ? '' : 's';

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
        Widget>[
      if (owner != null)
        CachedImage(
          owner.pics.isNotEmpty ? owner.pics[0] : null,
          width: 40.0,
          height: 40.0,
          borderRadius: BorderRadius.circular(180.0),
        ),
      Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
                  Widget>[
                Container(
                    child: RichText(
                        text: TextSpan(
                            text: state.userState.user.id == owner.id
                                ? 'Your Lounge'
                                : owner.name + '\'s Lounge',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w500)))),
                GestureDetector(
                    onTap: () {
                      // TODO(robin): this shouldnt exist, the owner shouldnt see a join button on his own lounges and maybe not even see it here (ask @nadir)
                      if (lounge.owner == state.userState.user.id) {
                        return;
                      }
                      if (lounge.memberIds.contains(state.userState.user.id)) {
                        dispatch(
                            LoungeLeaveAction(state.userState.user.id, lounge));
                      } else {
                        dispatch(
                            LoungeJoinAction(state.userState.user.id, lounge));
                      }
                    },
                    child: Container(
                        child: RichText(
                            text: TextSpan(
                                text: lounge.memberIds
                                        .contains(state.userState.user.id)
                                    ? '< LEAVE'
                                    : ' > JOIN ', // TODO(me): add arrow icon
                                style: const TextStyle(
                                    color: orange,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700))))),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
                  Widget>[
                Text('$availableSlots slot$s available'),
                Row(children: <Widget>[
                  for (User member in lounge.members)
                    if (member.id != lounge.owner)
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: CachedImage(
                              member.pics.isNotEmpty ? member.pics[0] : null,
                              width: 20.0,
                              height: 20.0,
                              borderRadius: BorderRadius.circular(180.0))),
                  for (int index = 0; index < availableSlots; index++)
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        width: 20.0,
                        height: 20.0,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(180))),
                ]),
              ]),
            ]),
          )),
    ]);
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(children: <Widget>[
          Container(
              constraints: BoxConstraints.expand(
                height: Theme.of(context).textTheme.display1.fontSize * 1.1,
              ),
              child: RichText(
                  textAlign: TextAlign.left,
                  text: const TextSpan(
                      text: 'FOR THE EVENT',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w500)))),
          Container(
              child: Row(children: <Widget>[
            if (event.pic.isNotEmpty)
              Flexible(
                  child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              left: BorderSide(color: orange, width: 3.0))),
                      child: CachedImage(event.pic,
                          width: 30.0,
                          height: 30.0,
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(5.0),
                              topRight: Radius.circular(5.0))))),
            Expanded(
                flex: 8,
                child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            text: event.name,
                            style: const TextStyle(
                                color: orange,
                                fontSize: 12,
                                fontWeight: FontWeight.w700))))),
          ])),
        ]));
  }

  Widget _buildListLounges(List<Lounge> lounges,
      void Function(redux.ReduxAction<AppState>) dispatch, AppState state) {
    if (lounges == null) {
      return Container(); // TODO(robin): handle no lounge @anthony
    }
    return Container(
        child: Container(
            padding: const EdgeInsets.only(left: 10, right: 30),
            child: ListView.builder(
                itemCount: lounges.length,
                itemBuilder: (BuildContext context, int index) => Container(
                    padding: const EdgeInsets.all(10.0),
                    child: _buildLounge(lounges[index], dispatch, state)))));
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<AppState>) dispatch,
        Widget child) {
      final List<Lounge> lounges = state.userState.eventLounges[event.id];
      return View(
          title: 'BROWSING LOUNGES',
          child: Column(children: <Widget>[
            Expanded(
                child: Container(
                    child: Column(children: <Widget>[
              _buildHeader(context),
              const Divider(),
              Expanded(child: _buildListLounges(lounges, dispatch, state)),
            ])))
          ]));
    });
  }
}
