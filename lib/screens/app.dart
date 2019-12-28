import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inclusive/models/userModel.dart';
import 'package:inclusive/screens/Messaging/index.dart';
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
  bool editProfile = false;
  AppData appDataProvider;
  UserModel userProvider;
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 5);
    tabController.addListener(() => setState(() => {}));

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
              'images/message.svg',
              color: white,
            ),
            SvgPicture.asset(
              'images/search.svg',
              color: white,
            ),
            SvgPicture.asset(
              'images/group.svg',
              color: white,
            ),
            SvgPicture.asset(
              'images/event.svg',
              color: white,
            ),
          ],
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
              editProfile
                  ? ProfileEditionScreen(appDataProvider.user, onSaveProfile)
                  : Profile(appDataProvider.user),
            MessagingScreen(),
            SearchScreen(),
            SearchScreen(),
            SearchScreen(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    appDataProvider = Provider.of<AppData>(context);
    userProvider = Provider.of<UserModel>(context);
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _header(),
        body: SafeArea(child: _body()),
      ),
    );
  }
}
