import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import 'package:inclusive/widgets/Profile/profile.dart';
import 'package:inclusive/services/app_data.dart';
import 'package:inclusive/widgets/bubble_bar.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/widgets/Messaging/messaging.dart';
import 'package:inclusive/widgets/Profile/profile_edition.dart';
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
  UserModel _userProvider;

  TabController _tabController;
  bool _editProfile = false;

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

  void _onSaveProfile(User user) {
    _userProvider.updateUser(user);
    setState(() => _editProfile = false);
  }

  void _onChangePage(int index) {
    setState(() {
      _appDataService.currentPage = index;
      _tabController.animateTo(index);
    });
  }

  Widget _buildBody() {
    final User user = Provider.of<User>(context);

    return Container(
        decoration: background,
        child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: <Widget>[
              if (_editProfile)
                ProfileEdition(user, _onSaveProfile)
              else
                Profile(user),
              const Messaging(),
              Search(onCreateUserConversation: _onChangePage),
              const Center(child: Text('Coming soon')),
              const Center(child: Text('Coming soon')),
            ]));
  }

  List<SpeedDialChild> _buildActions() {
    final List<SpeedDialChild> actions = <SpeedDialChild>[];

    if (_appDataService.currentPage == 0) {
      actions.add(SpeedDialChild(
          backgroundColor: orange,
          child: Icon(_editProfile ? Icons.cancel : Icons.edit, color: white),
          onTap: () => setState(() => _editProfile = !_editProfile)));
    }
    return actions;
  }

  @override
  Widget build(BuildContext context) {
    _messageService = Provider.of<MessageService>(context);
    _userProvider = Provider.of<UserModel>(context);
    _appDataService = Provider.of<AppDataService>(context);

    _appDataService.refreshLocation();

    _tabController.animateTo(_appDataService.currentPage);
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
