import 'package:flutter/material.dart';

import 'package:inclusive/widgets/Profile/profile_settings.dart';
import 'package:inclusive/widgets/view.dart';

class ProfileSettingsScreen extends StatelessWidget {
  static const String id = 'ProfileSettings';

  @override
  Widget build(BuildContext context) {
    return View(child: ProfileSettings());
  }
}
