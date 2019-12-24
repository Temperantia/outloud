import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:inclusive/widgets/Search/search-group.dart';
import 'package:inclusive/widgets/Search/search-solo.dart';
import 'package:inclusive/theme.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchScreen> {
  bool _solo = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => setState(() {
                  if (!_solo) {
                    _solo = true;
                  }
                }),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _solo ? blue : orange,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.all(20),
                  child: SvgPicture.asset(
                    'images/profile.svg',
                    color: white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  if (_solo) {
                    _solo = false;
                  }
                }),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _solo ? orange : blue,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.all(15),
                  child: SvgPicture.asset(
                    'images/group.svg',
                    color: white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: _solo ? SearchSolo() : SearchGroup(),
        ),
      ],
    );
  }
}
