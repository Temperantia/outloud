import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';

class ProfileFacts extends StatefulWidget {
  const ProfileFacts(this.facts, {Key key}) : super(key: key);
  final List<String> facts;
  @override
  ProfileFactsState createState() =>
      ProfileFactsState(List<String>.from(facts));
}

class ProfileFactsState extends State<ProfileFacts>
    with SingleTickerProviderStateMixin {
  ProfileFactsState(this._facts);
  final List<String> _facts;

  final int _maxFacts = 10;
  final List<String> _hints = <String>[
    'I love pizza the most',
    'I prefer skiing that skating',
    'Dog over cat',
    'Scared of spiders',
    'Before I die I would like to travel at least 2/3 of the world',
    'Coffee over tea',
    'Travel is my 2nd nature',
    'Sometimes nerdy',
    'Morning shower',
    'Hate bread btw',
  ];
  final List<TextEditingController> _controllers = <TextEditingController>[];

  @override
  void initState() {
    super.initState();

    for (final String fact in _facts) {
      _addController(text: fact);
    }
    _addController();
  }

  @override
  void dispose() {
    super.dispose();

    for (final String _ in _facts) {
      _removeController();
    }
    _removeController();
  }

  List<String> onSave() {
    return _facts;
  }

  void _addController({String text = ''}) {
    _controllers.add(TextEditingController(text: text));
  }

  void _removeController() {
    _controllers.removeLast();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _facts.length + 1,
        itemBuilder: (BuildContext context, int index) =>
            Row(children: <Widget>[
              Flexible(
                child: TextField(
                    onChanged: (String value) {
                      setState(() {
                        if (value == '') {
                          _facts.removeAt(index);
                          _removeController();
                        }
                      });
                    },
                    controller: _controllers[index],
                    decoration: InputDecoration(
                        labelText: 'Your fact',
                        hintText: _hints[index],
                        focusColor: orange,
                        border: const OutlineInputBorder())),
              ),
              if (index == _facts.length &&
                  _facts.length < _maxFacts - 1 &&
                  _controllers[index].text != '')
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _facts.add(_controllers[index].text.trim());
                        _addController();
                      });
                    },
                    child: Icon(Icons.add)),
              if (index < _facts.length &&
                  (_facts[index] != _controllers[index].text))
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _facts[index] = _controllers[index].text;
                      });
                    },
                    child: Icon(Icons.edit)),
              if (index < _facts.length)
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _facts.removeAt(index);
                        _removeController();
                      });
                    },
                    child: Icon(Icons.close))
            ]));
  }
}
