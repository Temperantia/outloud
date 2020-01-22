import 'package:flutter/material.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/Profile/profile_description.dart';
import 'package:inclusive/widgets/Profile/profile_education.dart';
import 'package:inclusive/widgets/Profile/profile_facts.dart';
import 'package:inclusive/widgets/Profile/profile_home.dart';
import 'package:inclusive/widgets/Profile/profile_interests.dart';
import 'package:inclusive/widgets/Profile/profile_pictures.dart';
import 'package:inclusive/widgets/Profile/profile_profession.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:provider/provider.dart';

class ProfileInformationScreen extends StatefulWidget {
  static const String id = 'ProfileSettings';
  @override
  _ProfileInformationScreen createState() => _ProfileInformationScreen();
}

class _ProfileInformationScreen extends State<ProfileInformationScreen> {
  final GlobalKey<ProfilePicturesState> _pictures =
      GlobalKey<ProfilePicturesState>();
  final GlobalKey<ProfileHomeState> _home = GlobalKey<ProfileHomeState>();
  final GlobalKey<ProfileInterestsState> _interests =
      GlobalKey<ProfileInterestsState>();
  final GlobalKey<ProfileProfessionState> _profession =
      GlobalKey<ProfileProfessionState>();
  final GlobalKey<ProfileDescriptionState> _description =
      GlobalKey<ProfileDescriptionState>();
  final GlobalKey<ProfileEducationState> _education =
      GlobalKey<ProfileEducationState>();
  final GlobalKey<ProfileFactsState> _facts = GlobalKey<ProfileFactsState>();
  UserModel _userProvider;

  Future<void> _onSave(User user) async {
    if (_pictures.currentState != null) {
      user.pics = await _pictures.currentState.onSave(user.id);
    }

    if (_home.currentState != null) {
      user.home = _home.currentState.onSave();
    }

    if (_interests.currentState != null) {
      user.interests = _interests.currentState.onSave();
    }

    if (_profession.currentState != null) {
      user.profession = _profession.currentState.onSave();
    }

    if (_description.currentState != null) {
      user.description = _description.currentState.onSave();
    }

    if (_education.currentState != null) {
      user.education = _education.currentState.onSave();
    }

    if (_facts.currentState != null) {
      user.facts = _facts.currentState.onSave();
    }

    _userProvider.updateUser(user);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserModel>(context);
    final User user = Provider.of<User>(context);
    return View(
        child: ListView(children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ProfilePictures(user.pics, key: _pictures)),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: ProfileHome(user.home, key: _home)),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: ProfileInterests(user.interests, key: _interests)),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: ProfileProfession(user.profession, key: _profession)),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: ProfileDescription(user.description, key: _description)),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: ProfileEducation(user.education, key: _education)),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: ProfileFacts(user.facts, key: _facts)),
        ]),
        actions: <Widget>[
          GestureDetector(
              onTap: () => _onSave(user),
              child: Icon(Icons.check, color: white))
        ]);
  }
}
