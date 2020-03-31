import 'dart:typed_data';

import 'package:async_redux/async_redux.dart';
import 'package:business/actions/app_navigate_action.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/interest.dart';
import 'package:business/classes/user.dart';
import 'package:business/events/actions/events_get_action.dart';
import 'package:business/models/user.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/bubble_bar.dart';
import 'package:inclusive/widgets/button.dart';
import 'package:inclusive/widgets/cached_image.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

// TODO(alexandre): deletion of pictures when removing
// TODO(alexandre): popup to choose what to do with slots
class ProfileScreen extends StatefulWidget {
  const ProfileScreen(this.user, this.isEdition);

  final User user;
  final bool isEdition;

  static const String id = 'Profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User _user;
  bool _isEdition;
  Map<String, List<dynamic>> _controllers;
  final TextEditingController _interestController = TextEditingController();
  final List<Map<String, String>> _interestSuggestions = <Map<String, String>>[
    <String, String>{'name': 'Gay Community'},
    <String, String>{'name': 'Cookies'},
    <String, String>{'name': 'Body Painting'},
  ];
  final List<dynamic> _pictures = <dynamic>[];

  @override
  void initState() {
    super.initState();
    _user = User.fromMap(widget.user.toJson(), widget.user.id);
    _isEdition = widget.isEdition;
    _controllers = <String, List<dynamic>>{
      'LOCATION': <TextEditingController>[
        TextEditingController()..text = _user.home
      ],
      'GENDER': <dynamic>[
        _user.gender,
        <String>[
          'Male',
          'Two',
          'Free',
          'Four'
        ] // TODO(alexandre): list of genders
      ],
      'PRONOUNS': <dynamic>[
        _user.pronoun, // TODO(alexandre): text editing controller
        <String>['He/Him', 'Two', 'Free', 'Four']
      ],
      'SEXUAL ORIENTATION': <dynamic>[
        _user.orientation,
        <String>[
          'Gay',
          'Two',
          'Free',
          'Four'
        ] // TODO(alexandre): list of sexual orientations
      ],
      'EDUCATION': <TextEditingController>[
        TextEditingController()..text = _user.school,
        TextEditingController()..text = _user.degree
      ],
      'OCCUPATION': <TextEditingController>[
        TextEditingController()..text = _user.position,
        TextEditingController()..text = _user.employer
      ]
    };
    _user.pics.forEach(_pictures.add);
  }

  @override
  void dispose() {
    for (final MapEntry<String, List<dynamic>> entry in _controllers.entries) {
      if (entry is List<TextEditingController>)
        for (final TextEditingController textEditingController
            in entry.value as List<TextEditingController>) {
          textEditingController.dispose();
        }
    }
    _interestController.dispose();
    super.dispose();
  }

  Future<String> _saveImage(Uint8List image) async {
    final StorageReference ref = FirebaseStorage.instance
        .ref()
        .child('images/users/${_user.id}/${DateTime.now()}');
    final StorageUploadTask uploadTask = ref.putData(image);
    final StorageTaskSnapshot result = await uploadTask.onComplete;
    return (await result.ref.getDownloadURL()).toString();
  }

  Future<void> _addPicture(int index) async {
    try {
      final Uint8List picture =
          (await (await MultiImagePicker.pickImages(maxImages: 1))[0]
                  .getByteData())
              .buffer
              .asUint8List();
      setState(() => index >= _pictures.length
          ? _pictures.add(picture)
          : _pictures[index] = picture);
    } catch (error) {
      return;
    }
  }

