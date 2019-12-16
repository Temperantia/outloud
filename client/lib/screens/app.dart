import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:inclusive/screens/Search/index.dart';
import 'package:inclusive/screens/Search/results-solo.dart';
import 'package:inclusive/services/user.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/utils/common.dart';
import 'package:inclusive/widgets/background.dart';

class AppScreenArguments {
  final List<User> searchResults;

  AppScreenArguments({this.searchResults});
}

class AppScreen extends StatefulWidget {
  static const routeName = '/Application';

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<AppScreen> with SingleTickerProviderStateMixin {
  bool _showHeader = false;
  AppScreenArguments _arguments = AppScreenArguments();
  TabController _tabController;
  final List<Tab> _tabs = [
    Tab(
      child: SvgPicture.asset(
        'images/profile.svg',
        color: white,
      ),
    ),
    Tab(
      child: SvgPicture.asset(
        'images/search.svg',
        color: white,
      ),
    ),
    Tab(
      child: SvgPicture.asset(
        'images/message.svg',
        color: white,
      ),
    ),
  ];

  Widget _header() {
    return AppBar(
      actions: [
        GestureDetector(
          onTap: () {
            setState(() => _showHeader = !_showHeader);
          },
          child: SvgPicture.asset(
            'images/arrow_right.svg',
            color: blue,
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: TabBar(
          controller: _tabController,
          tabs: _tabs,
        ),
      ),
    );
  }

  Widget _noHeader() {
    return Positioned(
      child: GestureDetector(
        onTap: () {
          setState(() => _showHeader = !_showHeader);
        },
        child: SvgPicture.asset(
          'images/arrow_right.svg',
          color: blue,
        ),
      ),
    );
  }

  Widget _body() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: background,
      child: TabBarView(
        children: [
          Stack(
            children: [
              !_showHeader ? _noHeader() : emptyWidget,
              // SearchScreen(),
            ],
          ),
          Stack(
            children: [
              !_showHeader ? _noHeader() : emptyWidget,
              _arguments?.searchResults == null
                  ? SearchScreen()
                  : ResultsSoloScreen(_arguments.searchResults),
            ],
          ),
          Stack(
            children: [
              !_showHeader ? _noHeader() : emptyWidget,
              // SearchScreen(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //_tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context).settings.arguments;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: _showHeader ? _header() : null,
        body: SafeArea(child: _body()),
      ),
    );
  }
}
