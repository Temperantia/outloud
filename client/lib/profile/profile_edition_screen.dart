import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/user.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/profile/profile_edition_interests.dart';
import 'package:inclusive/widgets/button.dart';
import 'package:inclusive/widgets/loading.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class ProfileEditionScreen extends StatelessWidget {
  static const String id = 'ProfileEditionScreen';

  var name = TextEditingController();
  var home = TextEditingController();
  var gender = TextEditingController();
  var pronoun = TextEditingController();
  var orientation = TextEditingController();
  var education = TextEditingController();
  var occupation = TextEditingController();
  GlobalKey<ProfileInterestsState> prokey = GlobalKey<ProfileInterestsState>();

  Future<void> onSave(User user) async {
    user.name = name.text;
    user.home = home.text;
    user.gender = gender.text;
    user.pronoun = pronoun.text;
    user.orientation = orientation.text;
    user.education = education.text;
    user.profession = occupation.text;
    user.interests = prokey.currentState.onSave();
    updateUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<AppState>) dispatch,
        Widget child) {
      final User user = state.userState.user;
      if (user == null) {
        return Loading();
      }
      name.text = user.name;
      home.text = user.home;
      gender.text = user.gender;
      pronoun.text = user.pronoun;
      orientation.text = user.orientation;
      education.text = user.education;
      occupation.text = user.profession;
      return View(
          child: ListView(
        children: <Widget>[
          TextField(
              controller: name, decoration: InputDecoration(labelText: 'Name')),
          TextField(
              controller: home, decoration: InputDecoration(labelText: 'Home')),
          TextField(
              controller: gender,
              decoration: InputDecoration(labelText: 'Gender')),
          TextField(
              controller: pronoun,
              decoration: InputDecoration(labelText: 'Pronoun')),
          TextField(
              controller: orientation,
              decoration: InputDecoration(labelText: 'Sexual orientation')),
          TextField(
              controller: education,
              decoration: InputDecoration(labelText: 'Education')),
          TextField(
              controller: occupation,
              decoration: InputDecoration(labelText: 'Occupation')),
          ProfileInterests(user.interests, key: prokey),
          Button(
            text: 'Update',
            onPressed: () {
              onSave(user);
              dispatch(redux.NavigateAction<AppState>.pop());
            },
          )
        ],
      ));
    });
  }
}
