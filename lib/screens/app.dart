import 'package:badges/badges.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:inclusive/models/userModel.dart';
import 'package:inclusive/screens/Messaging/index.dart';
import 'package:inclusive/screens/Profile/profile-edition.dart';

import 'package:inclusive/screens/Search/index.dart';
import 'package:inclusive/services/appdata.dart';
import 'package:inclusive/services/message.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/screens/Profile/profile.dart';
import 'package:inclusive/widgets/background.dart';
import 'package:provider/provider.dart';

class AppScreen extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<AppScreen> with SingleTickerProviderStateMixin {
  AppData appDataService;
  MessageService messageService;
  UserModel userProvider;
  TabController tabController;
  int currentPage = 0;
  bool editProfile = false;

  final GlobalKey<MessagingState> messaging = GlobalKey<MessagingState>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 5);

    // testing purpose
    tabController.animateTo(1);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void onSaveProfile(User user) {
    userProvider.updateUser(user, user.id);
    setState(() => editProfile = false);
  }

  Widget _body() {
    return Container(
      decoration: background,
      child: TabBarView(
        controller: tabController,
        children: [
          editProfile
              ? ProfileEditionScreen(appDataService.user, onSaveProfile)
              : Profile(appDataService.user),
          MessagingScreen(key: messaging),
          SearchScreen(),
          SearchScreen(),
          SearchScreen(),
        ],
      ),
    );
  }

  void onChangePage(final int index) {
    setState(() {
      currentPage = index;
      tabController.animateTo(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    appDataService = Provider.of<AppData>(context);
    messageService = Provider.of<MessageService>(context);
    userProvider = Provider.of<UserModel>(context);

    return StreamBuilder(
        stream: messageService.streamAll(),
        builder: (BuildContext context, AsyncSnapshot stream) {
          if (stream.connectionState == ConnectionState.waiting)
          return Container();
          print(stream.data);
          return Scaffold(
              resizeToAvoidBottomInset: true,
              floatingActionButton: SpeedDial(
                  child: Icon(Icons.add, color: white),
                  backgroundColor: orange,
                  animatedIcon: AnimatedIcons.menu_close,
                  foregroundColor: white,
                  overlayOpacity: 0,
                  children: buildActions()),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endDocked,
              bottomNavigationBar: BubbleBottomBar(
                  fabLocation: BubbleBottomBarFabLocation.end,
                  opacity: 1,
                  currentIndex: currentPage,
                  onTap: onChangePage,
                  hasInk: true,
                  items: [
                    BubbleBottomBarItem(
                        icon: Icon(Icons.person, color: orange),
                        activeIcon: Icon(Icons.person, color: white),
                        backgroundColor: orange,
                        title: Text('Me',
                            style: TextStyle(color: white, fontSize: 14.0))),
                    BubbleBottomBarItem(
                        icon: messageService.pings > 0
                            ? Badge(
                                badgeColor: orange,
                                badgeContent: Text(
                                    messageService.pings.toString(),
                                    style: Theme.of(context).textTheme.caption),
                                child: Icon(Icons.message, color: orange))
                            : Icon(Icons.message, color: orange),
                        activeIcon: Icon(Icons.message, color: white),
                        backgroundColor: orange,
                        title: Text('Message',
                            style: TextStyle(color: white, fontSize: 14.0))),
                    BubbleBottomBarItem(
                        icon: Icon(Icons.search, color: orange),
                        activeIcon: Icon(Icons.search, color: white),
                        backgroundColor: orange,
                        title: Text('Search',
                            style: TextStyle(color: white, fontSize: 14.0))),
                    BubbleBottomBarItem(
                        icon: Icon(Icons.people, color: orange),
                        activeIcon: Icon(Icons.people, color: white),
                        backgroundColor: orange,
                        title: Text('Group',
                            style: TextStyle(color: white, fontSize: 14.0))),
                    BubbleBottomBarItem(
                        icon: Icon(Icons.event, color: orange),
                        activeIcon: Icon(Icons.event, color: white),
                        backgroundColor: orange,
                        title: Text('Event',
                            style: TextStyle(color: white, fontSize: 14.0))),
                  ]),
              body: SafeArea(child: _body()));
        });
  }

  List<SpeedDialChild> buildActions() {
    final List<SpeedDialChild> actions = [];

    if (tabController.index == 0) {
      actions.add(SpeedDialChild(
          backgroundColor: orange,
          child: Icon(editProfile ? Icons.cancel : Icons.edit, color: white),
          onTap: () => setState(() => editProfile = !editProfile)));
    } else if (tabController.index == 1) {
      actions.add(SpeedDialChild(
          backgroundColor: orange,
          child: Icon(Icons.close, color: white),
          onTap: () => messaging.currentState.onCloseConversation()));
    }
    return actions;
  }
}
