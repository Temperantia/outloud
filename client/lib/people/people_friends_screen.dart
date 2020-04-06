import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:outloud/people/people_search_screen.dart';
import 'package:outloud/profile/profile_screen.dart';
import 'package:outloud/widgets/button.dart';
import 'package:outloud/widgets/cached_image.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

import '../theme.dart';

class PeopleFriendsScreen extends StatefulWidget {
  @override
  _PeopleFriendsScreenState createState() => _PeopleFriendsScreenState();
}

class _PeopleFriendsScreenState extends State<PeopleFriendsScreen>
    with AutomaticKeepAliveClientMixin<PeopleFriendsScreen> {
  @override
  bool get wantKeepAlive => true;

  Widget _buildPerson(User user, ThemeStyle theme,
      void Function(redux.ReduxAction<AppState>) dispatch) {
    return GestureDetector(
        onTap: () => dispatch(redux.NavigateAction<AppState>.pushNamed(
            ProfileScreen.id,
            arguments: <String, dynamic>{'user': user, 'isEdition': false})),
        child: Container(
            decoration: BoxDecoration(
                color: primary(theme),
                borderRadius: BorderRadius.circular(10.0)),
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(children: <Widget>[
              CachedImage(user.pics.isEmpty ? null : user.pics[0],
                  width: 50.0,
                  height: 50.0,
                  borderRadius: BorderRadius.circular(20.0),
                  imageType: ImageType.User),
              Expanded(
                  flex: 3,
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(user.name))),
            ])));
  }

  Widget _buildFriends(List<User> friends, ThemeStyle theme,
      void Function(redux.ReduxAction<AppState>) dispatch) {
    return Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: <Widget>[
          Expanded(
              flex: 5,
              child: ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (BuildContext context, int index) =>
                      _buildPerson(friends[index], theme, dispatch))),
          Expanded(
              child: Button(
                  text: 'Find moOOOOOre',
                  onPressed: () => dispatch(
                      redux.NavigateAction<AppState>.pushNamed(
                          PeopleSearchScreen.id)))),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<dynamic>) dispatch,
        Widget child) {
      return Container(
          child: _buildFriends(state.userState.friends, state.theme, dispatch));
    });
  }
}
