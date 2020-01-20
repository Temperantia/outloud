import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:inclusive/classes/user.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:inclusive/theme.dart';

class ProfileHome extends StatefulWidget {
  const ProfileHome(this.user);
  final User user;
  @override
  _ProfileHome createState() => _ProfileHome();
}

class _ProfileHome extends State<ProfileHome> {
  final TextEditingController _editHome = TextEditingController();

  Future<void> _handlePressButton() async {
    final Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: 'AIzaSyBEjChmTft7RemEfCXSVf-1Xwx83YKYSKE',
      onError: onError,
      mode: Mode.overlay,
      types: <String>['(cities)'],
    );
    if (p != null) {
      _editHome.text = p.description;
      Navigator.pop(context);
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    print(response.errorMessage);
  }

  Widget _buildAlertDialog() {
    return AlertDialog(
        content: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          onPressed: _handlePressButton,
          child: const Text('Search city'),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          labelText: 'Select your home',
          focusColor: orange,
          border: const OutlineInputBorder()),
      onTap: () => showDialog<AlertDialog>(
          context: context,
          builder: (BuildContext context) => _buildAlertDialog()),
      readOnly: true,
      controller: _editHome,
    );
  }
}
