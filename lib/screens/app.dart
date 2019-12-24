import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:inclusive/screens/Search/index.dart';
import 'package:inclusive/screens/appdata.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/screens/Profile/profile.dart';
import 'package:inclusive/widgets/background.dart';

class AppScreen extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<AppScreen> {
  bool _showHeader = false;

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
          tabs: [
            SvgPicture.asset(
              'images/profile.svg',
              color: white,
            ),
            SvgPicture.asset(
              'images/search.svg',
              color: white,
            ),
            SvgPicture.asset(
              'images/message.svg',
              color: white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _noHeader() {
    return Positioned(
      top: 10.0,
      left: 10.0,
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
              Profile(appData.identifier),
              !_showHeader ? _noHeader() : Container(),
            ],
          ),
          Stack(
            children: [SearchScreen(), !_showHeader ? _noHeader() : Container(), ]
          ),
          Stack(
            children: [
              SearchScreen(),
              !_showHeader ? _noHeader() : Container(),
            ]
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
