import 'package:flutter/material.dart';
import 'package:inclusive/classes/search_preferences.dart';
import 'package:inclusive/services/search.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/Search/search_interest.dart';
import 'package:provider/provider.dart';

class ProfileSettingsSearch extends StatefulWidget {
  @override
  _ProfileSettingsSearchState createState() => _ProfileSettingsSearchState();
}

class _ProfileSettingsSearchState extends State<ProfileSettingsSearch> {
  SearchPreferences searchPreferences;

  Future<void> _onSave(BuildContext context) async {
    final SearchService searchService = Provider.of(context);
    await searchService.setSearchPreferences(searchPreferences);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    searchPreferences = Provider.of(context);

    return ListView(padding: const EdgeInsets.all(20.0), children: <Widget>[
      Column(children: <Widget>[
        Row(children: <Widget>[
          Icon(Icons.category),
          Flexible(
              child: SearchInterest(
            onUpdate: (List<String> interests) =>
                searchPreferences.interests = interests,
            interests: searchPreferences.interests,
          ))
        ]),
        Row(children: <Widget>[
          Icon(Icons.cake),
          Flexible(
              child: RangeSlider(
                  labels: RangeLabels(
                    searchPreferences.ageRange.start.toInt().toString() + 'y',
                    searchPreferences.ageRange.end.toInt().toString() + 'y',
                  ),
                  min: 13,
                  max: 99,
                  activeColor: orange,
                  inactiveColor: blueLight,
                  values: searchPreferences.ageRange,
                  divisions: 87,
                  onChanged: (RangeValues values) {
                    // TODO(alex): onChangedEnd should be called instead and update when values are different
                    setState(() => searchPreferences.ageRange = values);
                  })),
        ]),
        Padding(
            padding: const EdgeInsets.all(20.0),
            child: RaisedButton(
                onPressed: () {
                  return _onSave(context);
                },
                child: const Text('Save')))
      ])
    ]);
  }
}
