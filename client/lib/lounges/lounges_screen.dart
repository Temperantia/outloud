import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';
import 'package:business/lounges/actions/lounge_create_action.dart';
import 'package:business/models/user.dart';
import 'package:flutter/material.dart';
import 'package:business/lounges/actions/lounge_join_action.dart';
import 'package:business/lounges/actions/lounge_leave_action.dart';
import 'package:inclusive/functions/loader_animation.dart';
import 'package:inclusive/lounges/lounge_chat_screen.dart';
import 'package:inclusive/lounges/lounge_create_detail_screen.dart';

import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/button.dart';
import 'package:inclusive/widgets/cached_image.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class LoungesScreen extends StatefulWidget {
  const LoungesScreen(this.event);
  final Event event;
  static const String id = 'LoungesScreen';

  @override
  _LoungesScreenState createState() => _LoungesScreenState(event);
}

class _LoungesScreenState extends State<LoungesScreen>
    with TickerProviderStateMixin {
  _LoungesScreenState(this.event);

  final Event event;
  Map<String, User> _owners;

  @override
  void initState() {
    super.initState();
    _owners = <String, User>{};
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> resolveOwner(String loungeId, String ownerId) async {
    if (_owners.containsKey(loungeId)) {
      return;
    }
    final User owner = await getUser(ownerId);
    setState(() {
      _owners[loungeId] = owner;
    });
  }

// TODO(robin): if lounge is full dont show it
  Widget _buildLounge(
      Lounge lounge,
      Future<void> Function(redux.ReduxAction<AppState>) dispatchFuture,
      void Function(redux.ReduxAction<AppState>) dispatch,
      AppState state) {
    resolveOwner(lounge.id, lounge.owner);
    final User owner = _owners[lounge.id];
    if (owner == null) {
      return Container();
    }
    if (owner.id == state.userState.user.id) {
      return Container();
    }
    final int availableSlots = lounge.memberLimit - lounge.memberIds.length;
    final String s = availableSlots <= 1 ? '' : 's';

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
        Widget>[
      CachedImage(owner != null && owner.pics.isNotEmpty ? owner.pics[0] : null,
          width: 40.0,
          height: 40.0,
          borderRadius: BorderRadius.circular(20.0),
          imageType: ImageType.User),
      Expanded(
          flex: 3,
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      if (owner != null)
                        Container(
                            child: RichText(
                                text: TextSpan(
                                    text: state.userState.user.id == owner.id
                                        ? 'Your Lounge'
                                        : owner.name + '\'s Lounge',
                                    style: const TextStyle(
                                        color: black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500)))),
                      GestureDetector(
                          onTap: () async {
                            // TODO(robin): this shouldnt exist, the owner shouldnt see a join button on his own lounges and maybe not even see it here (ask @nadir)
                            if (lounge.owner == state.userState.user.id) {
                              return;
                            }
                            if (lounge.memberIds
                                .contains(state.userState.user.id)) {
                              dispatch(LoungeLeaveAction(
                                  state.userState.user.id, lounge));
                            } else {
                              await dispatchFuture(LoungeJoinAction(
                                  state.userState.user.id, lounge));
                              await showLoaderAnimation(context, this,
                                  animationDuration: 600);
                              await dispatchFuture(
                                  redux.NavigateAction<AppState>.pop());
                              dispatch(redux.NavigateAction<AppState>.pushNamed(
                                  LoungeChatScreen.id,
                                  arguments: lounge));
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
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('$availableSlots slot$s available'),
                      Row(children: <Widget>[
                        for (User member in lounge.members)
                          if (member.id != lounge.owner)
                            Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: CachedImage(
                                    member.pics.isEmpty ? null : member.pics[0],
                                    width: 20.0,
                                    height: 20.0,
                                    borderRadius: BorderRadius.circular(20.0),
                                    imageType: ImageType.User)),
                        for (int index = 0; index < availableSlots; index++)
                          Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              width: 20.0,
                              height: 20.0,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(180))),
                      ])
                    ])
              ])))
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
                          color: black,
                          fontSize: 13,
                          fontWeight: FontWeight.w500)))),
          Container(
              child: Row(children: <Widget>[
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
                            topRight: Radius.circular(5.0)),
                        imageType: ImageType.Event))),
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

  Widget _buildListLounges(
      List<Lounge> lounges,
      Future<void> Function(redux.ReduxAction<AppState>) dispatchFuture,
      void Function(redux.ReduxAction<AppState>) dispatch,
      AppState state) {
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
                    child: _buildLounge(
                        lounges[index], dispatchFuture, dispatch, state)))));
  }

  Widget _noLoungeWidget(void Function(redux.ReduxAction<AppState>) dispatch) {
    return Container(
      width: 320,
      child: Column(
        children: <Widget>[
          Container(
            width: 320,
            height: 300,
            child: Image.asset('images/lounges_empty_cat.png'),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Button(
              text: 'CREATE YOUR OWN LOUNGE',
              backgroundColor: blueDark,
              backgroundOpacity: 1,
              width: 320,
              fontWeight: FontWeight.w700,
              onPressed: () {
                dispatch(LoungeCreateAction(
                  event.id,
                ));
                dispatch(redux.NavigateAction<AppState>.pushNamed(
                    LoungeCreateDetailScreen.id));
              },
            ),
          )
        ],
      ),
    );
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
              if (lounges == null) _noLoungeWidget(dispatch),
              if (lounges != null && lounges.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 20),
                  child: RichText(
                      text: TextSpan(
                          text: '${lounges.length} lounge' +
                              (lounges.length > 1 ? 's' : '') +
                              ' available for this event',
                          style: const TextStyle(
                              color: orange,
                              fontSize: 14,
                              fontWeight: FontWeight.w600))),
                ),
              if (lounges != null && lounges.isNotEmpty)
                Expanded(
                    child: _buildListLounges(
                        lounges, store.dispatchFuture, dispatch, state)),
            ])))
          ]));
    });
  }
}
