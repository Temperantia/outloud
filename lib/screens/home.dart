import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:inclusive/services/app_data.dart';
import 'package:inclusive/widgets/bubble_bar.dart';
import 'package:provider/provider.dart';

import 'package:inclusive/classes/user.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/screens/Messaging/messaging.dart';
import 'package:inclusive/screens/Profile/profile_edition.dart';
import 'package:inclusive/screens/Search/index.dart';
import 'package:inclusive/services/message.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/screens/Profile/profile.dart';
import 'package:inclusive/widgets/background.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'Home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<MessagingState> messaging = GlobalKey<MessagingState>();

  AppDataService appDataService;
  MessageService messageService;
  UserModel userProvider;
  User user;

  TabController tabController;
  bool editProfile = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 5);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void onSaveProfile(User user) {
    userProvider.updateUser(user);
    setState(() => editProfile = false);
  }

  Widget _body() {
    return Container(
        decoration: background,
        child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: tabController,
            children: <Widget>[
              if (editProfile)
                ProfileEditionScreen(user, onSaveProfile)
              else
                Profile(user),
              MessagingScreen(key: messaging),
              SearchScreen(),
              const Center(child: Text('Coming soon')),
              const Center(child: Text('Coming soon')),
            ]));
  }

  void onChangePage(final int index) {
    setState(() {
      appDataService.currentPage = index;
      tabController.animateTo(index);
    });
  }

  List<SpeedDialChild> buildActions() {
    final List<SpeedDialChild> actions = <SpeedDialChild>[];

    if (appDataService.currentPage == 0) {
      actions.add(SpeedDialChild(
          backgroundColor: orange,
          child: Icon(editProfile ? Icons.cancel : Icons.edit, color: white),
          onTap: () => setState(() => editProfile = !editProfile)));
    } else if (appDataService.currentPage == 1) {
      actions.add(SpeedDialChild(
          backgroundColor: orange,
          child: Icon(Icons.close, color: white),
          onTap: () => messaging.currentState.onCloseConversation()));
    }
    return actions;
  }

  @override
  Widget build(BuildContext context) {
    messageService = Provider.of<MessageService>(context);
    userProvider = Provider.of<UserModel>(context);
    appDataService = Provider.of<AppDataService>(context);

    user = Provider.of<User>(context);

    tabController.animateTo(appDataService.currentPage);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: SpeedDial(
            child: Icon(Icons.add, color: white),
            backgroundColor: orange,
            animatedIcon: AnimatedIcons.menu_close,
            foregroundColor: white,
            overlayOpacity: 0,
            children: buildActions()),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BubbleBottomBar(
            fabLocation: BubbleBottomBarFabLocation.end,
            opacity: 1,
            currentIndex: appDataService.currentPage,
            onTap: onChangePage,
            items: bubbleBar(context, messageService.pings)),
        body: SafeArea(child: _body()));
  }
}
