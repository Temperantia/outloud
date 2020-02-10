import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/widgets/bubble_bar.dart';
import 'package:inclusive/widgets/background.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'Home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
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
      //_appDataService.currentPage = index;
      _tabController.animateTo(index);
    });
  }

  Widget _buildBody() {
    return Container(
        decoration: background,
        child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: const <Widget>[
              Center(child: Text('Coming soon')),
              Center(child: Text('Coming soon')),
              Center(child: Text('Coming soon')),
              Center(child: Text('Coming soon')),
              Center(child: Text('Coming soon')),
            ]));
  }

  @override
  Widget build(BuildContext context) {
    //_authService.refreshLocation();

    //_tabController.animateTo(_appDataService.currentPage);
    return Scaffold(
        /*floatingActionButton: SpeedDial(
            child: Icon(Icons.add, color: white),
            backgroundColor: orange,
            animatedIcon: AnimatedIcons.menu_close,
            foregroundColor: white,
            overlayOpacity: 0,
            children: _buildActions()),
            */
        //floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BubbleBottomBar(
            //fabLocation: BubbleBottomBarFabLocation.end,
            opacity: 1,
            currentIndex: 0,
            onTap: _onChangePage,
            items: bubbleBar(context, 0)),
        body: SafeArea(child: _buildBody()));
  }
}
