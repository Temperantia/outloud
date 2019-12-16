import 'package:flutter/material.dart';

class User {
  final DateTime birthDate;
  String description;
  String email;
  String image;
  String location;
  String name;
  String username;

  User(
      {@required this.birthDate,
      this.description,
      @required this.email,
      this.image,
      this.location,
      @required this.name,
      @required this.username});
}
