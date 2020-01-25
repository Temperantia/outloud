import 'package:arrow_path/arrow_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:inclusive/classes/interest.dart';
import 'package:inclusive/classes/user.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ArrowPainter extends CustomPainter {
  ArrowPainter({this.reverse});
  final bool reverse;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    Path path = Path()
      ..moveTo(reverse ? 200 : -200, 0)
      ..lineTo(reverse ? -200 : 200, 0);
    path = ArrowPath.make(path: path);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) => true;
}

class ProfileDetail extends StatelessWidget {
  const ProfileDetail(this.user);

  final User user;

  Widget _buildDivider({bool reverse = false}) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: CustomPaint(painter: ArrowPainter(reverse: reverse)));
  }

  @override
  Widget build(BuildContext context) {
    String text = '${user.getAge().toString()}';
    if (user.name.isNotEmpty) {
      text = '${user.name} • $text';
    }
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
          child: Column(children: <Widget>[
            ListTile(
                title: RichText(
                    text: TextSpan(
                        style: const TextStyle(
                            fontSize: 30.0, color: Colors.black),
                        children: <TextSpan>[
                  TextSpan(
                      text: text,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  if (user.home.isNotEmpty) TextSpan(text: ' • ${user.home}'),
                ]))),
            if (user.interests.isNotEmpty)
              Column(children: <Widget>[
                _buildDivider(),
                ListTile(
                    leading: Icon(Icons.whatshot),
                    title: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text('Interests',
                            style: TextStyle(fontSize: 20.0))),
                    subtitle: Text(user.interests
                        .map<String>((Interest interest) {
                          String name = '#${interest.name} ';
                          if (interest.comment.isNotEmpty) {
                            name += '• ${interest.comment}\n';
                          }
                          return name;
                        })
                        .toList()
                        .join())),
              ]),
            if (user.description.isNotEmpty &&
                user.profession.isNotEmpty &&
                user.education.isNotEmpty)
              Column(
                children: <Widget>[
                  _buildDivider(reverse: true),
                  if (user.description.isNotEmpty)
                    ListTile(
                        leading: Image.asset(
                            'images/baseline_emoji_people_black_18.png',
                            height: 25.0,
                            color: Colors.grey),
                        title: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text('About me',
                                style: TextStyle(fontSize: 20.0))),
                        subtitle: Text(user.description)),
                  if (user.profession.isNotEmpty)
                    ListTile(
                        leading: Icon(MdiIcons.briefcaseOutline),
                        title: Text('Profession • ${user.profession}',
                            style: const TextStyle(fontSize: 20.0))),
                  if (user.education.isNotEmpty)
                    ListTile(
                        leading: Icon(MdiIcons.schoolOutline),
                        title: Text('Education • ${user.education}',
                            style: const TextStyle(fontSize: 20.0))),
                ],
              ),
            if (user.facts.isNotEmpty)
              Column(children: <Widget>[
                _buildDivider(),
                ListTile(
                    leading: Icon(Icons.check_circle),
                    title: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text('Some truth',
                            style: TextStyle(fontSize: 20.0))),
                    subtitle: Text(user.facts.join(' • '))),
              ]),
            const SizedBox(height: 100.0),
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: RaisedButton(
                    onPressed: () {}, child: const Text('Friends')))
          ]))
    ]);
  }
}