  Widget _buildPicture() {
    return Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(alignment: Alignment.center, children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: _pictures.isEmpty
                  ? const CachedImage(null, imageType: ImageType.UserBig)
                  : _pictures[0] is String
                      ? CachedImage(_pictures[0] as String,
                          imageType: ImageType.UserBig)
                      : Image.memory(_pictures[0] as Uint8List,
                          fit: BoxFit.cover)),
          if (_isEdition)
            Container(
                color: black.withOpacity(0.4),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Row(children: <Widget>[
                  Expanded(
                      child: Container(
                          height: 300.0,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _buildPictureSlot(
                                    _pictures.isEmpty ? null : _pictures[0], 0),
                                const Expanded(
                                    child: Text('MAIN',
                                        style: TextStyle(color: white)))
                              ]))),
                  for (int i = 1; i < 4; i += 1)
                    Expanded(
                        child: Container(
                            height: 300.0,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  _buildPictureSlot(
                                      i >= _pictures.length
                                          ? null
                                          : _pictures[i],
                                      i),
                                  _buildPictureSlot(
                                      i + 3 >= _pictures.length
                                          ? null
                                          : _pictures[i + 3],
                                      i + 3),
                                ])))
                ])),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Wrap(children: <Widget>[
                              Text('${_user.name} • ${_user.getAge()}',
                                  style: const TextStyle(
                                      color: white,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold)),
                            ]),
                            if (!_isEdition)
                              GestureDetector(
                                  onTap: () =>
                                      setState(() => _isEdition = true),
                                  child: Icon(Icons.edit, color: white)),
                          ]))))
        ]));
  }

  Widget _buildPictureSlot(dynamic picture, int index) {
    return Expanded(
        child: GestureDetector(
            onTap: () => _addPicture(index),
            child: Container(
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5.0),
                child: picture == null
                    ? DottedBorder(
                        color: white,
                        child: Center(child: Icon(Icons.add, color: white)))
                    : picture is String
                        ? CachedImage(picture, imageType: ImageType.User)
                        : Image.memory(picture as Uint8List,
                            fit: BoxFit.cover))));
  }

  Widget _buildAbout() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: <Widget>[
          Row(children: const <Widget>[
            Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('ABOUT',
                    style: TextStyle(color: pinkBright, fontSize: 20.0)))
          ]),
          _buildAboutBloc('LOCATION', <String>[_user.home]),
          _buildAboutBloc('GENDER', <String>[_user.gender]),
          _buildAboutBloc('PRONOUNS', <String>[_user.pronoun]),
          _buildAboutBloc('SEXUAL ORIENTATION', <String>[_user.orientation]),
          _buildAboutBloc('EDUCATION', <String>[_user.school, _user.degree],
              placeholders: <String>['School', 'Degree']),
          _buildAboutBloc(
              'OCCUPATION', <String>[_user.position, _user.employer],
              placeholders: <String>['Position', 'Employer']),
        ]));
  }

  Widget _buildAboutBloc(String title, List<String> content,
      {List<String> placeholders}) {
    final String display =
        content.where((String element) => element != '').toList().join(' • ');
    return !_isEdition && display == ''
        ? Container()
        : Row(children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(title.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (_isEdition)
                        _buildAboutController(title, _controllers[title],
                            placeholders: placeholders)
                      else
                        Text(display, style: const TextStyle(color: orange)),
                    ]))
          ]);
  }

  Widget _buildAboutController(String title, dynamic controller,
      {List<String> placeholders}) {
    return Column(children: <Widget>[
      if (controller is List<TextEditingController>)
        for (final MapEntry<int, TextEditingController> textEditingController
            in controller.asMap().entries)
          Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(border: Border.all(color: orange)),
              width: 350.0, // TODO(robin): change this to expanded if you can
              height: 40.0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        width: 300.0,
                        child: TextField(
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(0.0),
                              isDense: true,
                              border: InputBorder.none,
                              hintText: placeholders == null
                                  ? null
                                  : placeholders[textEditingController.key]),
                          controller: textEditingController.value,
                        )),
                    if (textEditingController.value.text.isNotEmpty)
                      GestureDetector(
                          onTap: () => textEditingController.value.clear(),
                          child: Icon(Icons.close, color: orange)),
                  ]))
      else if (controller is List<dynamic>)
        Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(border: Border.all(color: orange)),
            width: 350.0, // TODO(robin): change this to expanded if you can
            height: 40.0,
            child: DropdownButton<String>(
                isExpanded: true,
                value: controller[0] as String,
                icon: const Icon(Icons.arrow_drop_down, color: orange),
                underline: Container(),
                style: const TextStyle(color: orange),
                onChanged: (String newValue) =>
                    setState(() => controller[0] = newValue),
                items: (controller[1] as List<String>)
                    .map<DropdownMenuItem<String>>((String value) =>
                        DropdownMenuItem<String>(
                            value: value, child: Text(value)))
                    .toList()))
    ]);
  }

  Widget _buildInterests() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Row(children: const <Widget>[
            Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('INTERESTS',
                    style: TextStyle(color: pinkBright, fontSize: 20.0)))
          ]),
          Wrap(alignment: WrapAlignment.start, children: <Widget>[
            for (final MapEntry<int, Interest> interest
                in _user.interests.asMap().entries)
              _isEdition
                  ? Container(
                      margin: const EdgeInsets.all(5.0),
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                          color: pinkLight.withOpacity(0.4),
                          border: Border.all(color: pinkBright)),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(interest.value.name.toUpperCase(),
                                style: const TextStyle(color: pinkBright)),
                            GestureDetector(
                                onTap: () => setState(() =>
                                    _user.interests.removeAt(interest.key)),
                                child: Icon(Icons.close, color: pinkBright))
                          ]))
                  : Container(
                      padding: const EdgeInsets.all(5.0),
                      margin: const EdgeInsets.all(5.0),
                      decoration:
                          BoxDecoration(border: Border.all(color: pinkBright)),
                      child: Text(interest.value.name.toUpperCase(),
                          style: const TextStyle(color: pinkBright)))
          ]),
          if (_isEdition)
            TypeAheadField<Map<String, String>>(
                autoFlipDirection: true,
                textFieldConfiguration: TextFieldConfiguration<String>(
                    onEditingComplete: () => FocusScope.of(context).unfocus(),
                    decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.only(left: 10.0, top: 10.0),
                        border: UnderlineInputBorder(),
                        hintText: 'Add more interests',
                        hintStyle: TextStyle(color: orange),
                        suffixIcon: Icon(Icons.search)),
                    controller: _interestController),
                suggestionsCallback: (String pattern) => pattern.isEmpty
                    ? null
                    : _interestSuggestions.where((Map<String, String> elem) {
                        final String name = elem['name'].toLowerCase();
                        final Interest interest = _user.interests.firstWhere(
                            (Interest interest) =>
                                interest.name.toLowerCase() == name,
                            orElse: () => null);

                        return interest == null &&
                            name.startsWith(pattern.toLowerCase());
                      }).toList(),
                itemBuilder:
                    (BuildContext context, Map<String, String> suggestion) =>
                        ListTile(
                            leading: Icon(Icons.category),
                            title: Text(suggestion['name'],
                                style: const TextStyle(color: orange))),
                onSuggestionSelected: (Map<String, String> suggestion) =>
                    setState(() {
                      _interestController.clear();
                      _user.interests.add(Interest(name: suggestion['name']));
                    }))
        ]));
  }

  Widget _buildNavBar(
      AppState state, void Function(ReduxAction<dynamic>) dispatch) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
            child: BottomNavigationBar(
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                currentIndex: state.homePageIndex,
                items: bubbleBar(context, 0, state.theme),
                onTap: (int index) async {
                  if (index == state.homePageIndex) {
                    return;
                  }
                  dispatch(AppNavigateAction(index));
                  if (index == 1) {
                    dispatch(EventsGetAction());
                  }
                  Navigator.of(context)
                      .popUntil((Route<dynamic> route) => route.isFirst);
                })));
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<dynamic>) dispatch,
        Widget child) {
      return View(
          isProfileScreen: true,
          isEditing: true,
          user: _user,
          child: ListView(children: <Widget>[
            _buildPicture(),
            _buildAbout(),
            const Divider(),
            _buildInterests(),
            if (_isEdition)
              Button(
                  width: 200.0,
                  text: 'SAVE CHANGES',
                  onPressed: () async {
                    _user.home =
                        (_controllers['LOCATION'][0] as TextEditingController)
                            .text
                            .trim();
                    _user.school =
                        (_controllers['EDUCATION'][0] as TextEditingController)
                            .text
                            .trim();
                    _user.degree =
                        (_controllers['EDUCATION'][1] as TextEditingController)
                            .text
                            .trim();
                    _user.position =
                        (_controllers['OCCUPATION'][0] as TextEditingController)
                            .text
                            .trim();
                    _user.employer =
                        (_controllers['OCCUPATION'][1] as TextEditingController)
                            .text
                            .trim();
                    _user.pics = await Future.wait<String>(
                        _pictures.map((dynamic picture) async {
                      if (picture is Uint8List) {
                        return await _saveImage(picture);
                      }
                      return picture as String;
                    }).toList());
                    updateUser(_user);
                    dispatch(NavigateAction<AppState>.pop());
                  }),
            _buildNavBar(state, dispatch),
          ]));
    });
  }
}
