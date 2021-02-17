import 'dart:typed_data' show Uint8List;

import 'package:async_redux/async_redux.dart' show ReduxAction, Store;
import 'package:auto_size_text/auto_size_text.dart' show AutoSizeText;
import 'package:business/app_state.dart' show AppState;
import 'package:business/classes/user.dart' show User;
import 'package:business/models/user.dart' show updateUser;
import 'package:carousel_slider/carousel_slider.dart'
    show CarouselOptions, CarouselSlider;
import 'package:dotted_border/dotted_border.dart' show DottedBorder;
import 'package:flutter/material.dart'
    show
        Align,
        Alignment,
        Border,
        BoxDecoration,
        BoxFit,
        BuildContext,
        Center,
        Column,
        Container,
        CrossAxisAlignment,
        Divider,
        DropdownButton,
        DropdownMenuItem,
        EdgeInsets,
        Expanded,
        FocusScope,
        FontWeight,
        GestureDetector,
        Icon,
        Icons,
        Image,
        InputBorder,
        InputDecoration,
        ListTile,
        ListView,
        MainAxisAlignment,
        MainAxisSize,
        MediaQuery,
        Padding,
        Row,
        Stack,
        State,
        StatefulWidget,
        TextEditingController,
        TextField,
        TextStyle,
        Theme,
        UnderlineInputBorder,
        Widget,
        Wrap,
        WrapAlignment;
import 'package:flutter_i18n/flutter_i18n.dart' show FlutterI18n;
import 'package:flutter_typeahead/flutter_typeahead.dart'
    show TextFieldConfiguration, TypeAheadField;
import 'package:outloud/functions/firebase.dart' show saveImage;
import 'package:outloud/theme.dart'
    show black, orange, pinkBright, pinkLight, white;
import 'package:outloud/widgets/cached_image.dart' show CachedImage, ImageType;
import 'package:outloud/widgets/view.dart' show View;
import 'package:multi_image_picker/multi_image_picker.dart'
    show MultiImagePicker;
