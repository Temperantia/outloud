import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/actions/app_navigate_action.dart';
import 'package:business/classes/chat_state.dart';
import 'package:business/classes/user.dart';
import 'package:business/actions/app_disconnect_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
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
      this.title = '',
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
  final String title;
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
    EdgeInsetsGeometry margin;
    if (widget.isRoot) {
      margin = const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 65.0);
    } else if (widget.showAppBar && widget.showNavBar) {
      margin = EdgeInsets.fromLTRB(
          0.0, 105.0, 0.0, widget.buttons == null ? 50.0 : 120.0);
    }

    if (widget.isProfileScreen) {
      return SafeArea(
          child: Stack(children: <Widget>[
        Row(children: <Widget>[
          Expanded(
              child: widget.isEditing
                  ? Image.asset('images/screenFull.png', fit: BoxFit.fill)
                  : Image.asset('images/screenNoTop.png', fit: BoxFit.fill))
        ]),
        widget.child,
        _buildAppBar(state.userState.user, dispatch),
      ]));
    }

    return SafeArea(
        child: Stack(children: <Widget>[
      SizedBox.expand(
          child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[pinkLight, pink])))),
      if (widget.isRoot || widget.showNavBar || widget.buttons != null)
        SizedBox.expand(
            child: Container(
                margin: EdgeInsets.only(
                    bottom: widget.isRoot ||
                            (widget.showNavBar && widget.buttons != null)
                        ? 120.0
                        : 50.0),
                decoration: BoxDecoration(
                    color: white, borderRadius: BorderRadius.circular(40.0)))),
      if (widget.showAppBar)
        Row(children: <Widget>[
          Expanded(
              child: Image.asset('images/screenTop.png', fit: BoxFit.fitWidth))
        ]),
      Container(margin: margin, child: widget.child),
      if (widget.showAppBar) _buildAppBar(state.userState.user, dispatch),
      Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        if (widget.buttons != null) widget.buttons,
        if (widget.showNavBar) _buildNavBar(state, dispatch),
      ])
    ]));
  }

  Widget _buildAppBar(User user, void Function(ReduxAction<dynamic>) dispatch) {
    return Column(children: <Widget>[
      Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    width: 40.0,
                    height: 40.0,
                    child: Image.asset('images/OL-draft1aWhite.png')),
                if (user == null)
                  const CircularProgressIndicator()
                else if (!widget.isProfileScreen)
                  GestureDetector(
                      onTap: () => setState(
                          () => _showUserSettings = !_showUserSettings),
                      child: CachedImage(
                          user.pics.isEmpty ? null : user.pics[0],
                          width: 40.0,
                          height: 40.0,
                          borderRadius: BorderRadius.circular(20.0),
                          imageType: ImageType.User)),
                Container(width: 40, height: 40),
                //Icon(Icons.menu),
              ])),
      if (_showUserSettings || !widget.isRoot)
        Stack(children: <Widget>[
          if (!widget.isRoot)
            Stack(children: <Widget>[
              GestureDetector(
                  onTap: widget.onBack ??
                      () => dispatch(NavigateAction<AppState>.pop()),
                  child: Container(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Icon(widget.backIcon, color: white))),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.title,
                        textAlign: TextAlign.center, style: textStyleTitleAlt),
                  ]),
              if (widget.actions != null)
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[widget.actions]),
            ]),
          if (_showUserSettings) _buildUserSettings(user, dispatch),
        ]),
    ]);
  }

  Widget _buildUserSettings(
      User user, void Function(ReduxAction<dynamic>) dispatch) {
    return Row(children: <Widget>[
      Expanded(
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/menuExpanded.png'),
                      fit: BoxFit.fill)),
              child: Padding(
                  padding: const EdgeInsets.only(left: 150.0),
                  child: Column(children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          dispatch(NavigateAction<AppState>.pushNamed(
                              ProfileScreen.id,
                              arguments: <String, dynamic>{'user': user}));
                          setState(() => _showUserSettings = false);
                        },
                        child: Row(children: <Widget>[
                          Container(
                              width: 20.0,
                              height: 20.0,
                              child: Image.asset('images/iconView.png',
                                  color: white)),
                          Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                  FlutterI18n.translate(
                                      context, 'MENU_USER.OPTION_1'),
                                  style: const TextStyle(color: white))),
                        ])),
                    GestureDetector(
                        onTap: () {
                          dispatch(NavigateAction<AppState>.pushNamed(
                              ProfileScreen.id,
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
                              child: Image.asset('images/iconEdit.png',
                                  color: white)),
                          Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                  FlutterI18n.translate(
                                      context, 'MENU_USER.OPTION_2'),
                                  style: const TextStyle(color: white))),
                        ])),
                    const Divider(),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).popUntil(
                              (Route<dynamic> route) => route.isFirst);
                          dispatch(AppDisconnectAction());
                          setState(() => _showUserSettings = false);
                        },
                        child: Row(children: <Widget>[
                          Container(
                              width: 20.0,
                              height: 20.0,
                              child: Image.asset('images/iconLeave.png',
                                  color: white)),
                          Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                  FlutterI18n.translate(
                                      context, 'MENU_USER.OPTION_3'),
                                  style: const TextStyle(color: white))),
                        ]))
                  ]))))
    ]);
  }

  Widget _buildNavBar(
      AppState state, void Function(ReduxAction<dynamic>) dispatch) {
    int newMessageCount = 0;
    int newMessageLoungeCount = 0;
    for (final ChatState chatState
        in state.chatsState.usersChatsStates[state.userState.user.id].values) {
      newMessageCount += chatState.countNewMessages();
    }
    for (final ChatState chatState
        in state.chatsState.loungesChatsStates[state.userState.user.id].values) {
      newMessageLoungeCount += chatState.countNewMessages();
    }
    return Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: BottomNavigationBar(
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: state.homePageIndex,
            items: bubbleBar(context, newMessageCount, newMessageLoungeCount, state.theme),
            onTap: (int index) async {
              if (index == state.homePageIndex) {
                return;
              }
              dispatch(AppNavigateAction(index));
              Navigator.of(context)
                  .popUntil((Route<dynamic> route) => route.isFirst);
            }));
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
                Widget w) =>
            AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.dark,
                child: Scaffold(body: _buildBody(state, dispatch))));
  }
}
