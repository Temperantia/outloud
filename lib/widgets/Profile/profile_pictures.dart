import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/theme.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:reorderables/reorderables.dart';

class ProfilePictures extends StatefulWidget {
  const ProfilePictures(this.user, {Key key}) : super(key: key);

  final User user;

  @override
  ProfilePicturesState createState() => ProfilePicturesState();
}

class ProfilePicturesState extends State<ProfilePictures> {
  final List<dynamic> pictures = <dynamic>[];
  final List<String> picturesToDelete = <String>[];

  @override
  void initState() {
    super.initState();
    widget.user.pics.forEach(pictures.add);
  }

  Future<void> _addPicture() async {
    Uint8List picture;
    try {
      picture = (await (await MultiImagePicker.pickImages(maxImages: 1))[0]
              .getByteData())
          .buffer
          .asUint8List();
    } catch (error) {
      return;
    }
    setState(() => pictures.add(picture));
  }

  Future<void> _removePicture(dynamic picture) async {
    if (picture is String) {
      picturesToDelete.add(picture);
    }
    setState(() => pictures.remove(picture));
  }

  Widget _buildPicture(dynamic picture) {
    return Stack(alignment: AlignmentDirectional.bottomEnd, children: <Widget>[
      Container(
          width: MediaQuery.of(context).size.width * 0.3,
          child: picture is Uint8List
              ? Image.memory(picture, key: ValueKey<Uint8List>(picture))
              : Image.network(picture as String,
                  key: ValueKey<String>(picture as String))),
      GestureDetector(
          onTap: () => _removePicture(picture),
          child: Container(
              decoration: BoxDecoration(color: white, shape: BoxShape.circle),
              child: Icon(Icons.close, color: red)))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableWrap(
      spacing: 8.0,
      padding: const EdgeInsets.all(8.0),
      onReorder: (int oldIndex, int newIndex) => setState(() {
        if (oldIndex >= pictures.length) {
          return;
        }
        final dynamic picture = pictures[oldIndex];
        if (newIndex >= pictures.length) {
          newIndex = pictures.length - 1;
        }
        pictures.removeAt(oldIndex);
        pictures.insert(newIndex, picture);
      }),
      children: <Widget>[
        for (final dynamic picture in pictures) _buildPicture(picture),
        for (int index = pictures.length; index < 9; index++)
          Stack(alignment: AlignmentDirectional.bottomEnd, children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Image.asset(
                    'images/default-user-profile-image-png-7.png',
                    key: ValueKey<int>(index))),
            GestureDetector(
                onTap: () => _addPicture(),
                child: Container(
                    decoration:
                        BoxDecoration(color: orange, shape: BoxShape.circle),
                    child: Icon(Icons.add, color: white)))
          ])
      ],
    );
  }
}
