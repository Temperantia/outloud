import 'package:async_redux/async_redux.dart'
    show ReduxAction, NavigateAction, Store;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/user.dart';
import 'package:flutter/material.dart';
import 'package:business/lounges/actions/lounge_join_action.dart';
import 'package:business/lounges/actions/lounge_leave_action.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:outloud/lounges/lounge_chat_screen.dart';
import 'package:outloud/lounges/lounge_create_screen.dart';
import 'package:outloud/lounges/lounge_view_screen.dart';

import 'package:outloud/theme.dart';
import 'package:outloud/widgets/button.dart';
import 'package:outloud/widgets/cached_image.dart';
import 'package:outloud/widgets/content_list.dart';
import 'package:outloud/widgets/event_image.dart';
import 'package:outloud/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class LoungesScreen extends StatefulWidget {
  const LoungesScreen(this.event);
  final Event event;
  static const String id = 'LoungesScreen';

  @override
  _LoungesScreenState createState() => _LoungesScreenState();
}

class _LoungesScreenState extends State<LoungesScreen>
    with TickerProviderStateMixin {
  void Function(ReduxAction<AppState>) _dispatch;
  Map<String, User> _owners;

  @override
  void initState() {
    super.initState();
    _owners = <String, User>{};
  }

// TODO(alexandre): no
  Future<void> resolveOwner(String loungeId, String ownerId) async {
    if (_owners.containsKey(loungeId)) {
      return;
    }
    final User owner = await getUser(ownerId);
    setState(() => _owners[loungeId] = owner);
  }

// TODO(robin): if lounge is full dont show it
  Widget _buildLounge(Lounge lounge, String userId) {
    resolveOwner(lounge.id, lounge.owner);
    final User owner = _owners[lounge.id];
    if (owner == null) {
      return Container(width: 0.0, height: 0.0);
    }
    if (owner.id == userId) {
      return Container(width: 0.0, height: 0.0);
    }
    final int availableSlots = lounge.memberLimit - lounge.memberIds.length;
    final String s = availableSlots <= 1 ? '' : 's';

    return GestureDetector(
        onTap: () => _dispatch(NavigateAction<AppState>.pushNamed(
            LoungeViewScreen.id,
            arguments: <String, dynamic>{'lounge': lounge, 'isEdit': false})),
        child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: CachedImage(
                          owner != null && owner.pics.isNotEmpty
                              ? owner.pics[0]
                              : null,
                          width: 40.0,
                          height: 40.0,
                          borderRadius: BorderRadius.circular(20.0),
                          imageType: ImageType.User)),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                        Row(children: <Widget>[
                          Expanded(
                              child: Wrap(children: <Widget>[
                            if (owner != null)
                              I18nText(
                                  userId == owner.id
                                      ? 'LOUNGE_CHAT.YOUR_LOUNGE'
                                      : 'LOUNGE_CHAT.SOMEONES_LOUNGE',
                                  child: const Text('',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500)),
                                  translationParams: <String, String>{
                                    'user': owner.name
                                  })
                          ])),
                          GestureDetector(
                              onTap: () async {
                                // TODO(robin): this shouldnt exist, the owner shouldnt see a join button on his own lounges and maybe not even see it here (ask @nadir)
                                if (lounge.owner == userId) {
                                  return;
                                }
                                if (lounge.memberIds.contains(userId)) {
                                  _dispatch(LoungeLeaveAction(userId, lounge));
                                } else {
                                  /*  await showLoaderAnimation(context, this,
                                      animationDuration: 600); */
                                  _dispatch(LoungeJoinAction(userId, lounge));
                                  _dispatch(NavigateAction<AppState>.pop());
                                  _dispatch(NavigateAction<AppState>.pushNamed(
                                      LoungeChatScreen.id,
                                      arguments: lounge));
                                }
                              },
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 20.0),
                                  decoration: const BoxDecoration(color: blue),
                                  child: AutoSizeText(
                                      lounge.memberIds.contains(userId)
                                          ? FlutterI18n.translate(
                                              context, 'LOUNGES.LEAVE')
                                          : FlutterI18n.translate(context,
                                              'LOUNGES.JOIN'), // TODO(me): add arrow icon
                                      style: const TextStyle(
                                          color: white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700))))
                        ]),
                        Wrap(
                            runAlignment: WrapAlignment.spaceBetween,
                            children: <Widget>[
                              Wrap(children: <Widget>[
                                for (User member in lounge.members)
                                  if (member.id != lounge.owner)
                                    Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: CachedImage(
                                            member.pics.isEmpty
                                                ? null
                                                : member.pics[0],
                                            width: 20.0,
                                            height: 20.0,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            imageType: ImageType.User)),
                                for (int index = 0;
                                    index < availableSlots;
                                    index++)
                                  Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      width: 20.0,
                                      height: 20.0,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(180))),
                                AutoSizeText(
                                    '$availableSlots ${FlutterI18n.translate(context, "LOUNGES.SLOT")}$s ${FlutterI18n.translate(context, "LOUNGES.AVAILABLE")}'),
                              ])
                            ])
                      ]))
                ])));
  }

  Widget _buildHeader(BuildContext context) => Container(
      padding: const EdgeInsets.all(15),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AutoSizeText(
                FlutterI18n.translate(context, 'LOUNGES.FOR_THE_EVENT'),
                textAlign: TextAlign.left,
                style: const TextStyle(
                    color: black, fontSize: 13, fontWeight: FontWeight.bold)),
            Row(children: <Widget>[
              EventImage(
                  image: widget.event.pic, size: 50.0, hasOverlay: false),
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: AutoSizeText(widget.event.name,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                              color: orange,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)))),
            ])
          ]));

  Widget _buildListLounges(List<Lounge> lounges, String userId) =>
      ContentList<Lounge>(
          items: lounges,
          builder: (Lounge lounge) => _buildLounge(lounge, userId));

  Widget _noLoungeWidget() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          AutoSizeText(FlutterI18n.translate(context, 'LOUNGES.EMPTY_TITLE'),
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          AutoSizeText(
              FlutterI18n.translate(context, 'LOUNGES.EMPTY_DESCRIPTION'),
              style: const TextStyle(color: grey))
        ]),
        Image.asset('images/catsIllus3.png')
      ]);

  @override
  Widget build(BuildContext context) =>
      ReduxConsumer<AppState>(builder: (BuildContext context,
          Store<AppState> store,
          AppState state,
          void Function(ReduxAction<AppState>) dispatch,
          Widget child) {
        _dispatch = dispatch;
        final List<Lounge> lounges = List<Lounge>.of(
            state.userState.eventLounges[widget.event.id] ?? <Lounge>[]);
        lounges.removeWhere(
            (Lounge lounge) => lounge.memberIds.length >= lounge.memberLimit);
        return View(
            title: FlutterI18n.translate(context, 'LOUNGES.BROWSING_LOUNGES'),
            buttons: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Button(
                      text: FlutterI18n.translate(
                          context, 'LOUNGES_TAB.CREATE_LOUNGE'),
                      width: 250,
                      onPressed: () => dispatch(
                          NavigateAction<AppState>.pushNamed(
                              LoungeCreateScreen.id)))
                ]),
            child: Column(children: <Widget>[
              _buildHeader(context),
              const Divider(color: orange),
              if (lounges == null || lounges.isEmpty)
                _noLoungeWidget()
              else if (lounges.isNotEmpty)
                Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    child: AutoSizeText(
                        '${lounges.length} ${FlutterI18n.translate(context, "LOUNGES.LOUNGE")}' +
                            (lounges.length > 1 ? 's' : '') +
                            ' ' +
                            FlutterI18n.translate(
                                context, 'LOUNGES.AVAILABLE_FOR_EVENT'),
                        style: const TextStyle(
                            color: orange,
                            fontSize: 14,
                            fontWeight: FontWeight.w600))),
              if (lounges != null && lounges.isNotEmpty)
                Expanded(
                    child: _buildListLounges(lounges, state.userState.user.id))
            ]));
      });
}
