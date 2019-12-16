import 'package:flutter/material.dart';

import 'package:inclusive/services/user.dart';

class ResultsSoloScreen extends StatelessWidget {
  final List<User> searchResults;

  ResultsSoloScreen(this.searchResults);

  List<Widget> _results() {
    List<Widget> results = [];
    searchResults.forEach((User result) {
      results.add(
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                leading: Icon(Icons.album),
                title: Text('The Enchanted Nightingale'),
                subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
              ),
              ButtonTheme.bar(
                // make buttons use the appropriate styles for cards
                child: ButtonBar(
                  children: [
                    FlatButton(
                      child: const Text('BUY TICKETS'),
                      onPressed: () {/* ... */},
                    ),
                    FlatButton(
                      child: const Text('LISTEN'),
                      onPressed: () {/* ... */},
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: _results(),
      ),
    );
  }
}
