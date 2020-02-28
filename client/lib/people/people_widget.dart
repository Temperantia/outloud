import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';
import 'package:business/people/actions/people_get_action.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/widgets/circular_image.dart';
import 'package:inclusive/widgets/loading.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:business/people/models/people_state.dart';

import '../theme.dart';

class PeopleWidget extends StatefulWidget {
  @override
  _PeopleWidgetState createState() => _PeopleWidgetState();
}

class _PeopleWidgetState extends State<PeopleWidget>
    with AutomaticKeepAliveClientMixin<PeopleWidget> {
  @override
  bool get wantKeepAlive => true;

  Widget _buildPerson(User user, String distance) {
    return Container(
        decoration: BoxDecoration(
            gradient: gradient, borderRadius: BorderRadius.circular(10.0)),
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(children: <Widget>[
          CircularImage(
              imageUrl: user.pics.isEmpty ? null : user.pics[0],
              imageRadius: 50.0),
          Expanded(
              flex: 3,
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(user.name))),
          if (distance != null) Expanded(child: Text(distance)),
          Icon(Icons.add),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ReduxSelector<AppState, PeopleState>(
        selector: (BuildContext context, AppState state) => state.peopleState,
        builder: (BuildContext context,
            redux.Store<AppState> store,
            AppState state,
            void Function(redux.ReduxAction<AppState>) dispatch,
            PeopleState peopleState,
            Widget child) {
          final List<User> people = peopleState.people;
          final Map<String, String> distances = peopleState.distances;
          if (people == null || distances == null) {
            return Loading();
          }

          return RefreshIndicator(
              onRefresh: () => store.dispatchFuture(PeopleGetAction()),
              child: Container(
                  decoration: const BoxDecoration(color: white),
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('People', style: textStyleTitle(state.theme)),
                        Expanded(
                            child: ListView.builder(
                                itemCount: people.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        _buildPerson(people[index],
                                            distances[people[index].id]))),
                      ])));
        });
  }
}
