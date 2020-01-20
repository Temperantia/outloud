import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

import 'package:inclusive/classes/user.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/Search/search_interest.dart';
import 'package:inclusive/widgets/birthdate_picker.dart';

class ProfileEdition extends StatefulWidget {
  ProfileEdition(this.user, this.onSave) : initialUser = user.toJson();
  final User user;
  final void Function(User) onSave;
  final dynamic initialUser;

  @override
  _ProfileEditionState createState() => _ProfileEditionState();
}

class _ProfileEditionState extends State<ProfileEdition> {
  final TextEditingController _editName = TextEditingController();
  final TextEditingController _editHome = TextEditingController();
  final TextEditingController _editDescription = TextEditingController();
  UserModel _userProvider;

  String _editing = '';
  bool _isNameTaken = false;

  @override
  void initState() {
    super.initState();
    _editName.text = widget.user.name;
    _editHome.text = widget.user.home;
    _editDescription.text = widget.user.description;
  }

  @override
  void dispose() {
    _editName.dispose();
    _editHome.dispose();
    _editDescription.dispose();
    super.dispose();
  }

  Divider _buildDivider() {
    return Divider(
      color: Colors.red,
      height: 10,
      indent: 100,
      endIndent: 100,
      thickness: 1,
    );
  }

  Widget _buildActions() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              child: Text('Touch something to edit',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: orangeLight,
                  ))),
          IconButton(
              color: orange,
              icon: Icon(Icons.done),
              onPressed: () async {
                final User user =
                    await _userProvider.getUserWithName(widget.user.name);
                if (widget.user.name != '' &&
                    widget.user.name != widget.initialUser['name'] &&
                    user != null) {
                  setState(() {
                    _isNameTaken = true;
                  });
                } else {
                  widget.onSave(widget.user);
                }
              })
        ]);
  }

  Widget _buildUserInfo() {
    return ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(0.0),
        children: <Widget>[
          if (_editing == 'name')
            TextField(
                autofocus: true,
                onEditingComplete: () {
                  setState(() {
                    _isNameTaken = false;
                    widget.user.name = _editName.text;
                  });
                  FocusScope.of(context).unfocus();
                },
                controller: _editName,
                style: TextStyle(
                  fontSize: 32,
                  color: orange,
                ))
          else
            GestureDetector(
                onTap: () => setState(() => _editing = 'name'),
                child: Text(
                    widget.user.name == ''
                        ? 'Insert name here'
                        : widget.user.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      color: orange,
                    ))),
          if (_isNameTaken) const Text('Name is already taken'),
          if (_editing == 'age')
            BirthdatePicker(
                initial: widget.user.birthDate,
                onChange: (DateTime birthDate) {
                  setState(() => widget.user.birthDate = birthDate);
                })
          else
            GestureDetector(
                onTap: () => setState(() => _editing = 'age'),
                child: Text(
                  widget.user.getAge().toString() + ' years old',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: orange,
                  ),
                )),
          if (_editing == 'location')
            TextField(
                autofocus: true,
                onEditingComplete: () {
                  setState(() => widget.user.home = _editHome.text);
                  FocusScope.of(context).unfocus();
                },
                controller: _editHome,
                style: TextStyle(
                  fontSize: 18,
                  color: orange,
                ))
          else
            GestureDetector(
                onTap: () => setState(() => _editing = 'location'),
                child: Text(
                    widget.user.home == ''
                        ? 'Insert location there'
                        : widget.user.home,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: orange,
                    )))
        ]);
  }

  Widget _buildUserPictures() {
    return Expanded(
        child: widget.user.pics.isEmpty
            ? Image.asset('images/default-user-profile-image-png-7.png')
            : Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.network(widget.user.pics[index].toString());
                },
                itemCount: widget.user.pics.length,
                control: const SwiperControl(),
                pagination: const SwiperPagination(),
                loop: false));
  }

  Widget _buildUserPictureInput() {
    return _editing == 'pictures'
        ? Container()
        : GestureDetector(
            onTap: () async {
              /*  List<Asset> images;
              try {
                images = await MultiImagePicker.pickImages(maxImages: 20);
              } catch (error) {
                return;
              }
              final List<String> pics = List<String>.from(widget.user.pics);

              for (final Asset image in images) {
                final String imageUri =
                    await _appDataService.saveImage(image, widget.user.id);
                pics.add(imageUri);
              }
              widget.user.pics = pics; */
            },
            child: Text('Click to upload pictures',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: orangeLight,
                )));
  }

  Widget _buildUserInterests() {
    return ListTile(
      dense: true,
      title: Text('Interests',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: orange,
          )),
      subtitle: _editing == 'interests'
          ? SearchInterest(interests: widget.user.interests)
          : GestureDetector(
              onTap: () => setState(() => _editing = 'interests'),
              child: Text(
                  widget.user.interests.isEmpty
                      ? 'Insert interests up there'
                      : widget.user.interests.join(', '),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: orangeLight,
                  ))),
      leading: Icon(
        Icons.category,
        color: blueLight,
        size: 40,
      ),
    );
  }

  Widget _buildUserAbout() {
    return ListTile(
      dense: true,
      title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text('About me',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: orange,
              ))),
      subtitle: _editing == 'description'
          ? TextField(
              autofocus: true,
              onChanged: (String text) {
                setState(() => widget.user.description = text);
              },
              controller: _editDescription,
              maxLines: null,
              style: TextStyle(
                fontSize: 18,
                color: orange,
              ),
            )
          : GestureDetector(
              onTap: () => setState(() => _editing = 'description'),
              child: Text(
                  widget.user.description == ''
                      ? 'Insert description down there'
                      : widget.user.description,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: orangeLight,
                  ))),
      leading: Icon(
        Icons.description,
        color: blueLight,
        size: 40,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserModel>(context);
    return Container(
        decoration: BoxDecoration(color: white),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildActions(),
              _buildUserPictures(),
              _buildUserInfo(),
              _buildUserPictureInput(),
              _buildDivider(),
              _buildUserInterests(),
              _buildDivider(),
              _buildUserAbout(),
            ]));
  }
}
