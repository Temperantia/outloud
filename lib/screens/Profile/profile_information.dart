import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/services/app_data.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/Profile/profile_home.dart';
import 'package:inclusive/widgets/Profile/profile_interests.dart';
import 'package:inclusive/widgets/Profile/profile_pictures.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:provider/provider.dart';

class ProfileInformationScreen extends StatefulWidget {
  static const String id = 'ProfileSettings';
  @override
  _ProfileInformationScreen createState() => _ProfileInformationScreen();
}

class _ProfileInformationScreen extends State<ProfileInformationScreen> {
  final GlobalKey<ProfilePicturesState> settingsPictures =
      GlobalKey<ProfilePicturesState>();
  AppDataService _appDataService;
  UserModel _userProvider;

  Future<void> _onSave(User user) async {
    for (final String pictureToDelete
        in settingsPictures.currentState.picturesToDelete) {
      _appDataService.deleteImage(pictureToDelete, user.id);
    }
    List<dynamic> pictures = settingsPictures.currentState.pictures;
    pictures = await Future.wait<dynamic>(pictures.map((dynamic picture) async {
      if (picture is Uint8List) {
        return await _appDataService.saveImage(picture, user.id);
      } else {
        return picture;
      }
    }).toList());
    user.pics = pictures.cast<String>();
    _userProvider.updateUser(user);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    _appDataService = Provider.of<AppDataService>(context);
    _userProvider = Provider.of<UserModel>(context);
    final User initialUser = Provider.of<User>(context);
    final User user = User.fromMap(initialUser.toJson(), initialUser.id);
    return View(
        child: ListView(children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ProfilePictures(user, key: settingsPictures)),
          Padding(
              padding: const EdgeInsets.all(20.0), child: ProfileHome(user)),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: ProfileInterests(user)),
        ]),
        actions: <Widget>[
          GestureDetector(
              onTap: () => _onSave(user),
              child: Icon(Icons.check, color: white))
        ]);
  }
}
