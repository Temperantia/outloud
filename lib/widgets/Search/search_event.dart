import 'package:flutter/material.dart';
//import 'package:flutter_calendar_carousel/classes/event.dart';
//import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

import 'package:inclusive/widgets/Search/search_interest.dart';
import 'package:inclusive/widgets/button_text.dart';

class SearchEvent extends StatefulWidget {
  @override
  SearchEventState createState() {
    return SearchEventState();
  }
}

class SearchEventState extends State<SearchEvent> {
  List<dynamic> interests = <dynamic>[];
  DateTime currentDate;
  String selectedPeriod = 'Anytime';
  String selectedCustomPeriod = '';
  List<String> periods = <String>[
    'Anytime',
    'Today',
    'Tomorrow',
    'This week',
    'This week end',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SearchInterest(
              onUpdate: (List<dynamic> interests) =>
                  setState(() => this.interests = interests)),
          /*
          buildPeriods(),
          CalendarCarousel(
            minSelectedDate: DateTime.now(),
            firstDayOfWeek: 1,
            height: 400.0,
            onDayPressed: (DateTime date, List<Event> events) {
              this.setState(() => currentDate = date);
            },
            selectedDateTime: currentDate,
          ),
          */
          RaisedButton(
            onPressed: () {
              Scaffold.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Processing Data'),
                ),
              );
            },
            child: Text(
              'Look for fun',
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPeriods() {
    final List<Widget> periodWidgets = <Widget>[];

    if (selectedPeriod != 'custom') {
      for (final String period in periods) {
        periodWidgets.add(const SizedBox(height: 10.0));

        periodWidgets.add(ButtonText(
            width: 120.0,
            text: period,
            isSelected: () => selectedPeriod == period,
            onTap: () => setState(() => selectedPeriod = period)));
      }
    }
    periodWidgets.add(const SizedBox(height: 10.0));

    periodWidgets.add(ButtonText(
        width: 120.0,
        text: 'Then when ?',
        isSelected: () => selectedPeriod == 'custom',
        onTap: () => setState(() => selectedPeriod = 'custom')));
    periodWidgets.add(const SizedBox(height: 10.0));
    if (selectedPeriod == 'custom') {
      periodWidgets.add(
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        ButtonText(
            width: 120.0,
            text: 'Start',
            isSelected: () => selectedCustomPeriod == 'start',
            onTap: () => setState(() => selectedCustomPeriod = 'start')),
        const SizedBox(width: 10.0),
        ButtonText(
            width: 120.0,
            text: 'End',
            isSelected: () => selectedCustomPeriod == 'end',
            onTap: () => setState(() => selectedCustomPeriod = 'end'))
      ]));
    }
    return Column(children: periodWidgets);
  }
}
