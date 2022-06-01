import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/Staff-page/home.dart';
import 'package:seniorapp/component/page/Staff-page/profile.dart';

class StaffPageChoosing extends StatefulWidget {
  const StaffPageChoosing({Key key}) : super(key: key);

  @override
  State<StaffPageChoosing> createState() => _StaffPageChoosingState();
}

class _StaffPageChoosingState extends State<StaffPageChoosing> {
  int _selected_idx = 1;

  static const List<Widget> _StaffPageList = <Widget>[
    StaffHomePage(),
    StaffHomePage(),
    StaffProfile(),
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
        child: _StaffPageList.elementAt(_selected_idx),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
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
