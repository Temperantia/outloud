import 'package:flutter/material.dart';
//import 'package:flutter_calendar_carousel/classes/event.dart';
//import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

import 'package:inclusive/widgets/Search/search-interest.dart';
import 'package:inclusive/widgets/button-text.dart';

class SearchEvent extends StatefulWidget {
  @override
  SearchEventState createState() {
    return SearchEventState();
  }
}

class SearchEventState extends State<SearchEvent> {
  List interests = [];
  DateTime currentDate;
  String selectedPeriod = 'Anytime';
  String selectedCustomPeriod = '';
  List<String> periods = [
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
        children: [
          SearchInterest(
              onUpdate: (List interests) =>
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
                SnackBar(
                  content: const Text('Processing Data'),
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
    List<Widget> periodWidgets = [];

    if (selectedPeriod != 'custom') {
      for (String period in periods) {
        periodWidgets.add(SizedBox(height: 10.0));

        periodWidgets.add(ButtonText(
            width: 120.0,
            text: period,
            isSelected: () => selectedPeriod == period,
            onTap: () => setState(() => selectedPeriod = period)));
      }
    }
    periodWidgets.add(SizedBox(height: 10.0));

    periodWidgets.add(ButtonText(
        width: 120.0,
        text: 'Then when ?',
        isSelected: () => selectedPeriod == 'custom',
        onTap: () => setState(() => selectedPeriod = 'custom')));
    periodWidgets.add(SizedBox(height: 10.0));
    if (selectedPeriod == 'custom') {
      periodWidgets
          .add(Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ButtonText(
            width: 120.0,
            text: 'Start',
            isSelected: () => selectedCustomPeriod == 'start',
            onTap: () => setState(() => selectedCustomPeriod = 'start')),
        SizedBox(width: 10.0),
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
