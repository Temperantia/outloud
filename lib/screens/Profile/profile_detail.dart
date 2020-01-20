import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:inclusive/classes/interest.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/theme.dart';

class ProfileDetail extends StatelessWidget {
  const ProfileDetail(this.user);

  final User user;

  Divider divider() {
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
                  layout: SwiperLayout.STACK,
                  itemWidth: 500.0,
                )),
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: <Widget>[
              Row(children: <Widget>[
                Text(
                    '${user.name} • ${user.getAge().toString()} • ${user.home}',
                    style: const TextStyle(fontSize: 30.0))
              ]),
              divider(),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.whatshot),
                      const Text('Interests')
                    ],
                  ),
                  Row(children: <Widget>[
                    Text(user.interests
                        .map<String>((Interest interest) =>
                            '#${interest.name} • ${interest.comment}')
                        .toList()
                        .join())
                  ])
                ],
              ),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                      children: const <Widget>[Text('Profession • Broker')])),
              divider(),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset('images/baseline_emoji_people_black_18.png',
                          height: 25.0),
                      const Text('About me')
                    ],
                  ),
                  Row(children: <Widget>[Text(user.description)])
                ],
              ),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(children: const <Widget>[
                    Text('Education • CAP Poterie')
                  ])),
              divider(),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.check_circle),
                      const Text('Some truth')
                    ],
                  ),
                ],
              ),
            ],
          ))
    ]);
  }
}
