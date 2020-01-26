import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:inclusive/widgets/Groups/groups.dart';
import 'package:inclusive/widgets/Profile/profile_parent.dart';
import 'package:provider/provider.dart';

import 'package:inclusive/services/app_data.dart';
import 'package:inclusive/widgets/bubble_bar.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/widgets/Messaging/messaging.dart';
import 'package:inclusive/widgets/Search/search.dart';
import 'package:inclusive/services/message.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/background.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'Home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  AppDataService _appDataService;
  MessageService _messageService;

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(vsync: this, length: 5);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        _appDataService.refreshLocation();
        break;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onChangePage(int index) {
    setState(() {
      _appDataService.currentPage = index;
      _tabController.animateTo(index);
    });
  }

  Widget _buildBody() {
    final User user = Provider.of(context);

    return Container(
        decoration: background,
        child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: <Widget>[
              ProfileParent(user),
              const Messaging(),
              Search(onCreateUserConversation: _onChangePage),
              Groups(),
              const Center(child: Text('Coming soon')),
            ]));
  }

  List<SpeedDialChild> _buildActions() {
    final List<SpeedDialChild> actions = <SpeedDialChild>[];

    return actions;
  }

  @override
  Widget build(BuildContext context) {
    _messageService = Provider.of(context);
    _appDataService = Provider.of(context);

    _appDataService.refreshLocation();

    _tabController.animateTo(_appDataService.currentPage);
    return Scaffold(
        floatingActionButton: SpeedDial(
            child: Icon(Icons.add, color: white),
            backgroundColor: orange,
            animatedIcon: AnimatedIcons.menu_close,
            foregroundColor: white,
            overlayOpacity: 0,
            children: _buildActions()),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BubbleBottomBar(
            fabLocation: BubbleBottomBarFabLocation.end,
            opacity: 1,
            currentIndex: _appDataService.currentPage,
            onTap: _onChangePage,
            items: bubbleBar(context, _messageService.pings)),
        body: SafeArea(child: _buildBody()));
  }
}
