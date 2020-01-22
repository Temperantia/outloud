import 'package:arrow_path/arrow_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:inclusive/classes/interest.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/theme.dart';
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
    return CustomPaint(
      painter: ArrowPainter(reverse: reverse),
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
          child: Column(children: <Widget>[
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
            if (user.interests.isNotEmpty)
              ListTile(
                  leading: Icon(Icons.whatshot),
                  title: const Text('Interests'),
                  subtitle: Text(user.interests
                      .map<String>((Interest interest) {
                        String name = '#${interest.name} ';
                        if (interest.comment != '') {
                          name += '• ${interest.comment}\n';
                        }
                        return name;
                      })
                      .toList()
                      .join())),
            _buildDivider(reverse: true),
            if (user.description != '')
              ListTile(
                  leading: Image.asset(
                      'images/baseline_emoji_people_black_18.png',
                      height: 25.0,
                      color: Colors.grey),
                  title: const Text('About me'),
                  subtitle: Text(user.description)),
            if (user.profession != '')
              ListTile(
                  leading: Icon(MdiIcons.briefcaseOutline),
                  title: Text('Profession • ${user.profession}')),
            if (user.education != '')
              ListTile(
                  leading: Icon(MdiIcons.schoolOutline),
                  title: Text('Education • ${user.education}')),
            _buildDivider(),
            if (user.facts.isNotEmpty)
              ListTile(
                  leading: Icon(Icons.check_circle),
                  title: const Text('Some truth'),
                  subtitle: Text(user.facts.join(' • '))),
          ]))
    ]);
  }
}
