import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_tags/tag.dart';
import 'package:inclusive/models/userModel.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/Profile/birthdate-picker.dart';
import 'package:provider/provider.dart';

class ProfileEditionScreen extends StatefulWidget {
  final User user;
  final Function onSave;
  final dynamic initialUser;

  ProfileEditionScreen(this.user, this.onSave) : initialUser = user.toJson();

  @override
  ProfileEditionState createState() => ProfileEditionState();
}

class ProfileEditionState extends State<ProfileEditionScreen> {
  UserModel userProvider;
  String editing = '';
  bool isNameTaken = false;
  List<Item> interests = [];
  int count = 0;
  final TextEditingController editName = TextEditingController();
  final TextEditingController editLocation = TextEditingController();
  final TextEditingController editDescription = TextEditingController();

  @override
  void initState() {
    super.initState();
    editName.text = widget.user.name;
    editLocation.text = widget.user.location;
    editDescription.text = widget.user.description;
    interests = widget.user.interests.map((interest) {
      Item item = Item(index: count, title: interest);
      ++count;
      return item;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserModel>(context);
    return SingleChildScrollView(
        child: Card(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildActions(),
        buildUserInfo(),
        buildDivider(),
        buildUserInterests(),
        buildDivider(),
        buildUserAbout(),
      ],
    )));
  }

  Divider buildDivider() {
    return Divider(
      color: Colors.red,
      height: 10,
      indent: 100,
      endIndent: 100,
      thickness: 1,
    );
  }

  Widget buildActions() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
          onPressed: () {
            userProvider.getUserWithName(widget.user.name).then((User user) {
              if (widget.user.name != '' &&
                  widget.user.name != widget.initialUser['name'] &&
                  user != null) {
                setState(() {
                  isNameTaken = true;
                });
              } else {
                widget.onSave(widget.user);
              }
            });
          })
    ]);
  }

  Widget buildUserInfo() {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(0.0),
      children: [
        editing == 'name'
            ? TextField(
                autofocus: true,
                onEditingComplete: () {
                  setState(() {
                    isNameTaken = false;
                    widget.user.name = editName.text;
                  });
                  FocusScope.of(context).unfocus();
                },
                controller: editName,
                style: TextStyle(
                  fontSize: 32,
                  color: orange,
                ),
              )
            : GestureDetector(
                onTap: () => setState(() => editing = 'name'),
                child: Text(
                  widget.user.name == ''
                      ? 'Insert name here'
                      : widget.user.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    color: orange,
                  ),
                )),
        if (isNameTaken) Text('Name is already taken'),
        editing == 'age'
            ? BirthdatePicker(
                initial: widget.user.birthDate,
                onChange: (birthDate) {
                  setState(() => widget.user.birthDate = birthDate);
                },
                theme: DateTimePickerTheme(
                  title: Text('BirthDate'),
                ))
            : GestureDetector(
                onTap: () => setState(() => editing = 'age'),
                child: Text(
                  widget.user.getAge().toString() + ' years old',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: orange,
                  ),
                )),
        editing == 'location'
            ? TextField(
                autofocus: true,
                onEditingComplete: () {
                  setState(() => widget.user.location = editLocation.text);
                  FocusScope.of(context).unfocus();
                },
                controller: editLocation,
                style: TextStyle(
                  fontSize: 18,
                  color: orange,
                ),
              )
            : GestureDetector(
                onTap: () => setState(() => editing = 'location'),
                child: Text(
                  widget.user.location == null || widget.user.location == ''
                      ? 'Insert location there'
                      : widget.user.location,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: orange,
                  ),
                )),
      ],
    );
  }

  Widget buildUserInterests() {
    return ListTile(
      dense: true,
      title: Text('Interests',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: orange,
          )),
      subtitle: editing == 'interests'
          ? Tags(
              itemBuilder: (int index) {
                final item = interests[index];

                return ItemTags(
                  activeColor: blue,
                  key: Key(index.toString()),
                  index: index,
                  onRemoved: () {
                    setState(() {
                      interests.removeAt(index);
                      widget.user.interests = interests
                          .map((Item interest) => interest.title)
                          .toList();
                    });
                  },
                  pressEnabled: false,
                  removeButton: ItemTagsRemoveButton(
                    color: blue,
                    backgroundColor: orange,
                  ),
                  title: item.title,
                  textStyle: Theme.of(context).textTheme.caption,
                );
              },
              itemCount: interests.length,
              textField: TagsTextField(
                autofocus: true,
                helperTextStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: orangeLight),
                hintText: '+ Add an interest',
                hintTextColor: orange,
                onSubmitted: (String str) {
                  setState(() {
                    interests.add(Item(index: count, title: str));
                    ++count;
                    widget.user.interests = interests
                        .map((Item interest) => interest.title)
                        .toList();
                  });
                },
                textStyle: TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 15, color: orange),
                suggestions: const ['gay', 'lesbian', 'gay community'],
                suggestionTextColor: orange,
              ),
            )
          : GestureDetector(
              onTap: () => setState(() => editing = 'interests'),
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

  Widget buildUserAbout() {
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
      subtitle: editing == 'description'
          ? TextField(
              autofocus: true,
              onChanged: (text) {
                setState(() => widget.user.description = text);
              },
              controller: editDescription,
              maxLines: null,
              style: TextStyle(
                fontSize: 18,
                color: orange,
              ),
            )
          : GestureDetector(
              onTap: () => setState(() => editing = 'description'),
              child: Text(
                  widget.user.description == null ||
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
}
