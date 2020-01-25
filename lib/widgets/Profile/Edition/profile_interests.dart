import 'package:flutter/material.dart';
import 'package:inclusive/classes/interest.dart';
import 'package:inclusive/theme.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class ProfileInterests extends StatefulWidget {
  const ProfileInterests(this.interests, {Key key}) : super(key: key);
  final List<Interest> interests;
  @override
  ProfileInterestsState createState() => ProfileInterestsState(interests);
}

class ProfileInterestsState extends State<ProfileInterests>
    with SingleTickerProviderStateMixin {
  ProfileInterestsState(this._interests);
  final List<Interest> _interests;

  final int maxInterests = 10;
  final List<Map<String, String>> data = <Map<String, String>>[
    <String, String>{'name': 'gay community'},
    <String, String>{'name': 'cookies'},
    <String, String>{'name': 'body painting'},
  ];
  final List<TextEditingController> _controllersLeft =
      <TextEditingController>[];
  final List<TextEditingController> _controllersRight =
      <TextEditingController>[];

  final List<FocusNode> _focusLeft = <FocusNode>[];
  final List<FocusNode> _focusRight = <FocusNode>[];

  @override
  void initState() {
    super.initState();

    for (final Interest interest in _interests) {
      _addControllers(name: interest.name, comment: interest.comment);
    }
    _addControllers();
  }

  @override
  void dispose() {
    super.dispose();

    for (int index = 0; index < _controllersLeft.length; index++) {
      _removeControllers();
    }
    _removeControllers();
  }

  List<Interest> onSave() {
    final List<Interest> interests = <Interest>[];
    String text;
    for (int index = 0; index < _controllersLeft.length; index++) {
      text = _controllersLeft[index].text.trim();
      if (text.isNotEmpty) {
        interests.add(Interest(
            name: text, comment: _controllersRight[index].text.trim()));
      }
    }

    return interests;
  }

  void _addControllers(
      {String name = '',
      String comment = '',
      int index = -1,
      bool focus = false}) {
    if (index == -1) {
      _controllersLeft.add(TextEditingController(text: name));
      _controllersRight.add(TextEditingController(text: comment));

      final FocusNode focusLeft = FocusNode();
      focusLeft.addListener(() {
        setState(() {});
      });
      _focusLeft.add(focusLeft);

      final FocusNode focusRight = FocusNode();
      focusRight.addListener(() {
        setState(() {});
      });
      _focusRight.add(focusRight);
    } else {
      _controllersLeft.insert(index, TextEditingController(text: name));
      _controllersRight.insert(index, TextEditingController(text: comment));

      final FocusNode focusLeft = FocusNode();
      focusLeft.addListener(() {
        setState(() {});
      });
      _focusLeft.insert(index, focusLeft);

      final FocusNode focusRight = FocusNode();
      focusRight.addListener(() {
        setState(() {});
      });
      _focusRight.insert(index, focusRight);
    }
  }

  void _removeControllers({int index = -1}) {
    if (index == -1) {
      _controllersLeft.removeLast();
      _controllersRight.removeLast();
      _focusLeft.removeLast();
      _focusRight.removeLast();
    } else {
      _controllersLeft.removeAt(index);
      _controllersRight.removeAt(index);
      _focusLeft.removeAt(index);
      _focusRight.removeAt(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(children: const <Widget>[
        Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Text('Your interests'))
      ]),
      ListView.builder(
          shrinkWrap: true,
          itemCount: _controllersLeft.length,
          itemBuilder: (BuildContext context, int index) =>
              Row(children: <Widget>[
                Flexible(
                    flex: _focusLeft[index].hasFocus ? 5 : 2,
                    child: TypeAheadField<Map<String, String>>(
                        autoFlipDirection: true,
                        textFieldConfiguration: TextFieldConfiguration<String>(
                            onChanged: (dynamic value) {
                              setState(() {
                                if (value == '') {
                                  _removeControllers(index: index);
                                }
                              });
                            },
                            controller: _controllersLeft[index],
                            decoration: InputDecoration(
                                focusColor: orange,
                                border: const OutlineInputBorder())),
                        suggestionsCallback: (String pattern) async {
                          return data
                              .where((Map<String, String> elem) =>
                                  elem['name'].startsWith(pattern))
                              .toList();
                        },
                        itemBuilder: (BuildContext context,
                            Map<String, String> suggestion) {
                          return ListTile(
                            leading: Icon(Icons.category),
                            title: Text(suggestion['name'],
                                style: const TextStyle(color: Colors.black)),
                          );
                        },
                        onSuggestionSelected: (Map<String, String> suggestion) {
                          setState(() {
                            _controllersLeft[index].text = suggestion['name'];
                            _focusRight[index].requestFocus();
                          });
                        })),
                Flexible(
                    flex: _focusRight[index].hasFocus ? 5 : 3,
                    child: TextField(
                        enabled: _controllersLeft[index].text.isNotEmpty,
                        onChanged: (String value) => setState(() {}),
                        focusNode: _focusRight[index],
                        controller: _controllersRight[index],
                        decoration: InputDecoration(
                            hintText: 'Say something about it',
                            focusColor: orange,
                            border: const OutlineInputBorder()))),
                if (_controllersLeft.length < maxInterests - 1 &&
                    _controllersLeft[index].text.isNotEmpty)
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _addControllers(index: index + 1, focus: true);
                        });
                      },
                      child: Icon(Icons.add)),
                if (index < _controllersLeft.length - 1)
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _removeControllers(index: index);
                        });
                      },
                      child: Icon(Icons.close))
              ]))
    ]);
  }
}
