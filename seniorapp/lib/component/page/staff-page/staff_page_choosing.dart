import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/auth-component/register.dart';
import 'package:seniorapp/component/page/Staff-page/staff_home.dart';
import 'package:seniorapp/component/page/Staff-page/staff_profile.dart';
import 'package:seniorapp/component/page/staff-page/staff_case.dart';
import 'package:seniorapp/component/page/staff-page/staff_history.dart';
import 'package:seniorapp/component/page/staff-page/staff_notify.dart';

class StaffPageChoosing extends StatefulWidget {
  const StaffPageChoosing({Key key}) : super(key: key);

  @override
  State<StaffPageChoosing> createState() => _StaffPageChoosingState();
}

class _StaffPageChoosingState extends State<StaffPageChoosing> {
  int _selected_idx = 0;
  bool isRegister = false;

  static const List<Widget> _StaffPageList = <Widget>[
    StaffHomePage(),
    StaffReport(),
    StaffCase(),
    StaffNotify(),
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
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            elevation: 0,
            unselectedItemColor: Colors.black,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Colors.blue,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.paste),
                label: 'History',
                backgroundColor: Colors.green
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.cases_outlined),
                label: 'Case',
                backgroundColor: Colors.orange,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notification',
                backgroundColor: Colors.yellow
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: 'Profile',
                backgroundColor: Colors.purple
              ),
            ],
            currentIndex: _selected_idx,
            onTap: _onPageTap,
            selectedItemColor: Colors.redAccent,
            showSelectedLabels: false,
            showUnselectedLabels: false,
          ),
        ),
      ),
    );
  }
}
