import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/classes/search_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchService extends ChangeNotifier {
  Future<SearchPreferences> getSearchPreferences() async {
    final SearchPreferences searchPreferences = SearchPreferences();

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final double ageMin = sharedPreferences.getDouble('ageMin');
    final double ageMax = sharedPreferences.getDouble('ageMax');

    if (ageMin == null || ageMax == null) {
      searchPreferences.ageRange = const RangeValues(13, 99);
    } else {
      searchPreferences.ageRange = RangeValues(ageMin, ageMax);
    }

    final List<String> interests = sharedPreferences.getStringList('interests');
    searchPreferences.interests = interests ?? <String>[];

    return searchPreferences;
  }

  Future<void> setSearchPreferences(
      final SearchPreferences searchPreferences) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setDouble('ageMin', searchPreferences.ageRange.start);
    sharedPreferences.setDouble('ageMax', searchPreferences.ageRange.end);
    sharedPreferences.setStringList('interests', searchPreferences.interests);
  }
}
