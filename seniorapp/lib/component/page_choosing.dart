import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/home.dart';
import 'package:seniorapp/component/page/profile.dart';

class PageChoosing extends StatefulWidget {
  const PageChoosing({Key key}) : super(key: key);

  @override
  State<PageChoosing> createState() => _PageChoosingState();
}

class _PageChoosingState extends State<PageChoosing> {
  int _selected_idx = 1;

  static const List<Widget> _pageList = <Widget>[
    HomePage(),
    HomePage(),
    Profile(),
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
        child: _pageList.elementAt(_selected_idx),
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
