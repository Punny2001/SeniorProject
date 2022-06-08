import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_home.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_profile.dart';

class AthletePageChoosing extends StatefulWidget {
  const AthletePageChoosing({Key key}) : super(key: key);

  @override
  State<AthletePageChoosing> createState() => _AthletePageChoosingState();
}

class _AthletePageChoosingState extends State<AthletePageChoosing> {
  int _selected_idx = 0;

  static const List<Widget> _athletePageList = <Widget>[
    AthleteHomePage(),
    AthleteHomePage(),
    AthleteProfile(),
  ];

  void _onPageTap(int index) {
    setState(() {
      _selected_idx = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _athletePageList.elementAt(_selected_idx),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Profile',
          ),
        ],
        currentIndex: _selected_idx,
        onTap: _onPageTap,
        selectedItemColor: Colors.redAccent,
      ),
    );
  }
}
