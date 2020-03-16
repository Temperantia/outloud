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

class ProfileEditionScreen extends StatefulWidget {
  static const String id = 'ProfileEditionScreen';

  @override
  _ProfileEditionScreenState createState() => _ProfileEditionScreenState();
}

class _ProfileEditionScreenState extends State<ProfileEditionScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController home = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController pronoun = TextEditingController();
  TextEditingController orientation = TextEditingController();
  TextEditingController education = TextEditingController();
  TextEditingController occupation = TextEditingController();
  GlobalKey<ProfileInterestsState> prokey = GlobalKey<ProfileInterestsState>();

  @override
  void dispose() {
    // TODO(me): dispose time
    super.dispose();
  }

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
              controller: name,
              decoration: const InputDecoration(labelText: 'Name')),
          TextField(
              controller: home,
              decoration: const InputDecoration(labelText: 'Home')),
          TextField(
              controller: gender,
              decoration: const InputDecoration(labelText: 'Gender')),
          TextField(
              controller: pronoun,
              decoration: const InputDecoration(labelText: 'Pronoun')),
          TextField(
              controller: orientation,
              decoration:
                  const InputDecoration(labelText: 'Sexual orientation')),
          TextField(
              controller: education,
              decoration: const InputDecoration(labelText: 'Education')),
          TextField(
              controller: occupation,
              decoration: const InputDecoration(labelText: 'Occupation')),
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
