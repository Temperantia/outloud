import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/actions/app_navigate_action.dart';
import 'package:business/classes/chat_state.dart';
import 'package:business/classes/user.dart';
import 'package:business/actions/app_disconnect_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:gradient_bottom_navigation_bar/gradient_bottom_navigation_bar.dart';
import 'package:outloud/profile/profile_screen.dart';

import 'package:outloud/theme.dart';
import 'package:outloud/widgets/bubble_bar.dart';
import 'package:outloud/widgets/cached_image.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class View extends StatefulWidget {
  const View(
      {@required this.child,
      this.showAppBar = true,
      this.showNavBar = true,
      this.title,
      this.isRoot = false,
      this.isProfileScreen = false,
      this.isEditing = false,
      this.user,
      this.onBack,
      this.backIcon = Icons.keyboard_arrow_left,
      this.actions,
      this.buttons});

  final Widget child;
  final bool showAppBar;
  final bool showNavBar;
  final bool isRoot;
  final bool isProfileScreen;
  final bool isEditing;
  final User user;
  final dynamic title;
  final void Function() onBack;
  final IconData backIcon;
  final Widget actions;
  final Widget buttons;

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  bool _showUserSettings = false;

  Widget _buildBody(
      AppState state, void Function(ReduxAction<dynamic>) dispatch) {
    return widget.buttons == null
        ? widget.child
        : Column(children: <Widget>[
            Expanded(child: widget.child),
            Container(
                padding: const EdgeInsets.only(top: 5.0),
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: <Color>[pinkLight, pink])),
                child: widget.buttons)
          ]);
  }

  Widget _buildUserSettings(
      User user, void Function(ReduxAction<dynamic>) dispatch) {
    return Container(
        width: 300.0,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/userMenuBG.png'), fit: BoxFit.cover)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Row(children: <Widget>[
            if (user == null)
              const CircularProgressIndicator()
            else
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () => setState(
                          () => _showUserSettings = !_showUserSettings),
                      child: CachedImage(
                          user.pics.isEmpty ? null : user.pics[0],
                          width: 40.0,
                          height: 40.0,
                          borderRadius: BorderRadius.circular(60.0),
                          imageType: ImageType.User))),
          ]),
          GestureDetector(
              onTap: () {
                dispatch(NavigateAction<AppState>.pushNamed(ProfileScreen.id,
                    arguments: <String, dynamic>{'user': user}));
                setState(() => _showUserSettings = false);
              },
              child: Row(children: <Widget>[
                Container(
                    width: 20.0,
                    height: 20.0,
                    child: Image.asset('images/iconView.png', color: white)),
                Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                        FlutterI18n.translate(context, 'MENU_USER.OPTION_1'),
                        style: const TextStyle(color: white, fontSize: 10.0))),
              ])),
          GestureDetector(
              onTap: () {
                dispatch(NavigateAction<AppState>.pushNamed(ProfileScreen.id,
                    arguments: <String, dynamic>{
                      'user': user,
                      'isEdition': true
                    }));
                setState(() => _showUserSettings = false);
              },
              child: Row(children: <Widget>[
                Container(
                    width: 20.0,
                    height: 20.0,
                    child: Image.asset('images/iconEdit.png', color: white)),
                Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                        FlutterI18n.translate(context, 'MENU_USER.OPTION_2'),
                        style: const TextStyle(color: white, fontSize: 10.0))),
              ])),
          const Divider(),
          GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .popUntil((Route<dynamic> route) => route.isFirst);
                dispatch(AppDisconnectAction());
                setState(() => _showUserSettings = false);
              },
              child: Row(children: <Widget>[
                Container(
                    width: 20.0,
                    height: 20.0,
                    child: Image.asset('images/iconLeave.png', color: white)),
                Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                        FlutterI18n.translate(context, 'MENU_USER.OPTION_3'),
                        style: const TextStyle(color: white, fontSize: 10.0))),
              ]))
        ]));
  }

  Widget _buildNavBar(
      AppState state, void Function(ReduxAction<dynamic>) dispatch) {
    int newMessageCount = 0;
    int newMessageLoungeCount = 0;
    for (final ChatState chatState
        in state.chatsState.usersChatsStates[state.userState.user.id].values) {
      newMessageCount += chatState.countNewMessages();
    }
    for (final ChatState chatState in state
        .chatsState.loungesChatsStates[state.userState.user.id].values) {
      newMessageLoungeCount += chatState.countNewMessages();
    }
    return GradientBottomNavigationBar(
        backgroundColorStart: pinkLight,
        backgroundColorEnd: pink,
        type: BottomNavigationBarType.fixed,
        currentIndex: state.homePageIndex,
        items: bubbleBar(
            context, newMessageCount, newMessageLoungeCount, state.theme),
        onTap: (int index) async {
          if (index == state.homePageIndex) {
            return;
          }
          dispatch(AppNavigateAction(index));
          Navigator.of(context)
              .popUntil((Route<dynamic> route) => route.isFirst);
        });
  }

  @override
  Widget build(BuildContext context) {
    return ReduxSelector<AppState, dynamic>(
        selector: (BuildContext context, AppState state) =>
            <dynamic>[state.homePageIndex, state.userState.user],
        builder: (BuildContext context,
            Store<AppState> store,
            AppState state,
            void Function(ReduxAction<dynamic>) dispatch,
            dynamic model,
            Widget w) {
          final User user = state.userState.user;
          return DefaultTabController(
              length: 2,
              child: Stack(children: <Widget>[
                Scaffold(
                    appBar: widget.showAppBar
                        ? AppBar(
                            elevation: 0.0,
                            leading: user == null
                                ? const CircularProgressIndicator()
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                        onTap: () => setState(() =>
                                            _showUserSettings =
                                                !_showUserSettings),
                                        child:
                                            CachedImage(user.pics.isEmpty ? null : user.pics[0],
                                                width: 40.0,
                                                height: 40.0,
                                                borderRadius:
                                                    BorderRadius.circular(60.0),
                                                imageType: ImageType.User))),
                            centerTitle: true,
                            title: Stack(alignment: Alignment.center, children: <
                                Widget>[
                              if (widget.title is String)
                                Text(widget.title as String,
                                    style: const TextStyle(
                                        color: white, fontSize: 14.0))
                              else
                                widget.title is TabBar
                                    ? widget.title as TabBar
                                    : Container(width: 0.0, height: 0.0),
                              if (Navigator.canPop(context))
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: GestureDetector(
                                        onTap: widget.onBack ??
                                            () => dispatch(
                                                NavigateAction<AppState>.pop()),
                                        child: Icon(widget.backIcon,
                                            color: white)))
                            ]),
                            titleSpacing: 0.0,
                            actions: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                width: 40.0,
                                height: 40.0,
                                //child: Image.asset('images/hamburger.png')
                              )
                            ],
                            flexibleSpace: Image.asset('images/screenTop.png',
                                fit: BoxFit.fill),
                            backgroundColor: Colors.transparent)
                        : null,
                    bottomNavigationBar: widget.showNavBar
                        ? _buildNavBar(state, dispatch)
                        : Container(
                            width: 0.0,
                            height: 0.0,
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(colors: <Color>[pinkLight, pink]))),
                    body: SafeArea(child: _buildBody(state, dispatch))),
                if (_showUserSettings)
                  SafeArea(
                      child:
                          Material(child: _buildUserSettings(user, dispatch)))
              ]));
        });
  }
}
