import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:inclusive/classes/interest.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/theme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfileDetail extends StatelessWidget {
  const ProfileDetail(this.user);

  final User user;

  Divider _buildDivider() {
    return Divider(
      color: red,
      height: 10,
      indent: 100,
      endIndent: 100,
      thickness: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.4,
          child: user.pics.isEmpty
              ? Image.asset('images/default-user-profile-image-png-7.png')
              : Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Image.network(user.pics[index].toString(),
                        fit: BoxFit.fitHeight);
                  },
                  itemCount: user.pics.length,
                  pagination: const SwiperPagination(),
                  control: const SwiperControl())),
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: <Widget>[
              ListTile(
                  title: RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              fontSize: 30.0, color: Colors.black),
                          children: <TextSpan>[
                    TextSpan(
                        text: '${user.name} • ${user.getAge().toString()}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    if (user.home != '') TextSpan(text: '• ${user.home}'),
                  ]))),
              _buildDivider(),
              ListTile(
                  leading: Icon(Icons.whatshot),
                  title: const Text('Interests'),
                  subtitle: Text(user.interests
                      .map<String>((Interest interest) =>
                          '#${interest.name} • ${interest.comment}')
                      .toList()
                      .join())),
              _buildDivider(),
              ListTile(
                  leading: Image.asset(
                      'images/baseline_emoji_people_black_18.png',
                      height: 25.0,
                      color: orange),
                  title: const Text('About me'),
                  subtitle: Text(user.description)),
              const ListTile(
                  leading: Icon(MdiIcons.briefcaseOutline),
                  title: Text('Profession • Broker')),
              const ListTile(
                  leading: Icon(MdiIcons.schoolOutline),
                  title: Text('Education • CAP Poterie')),
              _buildDivider(),
              ListTile(
                  leading: Icon(Icons.check_circle),
                  title: const Text('Some truth'))
            ],
          ))
    ]);
  }
}
