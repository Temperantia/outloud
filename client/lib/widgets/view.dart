import 'package:async_redux/async_redux.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
      this.backIcon = Icons.keyboard_backspace,
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
  void Function(ReduxAction<AppState>) _dispatch;
  bool _showUserSettings = false;

  Widget _buildBody() {
    return widget.buttons == null
        ? widget.child
        : Column(children: <Widget>[
            Expanded(child: widget.child),
            Container(
                padding: const EdgeInsets.only(top: 10.0),
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: <Color>[pinkLight, pink])),
                child: widget.buttons)
          ]);
  }

  Widget _buildUserSettings(User user) {
    return Container(
        width: 300.0,
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/userMenuBG.png'), fit: BoxFit.cover)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
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
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                            onTap: () =>
                                setState(() => _showUserSettings = false),
                            child: Icon(Icons.close, color: white)))
                  ]),
              Row(children: <Widget>[
                AutoSizeText(user.name, style: const TextStyle(color: white))
              ]),
              GestureDetector(
                  onTap: () {
                    _dispatch(NavigateAction<AppState>.pushNamed(
                        ProfileScreen.id,
                        arguments: <String, dynamic>{'user': user}));
                    setState(() => _showUserSettings = false);
                  },
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(children: <Widget>[
                        Image.asset('images/iconView.png',
                            width: 20.0, height: 20.0, color: white),
                        Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: AutoSizeText(
                                FlutterI18n.translate(
                                    context, 'MENU_USER.OPTION_1'),
                                style: const TextStyle(color: white)))
                      ]))),
              GestureDetector(
                  onTap: () {
                    _dispatch(NavigateAction<AppState>.pushNamed(
                        ProfileScreen.id,
                        arguments: <String, dynamic>{
                          'user': user,
                          'isEdition': true
                        }));
                    setState(() => _showUserSettings = false);
                  },
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(children: <Widget>[
                        Image.asset('images/iconEdit.png',
                            width: 20.0, height: 20.0, color: white),
                        Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: AutoSizeText(
                                FlutterI18n.translate(
                                    context, 'MENU_USER.OPTION_2'),
                                style: const TextStyle(color: white))),
                      ]))),
              const Divider(color: white),
              GestureDetector(
                  onTap: () {
                    /*  if (Navigator.of(context).canPop())
                  Navigator.of(context).popUntil(
                      (Route<dynamic> route) => route.settings.name == 'Home'); */
                    _dispatch(AppDisconnectAction());
                    setState(() => _showUserSettings = false);
                  },
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(children: <Widget>[
                        Image.asset('images/iconLeave.png',
                            width: 20.0, height: 20.0, color: white),
                        Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: AutoSizeText(
                                FlutterI18n.translate(
                                    context, 'MENU_USER.OPTION_3'),
                                style: const TextStyle(color: white))),
                      ])))
            ]));
  }

  PreferredSize _buildAppBar(User user) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: widget.isProfileScreen
            ? AppBar(
                elevation: 0.0,
                leading: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                        onTap: widget.onBack ??
                            () => _dispatch(NavigateAction<AppState>.pop()),
                        child: Icon(widget.backIcon, color: white))),
                flexibleSpace:
                    Image.asset('images/screenTop.png', fit: BoxFit.cover),
                backgroundColor: Colors.transparent)
            : AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: user == null
                        ? const CircularProgressIndicator()
                        : GestureDetector(
                            onTap: () => setState(
                                () => _showUserSettings = !_showUserSettings),
                            child: CachedImage(
                                user.pics.isEmpty ? null : user.pics[0],
                                borderRadius: BorderRadius.circular(60.0),
                                imageType: ImageType.User))),
                centerTitle: true,
                title: Stack(alignment: Alignment.center, children: <Widget>[
                  if (widget.title is String)
                    AutoSizeText(widget.title as String,
                        style: const TextStyle(color: white, fontSize: 14.0))
                  else
                    widget.title is TabBar
                        ? widget.title as TabBar
                        : Container(width: 0.0, height: 0.0),
                  if (Navigator.canPop(context))
                    Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                            onTap: widget.onBack ??
                                () => _dispatch(NavigateAction<AppState>.pop()),
                            child: Icon(widget.backIcon, color: white)))
                ]),
                titleSpacing: 0.0,
                actions: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8.0),

                    //child: Image.asset('images/hamburger.png',     width: 40.0, height: 40.0)
                  )
                ],
                flexibleSpace:
                    Image.asset('images/screenTop.png', fit: BoxFit.cover)));
  }

  Widget _buildNavBar(
      Map<String, ChatState> userChatStates,
      Map<String, ChatState> loungeChatStates,
      int homePageIndex,
      ThemeStyle themeStyle) {
    int newMessageCount = 0;
    int newMessageLoungeCount = 0;
    if (userChatStates != null) {
      for (final ChatState chatState in userChatStates.values) {
        newMessageCount += chatState.countNewMessages();
      }
    }

    if (loungeChatStates != null) {
      for (final ChatState chatState in loungeChatStates.values) {
        newMessageLoungeCount += chatState.countNewMessages();
      }
    }

    return GradientBottomNavigationBar(
        backgroundColorStart: pinkLight,
        backgroundColorEnd: pink,
        type: BottomNavigationBarType.fixed,
        currentIndex: homePageIndex,
        items: bubbleBar(
            context, newMessageCount, newMessageLoungeCount, themeStyle),
        onTap: (int index) async {
          if (index == homePageIndex) {
            return;
          }

          _dispatch(AppNavigateAction(index));
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
            void Function(ReduxAction<AppState>) dispatch,
            dynamic model,
            Widget w) {
          _dispatch = dispatch;
          final User user = state.userState.user;
          Map<String, ChatState> userChatStates;
          Map<String, ChatState> loungeChatStates;
          if (user != null) {
            final String userId = user.id;
            userChatStates = state.chatsState.usersChatsStates[userId];
            loungeChatStates = state.chatsState.loungesChatsStates[userId];
          }
          return DefaultTabController(
              length: 2,
              child: Stack(children: <Widget>[
                Scaffold(
                    appBar: widget.showAppBar ? _buildAppBar(user) : null,
                    bottomNavigationBar: widget.showNavBar
                        ? _buildNavBar(userChatStates, loungeChatStates,
                            state.homePageIndex, state.theme)
                        : Container(
                            width: 0.0,
                            height: 0.0,
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    colors: <Color>[pinkLight, pink]))),
                    body: SafeArea(child: _buildBody())),
                if (_showUserSettings)
                  SafeArea(child: Material(child: _buildUserSettings(user)))
              ]));
        });
  }
}
