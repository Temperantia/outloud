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

    for (final Interest _ in _interests) {
      _removeControllers();
    }
    _removeControllers();
  }

  List<Interest> onSave() {
    return _interests;
  }

  void _addControllers({String name = '', String comment = ''}) {
    _controllersLeft.add(TextEditingController(text: name));
    _controllersRight.add(TextEditingController(text: comment));
    final FocusNode focusLeft = FocusNode();
    focusLeft.addListener(() {
      setState(() {});
    });
    focusLeft.unfocus();
    _focusLeft.add(focusLeft);
    final FocusNode focusRight = FocusNode();
    focusRight.addListener(() {
      setState(() {});
    });
    focusRight.unfocus();
    _focusRight.add(focusRight);
  }

  void _removeControllers() {
    _controllersLeft.removeLast();
    _controllersRight.removeLast();
    _focusLeft.removeLast();
    _focusRight.removeLast();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _interests.length + 1,
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
                                _interests.removeAt(index);
                                _removeControllers();
                              }
                            });
                          },
                          focusNode: _focusLeft[index],
                          controller: _controllersLeft[index],
                          decoration: InputDecoration(
                              labelText: 'Your interest',
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
                      enabled: _controllersLeft[index].text != '',
                      onChanged: (String value) => setState(() {}),
                      focusNode: _focusRight[index],
                      controller: _controllersRight[index],
                      decoration: InputDecoration(
                          labelText: 'Say something about it',
                          focusColor: orange,
                          border: const OutlineInputBorder()))),
              if (index == _interests.length &&
                  _interests.length < maxInterests - 1 &&
                  _controllersLeft[index].text != '')
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _interests.add(Interest(
                            name: _controllersLeft[index].text.trim(),
                            comment: _controllersRight[index].text.trim()));
                        _addControllers();
                      });
                    },
                    child: Icon(Icons.add)),
              if (index < _interests.length &&
                  (_interests[index].name != _controllersLeft[index].text ||
                      _interests[index].comment !=
                          _controllersRight[index].text))
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _interests[index].name = _controllersLeft[index].text;
                        _interests[index].comment =
                            _controllersRight[index].text;
                      });
                    },
                    child: Icon(Icons.edit)),
              if (index < _interests.length)
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _interests.removeAt(index);
                        _removeControllers();
                      });
                    },
                    child: Icon(Icons.close))
            ]));
  }
}