import 'package:provider_for_redux/provider_for_redux.dart' show ReduxConsumer;

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
  List<Map<String, String>> _interestSuggestions;
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
      'GENDER': <dynamic>[_user.gender ?? ''],
      'PRONOUNS': <TextEditingController>[
        TextEditingController()..text = _user.pronoun
      ],
      'SEXUAL ORIENTATION': <dynamic>[_user.orientation ?? ''],
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
    if (_isEdition) {
      _save();
    }
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

  Future<void> _save() async {
    _user.home =
        (_controllers['LOCATION'][0] as TextEditingController).text.trim();
    _user.gender = _controllers['GENDER'][0] as String;
    _user.pronoun =
        (_controllers['PRONOUNS'][0] as TextEditingController).text.trim();
    _user.orientation = _controllers['SEXUAL ORIENTATION'][0] as String;
    _user.school =
        (_controllers['EDUCATION'][0] as TextEditingController).text.trim();
    _user.degree =
        (_controllers['EDUCATION'][1] as TextEditingController).text.trim();
    _user.position =
        (_controllers['OCCUPATION'][0] as TextEditingController).text.trim();
    _user.employer =
        (_controllers['OCCUPATION'][1] as TextEditingController).text.trim();
    _user.pics =
        await Future.wait<String>(_pictures.map((dynamic picture) async {
      if (picture is Uint8List) {
        return await saveImage(picture, 'images/users/${_user.id}');
      }
      return picture as String;
    }).toList());
    updateUser(_user);
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

  Widget _buildPicture(String userId) {
    final int age = _user.getAge();
    String name = _user.name;
    if (age != null) {
      name += '• $age';
    }

    final double height = MediaQuery.of(context).size.height -
        50.0 -
        MediaQuery.of(context).padding.top;
    return Container(
        height: height,
        child: Stack(alignment: Alignment.bottomCenter, children: <Widget>[
          CarouselSlider(
              items: _pictures
                  .map<Widget>((dynamic picture) => CachedImage(
                      picture as String,
                      imageType: ImageType.UserBig,
                      fit: BoxFit.fitHeight))
                  .toList(),
              options: CarouselOptions(
                  height: height,
                  enableInfiniteScroll: false,
                  viewportFraction: 1.0)),
          Container(
              color: black.withOpacity(0.6),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1),
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
                                Expanded(
                                    child: AutoSizeText(
                                        FlutterI18n.translate(
                                            context, 'PROFILE.MAIN'),
                                        style: const TextStyle(color: white)))
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
                  padding: const EdgeInsets.all(20.0),
                  child: Wrap(children: <Widget>[
                    AutoSizeText(name,
                        style: const TextStyle(
                            color: white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold)),
                    if (_user.id == userId && !_isEdition)
                      GestureDetector(
                          onTap: () => setState(() => _isEdition = true),
                          child: const Icon(Icons.edit, color: white)),
                  ])))
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
                        child:
                            const Center(child: Icon(Icons.add, color: white)))
                    : picture is String
                        ? CachedImage(picture, imageType: ImageType.User)
                        : Image.memory(picture as Uint8List,
                            fit: BoxFit.cover))));
  }

  Widget _buildAbout() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(
                    FlutterI18n.translate(context, 'PROFILE.ABOUT'),
                    style: const TextStyle(color: pinkBright, fontSize: 20.0)))
          ]),
          _buildAboutBloc(FlutterI18n.translate(context, 'PROFILE.LOCATION'),
              <String>[_user.home], 'LOCATION'),
          _buildAboutBloc(FlutterI18n.translate(context, 'PROFILE.GENDER'),
              <String>[_user.gender], 'GENDER'),
          _buildAboutBloc(FlutterI18n.translate(context, 'PROFILE.PRONOUNS'),
              <String>[_user.pronoun], 'PRONOUNS'),
          _buildAboutBloc(
              FlutterI18n.translate(context, 'PROFILE.SEXUAL_ORIENTATION'),
              <String>[_user.orientation],
              'SEXUAL ORIENTATION'),
          _buildAboutBloc(FlutterI18n.translate(context, 'PROFILE.EDUCATION'),
              <String>[_user.school, _user.degree], 'EDUCATION',
              placeholders: <String>[
                FlutterI18n.translate(context, 'PROFILE.SCHOOL'),
                FlutterI18n.translate(context, 'PROFILE.DEGREE')
              ]),
          _buildAboutBloc(FlutterI18n.translate(context, 'PROFILE.OCCUPATION'),
              <String>[_user.position, _user.employer], 'OCCUPATION',
              placeholders: <String>[
                FlutterI18n.translate(context, 'PROFILE.POSITION'),
                FlutterI18n.translate(context, 'PROFILE.EMPLOYER')
              ])
        ]));
  }

  Widget _buildAboutBloc(
      String title, List<String> content, String controllerKey,
      {List<String> placeholders}) {
    final String display =
        content.where((String element) => element != '').toList().join(' • ');
    return !_isEdition && display == ''
        ? Container(width: 0.0, height: 0.0)
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AutoSizeText(title.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (_isEdition)
                    _buildAboutController(title, _controllers[controllerKey],
                        placeholders: placeholders)
                  else
                    Row(children: <Widget>[
                      AutoSizeText(display,
                          style: const TextStyle(color: orange))
                    ])
                ]));
  }

  Widget _buildAboutController(String title, dynamic controller,
      {List<String> placeholders}) {
    return Column(children: <Widget>[
      if (controller is List<TextEditingController>)
        for (final MapEntry<int, TextEditingController> textEditingController
            in controller.asMap().entries)
          Row(children: <Widget>[
            Expanded(
                child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    padding: const EdgeInsets.all(5.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: orange)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                                child: TextField(
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(0.0),
                                        isDense: true,
                                        border: InputBorder.none,
                                        hintText: placeholders == null
                                            ? null
                                            : placeholders[
                                                textEditingController.key],
                                        hintStyle:
                                            const TextStyle(color: orange)),
                                    controller: textEditingController.value,
                                    style: const TextStyle(color: orange))),
                          ),
                          if (textEditingController.value.text.isNotEmpty)
                            GestureDetector(
                                onTap: () => setState(
                                    () => textEditingController.value.clear()),
                                child: const Icon(Icons.close, color: orange))
                        ])))
          ])
      else if (controller is List<dynamic>)
        Row(children: <Widget>[
          Expanded(
              child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(border: Border.all(color: orange)),
                  child: DropdownButton<String>(
                      isExpanded: true,
                      value: controller[1][0] as String,
                      icon: const Icon(Icons.arrow_drop_down, color: orange),
                      underline: Container(width: 0.0, height: 0.0),
                      style: const TextStyle(color: orange),
                      onChanged: (String newValue) =>
                          setState(() => controller[0] = newValue),
                      items: (controller[1] as List<String>)
                          .map<DropdownMenuItem<String>>((String value) =>
                              DropdownMenuItem<String>(
                                  value: value, child: AutoSizeText(value)))
                          .toList())))
        ])
    ]);
  }

  Widget _buildInterests() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Row(children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(
                    FlutterI18n.translate(context, 'PROFILE.INTERESTS'),
                    style: const TextStyle(color: pinkBright, fontSize: 20.0)))
          ]),
          Wrap(alignment: WrapAlignment.start, children: <Widget>[
            for (final MapEntry<int, String> interest
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
                            AutoSizeText(interest.value.toUpperCase(),
                                style: const TextStyle(color: pinkBright)),
                            GestureDetector(
                                onTap: () => setState(() =>
                                    _user.interests.removeAt(interest.key)),
                                child:
                                    const Icon(Icons.close, color: pinkBright))
                          ]))
                  : Container(
                      padding: const EdgeInsets.all(5.0),
                      margin: const EdgeInsets.all(5.0),
                      decoration:
                          BoxDecoration(border: Border.all(color: pinkBright)),
                      child: AutoSizeText(interest.value.toUpperCase(),
                          style: const TextStyle(color: pinkBright)))
          ]),
          if (_isEdition)
            TypeAheadField<Map<String, String>>(
                noItemsFoundBuilder: (BuildContext context) => AutoSizeText(
                    FlutterI18n.translate(context, 'PROFILE.NO_ITEM_FOUND'),
                    style: TextStyle(
                        color: Theme.of(context).errorColor, fontSize: 12)),
                autoFlipDirection: true,
                textFieldConfiguration: TextFieldConfiguration<String>(
                    onEditingComplete: () => FocusScope.of(context).unfocus(),
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.only(left: 10.0, top: 10.0),
                        border: const UnderlineInputBorder(),
                        hintText: FlutterI18n.translate(
                            context, 'PROFILE.ADD_INTERESTS'),
                        suffixIcon: const Icon(Icons.search)),
                    controller: _interestController),
                suggestionsCallback: (String pattern) => pattern.isEmpty
                    ? null
                    : _interestSuggestions.where((Map<String, String> elem) {
                        final String name = elem['name'].toLowerCase();
                        final String interest = _user.interests.firstWhere(
                            (String interest) => interest.toLowerCase() == name,
                            orElse: () => null);

                        return interest == null &&
                            name.startsWith(pattern.toLowerCase());
                      }).toList(),
                itemBuilder:
                    (BuildContext context, Map<String, String> suggestion) =>
                        ListTile(
                            leading: const Icon(Icons.category),
                            title: AutoSizeText(suggestion['name'],
                                style: const TextStyle(color: orange))),
                onSuggestionSelected: (Map<String, String> suggestion) =>
                    setState(() {
                      _interestController.clear();
                      _user.interests.add(suggestion['name']);
                    }))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<AppState>) dispatch,
        Widget child) {
      _interestSuggestions ??= <Map<String, String>>[
        <String, String>{
          'name': FlutterI18n.translate(context, 'INTERESTS.FOOD_AND_DRINK')
        },
        <String, String>{
          'name': FlutterI18n.translate(context, 'INTERESTS.ART')
        },
        <String, String>{
          'name': FlutterI18n.translate(context, 'INTERESTS.FASHION_AND_BEAUTY')
        },
        <String, String>{
          'name':
              FlutterI18n.translate(context, 'INTERESTS.OUTDOORS_AND_ADVENTURE')
        },
        <String, String>{
          'name': FlutterI18n.translate(context, 'INTERESTS.SPORT')
        },
        <String, String>{
          'name': FlutterI18n.translate(context, 'INTERESTS.FITNESS')
        },
        <String, String>{
          'name': FlutterI18n.translate(context, 'INTERESTS.TECH')
        },
        <String, String>{
          'name':
              FlutterI18n.translate(context, 'INTERESTS.HEALTH_AND_WELLNESS')
        },
        <String, String>{
          'name': FlutterI18n.translate(context, 'INTERESTS.SELF_GROWTH')
        },
        <String, String>{
          'name': FlutterI18n.translate(context, 'INTERESTS.PHOTOGRAPHY')
        },
        <String, String>{
          'name': FlutterI18n.translate(context, 'INTERESTS.WRITING')
        },
        <String, String>{
          'name':
              FlutterI18n.translate(context, 'INTERESTS.CULTURE_AND_LANGUAGE')
        },
        <String, String>{
          'name': FlutterI18n.translate(context, 'INTERESTS.MUSIC')
        },
        <String, String>{
          'name': FlutterI18n.translate(context, 'INTERESTS.ACTIVISM')
        },
        <String, String>{
          'name': FlutterI18n.translate(context, 'INTERESTS.FILM')
        },
        <String, String>{
          'name': FlutterI18n.translate(context, 'INTERESTS.GAMING')
        },
        <String, String>{
          'name': FlutterI18n.translate(context, 'INTERESTS.BELIEFS')
        },
        <String, String>{
          'name': FlutterI18n.translate(context, 'INTERESTS.BOOKS')
        },
        <String, String>{
          'name': FlutterI18n.translate(context, 'INTERESTS.DANCE')
        },
        <String, String>{
          'name': FlutterI18n.translate(context, 'INTERESTS.PET')
        },
        <String, String>{
          'name': FlutterI18n.translate(context, 'INTERESTS.CRAFT')
        },
      ];

      if (_controllers['GENDER'].length < 2) {
        _controllers['GENDER'].add(<String>[
          '',
          FlutterI18n.translate(context, 'GENDERS.AGENDER'),
          FlutterI18n.translate(context, 'GENDERS.ANDROGYNE'),
          FlutterI18n.translate(context, 'GENDERS.ANDROGYNOUS'),
          FlutterI18n.translate(context, 'GENDERS.BIGENDER'),
          FlutterI18n.translate(context, 'GENDERS.CIS'),
          FlutterI18n.translate(context, 'GENDERS.CISGENDER'),
          FlutterI18n.translate(context, 'GENDERS.CIS_FEMALE'),
          FlutterI18n.translate(context, 'GENDERS.CIS_MALE'),
          FlutterI18n.translate(context, 'GENDERS.CIS_MAN'),
          FlutterI18n.translate(context, 'GENDERS.CIS_WOMAN'),
          FlutterI18n.translate(context, 'GENDERS.CIS_GENDER_FEMALE'),
          FlutterI18n.translate(context, 'GENDERS.CISGENDER_MALE'),
          FlutterI18n.translate(context, 'GENDERS.CISGENDER_MAN'),
          FlutterI18n.translate(context, 'GENDERS.CISGENDER_WOMAN'),
          FlutterI18n.translate(context, 'GENDERS.FEMALE'),
          FlutterI18n.translate(context, 'GENDERS.FTM'),
          FlutterI18n.translate(context, 'GENDERS.GENDER_FLUID'),
          FlutterI18n.translate(context, 'GENDERS.GENDER_NONCONFORMING'),
          FlutterI18n.translate(context, 'GENDERS.GENDER_QUESTIONING'),
          FlutterI18n.translate(context, 'GENDERS.GENDER_VARIANT'),
          FlutterI18n.translate(context, 'GENDERS.GENDERQUEER'),
          FlutterI18n.translate(context, 'GENDERS.INTERSEX'),
          FlutterI18n.translate(context, 'GENDERS.MALE'),
          FlutterI18n.translate(context, 'GENDERS.MTF'),
          FlutterI18n.translate(context, 'GENDERS.NEITHER'),
          FlutterI18n.translate(context, 'GENDERS.NEUTROIS'),
          FlutterI18n.translate(context, 'GENDERS.NON_BINARY'),
          FlutterI18n.translate(context, 'GENDERS.OTHER'),
          FlutterI18n.translate(context, 'GENDERS.PANGENDER'),
          FlutterI18n.translate(context, 'GENDERS.TRANS'),
          FlutterI18n.translate(context, 'GENDERS.TRANS_FEMALE'),
          FlutterI18n.translate(context, 'GENDERS.TRANS_MALE'),
          FlutterI18n.translate(context, 'GENDERS.TRANS_MAN'),
          FlutterI18n.translate(context, 'GENDERS.TRANS_PERSON'),
          FlutterI18n.translate(context, 'GENDERS.TRANS_WOMAN'),
          FlutterI18n.translate(context, 'GENDERS.TRANSFEMININE'),
          FlutterI18n.translate(context, 'GENDERS.TRANSGENDER'),
          FlutterI18n.translate(context, 'GENDERS.TRANSGENDER_FEMALE'),
          FlutterI18n.translate(context, 'GENDERS.TRANSGENDER_MALE'),
          FlutterI18n.translate(context, 'GENDERS.TRANSGENDER_MAN'),
          FlutterI18n.translate(context, 'GENDERS.TRANSGENDER_PERSON'),
          FlutterI18n.translate(context, 'GENDERS.TRANSGENDER_WOMAN'),
          FlutterI18n.translate(context, 'GENDERS.TRANSMASCULINE'),
          FlutterI18n.translate(context, 'GENDERS.TRANSSEXUAL'),
          FlutterI18n.translate(context, 'GENDERS.TRANSSEXUAL_FEMALE'),
          FlutterI18n.translate(context, 'GENDERS.TRANSSEXUAL_MALE'),
          FlutterI18n.translate(context, 'GENDERS.TRANSSEXUAL_MAN'),
          FlutterI18n.translate(context, 'GENDERS.TRANSSEXUAL_PERSON'),
          FlutterI18n.translate(context, 'GENDERS.TRANSSEXUAL_WOMAN'),
          FlutterI18n.translate(context, 'GENDERS.TWO_SPIRIT'),
        ]);
      }

      if (_controllers['SEXUAL ORIENTATION'].length < 2) {
        _controllers['SEXUAL ORIENTATION'].add(<String>[
          '',
          FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.GAY'),
          FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.LESBIAN'),
          FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.BI'),
          FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.PAN'),
          FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.QUEER'),
          FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.ASEXUAL'),
          FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.ALLOSEXUAL'),
          FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.AROMANTIC'),
          FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.HETEROSEXUAL'),
          FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.CLOSETED'),
          FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.ANDROSEXUAL'),
          FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.BICURIOUS'),
          FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.DEMIROMANTIC'),
          FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.DEMISEXUAL'),
          FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.GYNESEXUAL'),
          FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.POLYAMOROUS'),
          FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.SKOLIOSEXUAL'),
          FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.GRAYSEXUAL'),
          FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.SAPIOSEXUAL'),
        ]);
      }

      return View(
          isProfileScreen: true,
          showNavBar: false,
          isEditing: _isEdition,
          user: _user,
          child: ListView(children: <Widget>[
            _buildPicture(state.userState.user.id),
            _buildAbout(),
            const Divider(color: orange),
            _buildInterests()
          ]));
    });
  }
}
