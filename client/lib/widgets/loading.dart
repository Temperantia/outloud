import 'package:flutter/material.dart';

import 'package:outloud/theme.dart';

class Loading extends StatelessWidget {
  const Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(orangeLight),
            backgroundColor: orange));
  }
}
