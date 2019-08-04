import 'package:flutter/material.dart';
import 'package:inclusive/screens/Search/index.dart';
import 'package:inclusive/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inclusive/theme.dart';

bool notNull(Object o) => o != null;

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
              !_showHeader ? _noHeader() : null,
              SearchScreen(),
            ].where(notNull).toList(),
          ),
          Stack(
            children: [
              !_showHeader ? _noHeader() : null,
              SearchScreen(),
            ].where(notNull).toList(),
          ),
          Stack(
            children: [
              !_showHeader ? _noHeader() : null,
              SearchScreen(),
            ].where(notNull).toList(),
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
        appBar: _showHeader ? _header() : null,
        body: SafeArea(child: _body()),
      ),
    );
  }
}
