import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inclusive/models/userModel.dart';
import 'package:inclusive/screens/Profile/profile-edition.dart';

import 'package:inclusive/screens/Search/index.dart';
import 'package:inclusive/appdata.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/screens/Profile/profile.dart';
import 'package:inclusive/widgets/background.dart';
import 'package:provider/provider.dart';

class AppScreen extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<AppScreen> with SingleTickerProviderStateMixin {
  bool _showHeader = false;
  bool editProfile = false;
  AppData appDataProvider;
  UserModel userProvider;
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3);
    tabController.addListener(() => setState(() => {}));
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void onSave(User user) {
    this.userProvider.updateUser(user, user.id);
    setState(() => editProfile = false);
  }

  Widget _header() {
    return AppBar(
      actions: [
        tabController.index == 0
            ? editProfile
                ? IconButton(
                    color: white,
                    icon: Icon(Icons.cancel),
                    onPressed: () => setState(() => editProfile = !editProfile))
                : IconButton(
                    color: white,
                    icon: Icon(Icons.edit),
                    onPressed: () => setState(() => editProfile = !editProfile))
            : Container(),
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
          controller: tabController,
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
      decoration: background,
      child: TabBarView(
        controller: tabController,
        children: [
          Stack(
            children: [
              editProfile
                  ? ProfileEditionScreen(appDataProvider.user, onSave)
                  : Profile(appDataProvider.user),
              !_showHeader ? _noHeader() : Container(),
            ],
          ),
          Stack(children: [
            SearchScreen(),
            !_showHeader ? _noHeader() : Container(),
          ]),
          Stack(children: [
            SearchScreen(),
            !_showHeader ? _noHeader() : Container(),
          ])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    appDataProvider = Provider.of<AppData>(context);
    userProvider = Provider.of<UserModel>(context);
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
