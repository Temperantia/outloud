import 'package:flutter/material.dart';

import 'package:inclusive/widgets/Profile/profile_settings_search.dart';
import 'package:inclusive/widgets/view.dart';

class ProfileSettingsSearchScreen extends StatelessWidget {
  static const String id = 'ProfileSettingsSearch';

  @override
  Widget build(BuildContext context) {
    return View(child: ProfileSettingsSearch());
  }
}
