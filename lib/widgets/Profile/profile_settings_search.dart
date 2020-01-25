import 'package:flutter/material.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/services/app_data.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/Search/search_interest.dart';
import 'package:provider/provider.dart';

class ProfileSettingsSearch extends StatefulWidget {
  @override
  _ProfileSettingsSearchState createState() => _ProfileSettingsSearchState();
}

class _ProfileSettingsSearchState extends State<ProfileSettingsSearch> {
  Future<void> _onSave(BuildContext context) async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final AppDataService appDataService = Provider.of<AppDataService>(context);
    return ListView(padding: const EdgeInsets.all(20.0), children: <Widget>[
        Column(children: <Widget>[
          Row(children: <Widget>[
            Icon(Icons.category),
            Flexible(
                child: SearchInterest(
                    interests: _interests,
                    ))
          ]),
          Row(children: <Widget>[
            Icon(Icons.cake),
            Flexible(
                child: RangeSlider(
                    labels: RangeLabels(
                      _ages.start.toInt().toString() + 'y',
                      _ages.end.toInt().toString() + 'y',
                    ),
                    min: 13,
                    max: 99,
                    activeColor: orange,
                    inactiveColor: blueLight,
                    values: _ages,
                    divisions: 87,
                    onChanged: (RangeValues values) {
                      // TODO(alex): onChangedEnd should be called instead and update when values are different
                      setState(() => _ages = values);
                    })),
          ]),
      Padding(
          padding: const EdgeInsets.all(20.0),
          child: RaisedButton(
              onPressed: () {
                return _onSave(context);
              },
              child: const Text('Save')))
    ]);
  }
}
