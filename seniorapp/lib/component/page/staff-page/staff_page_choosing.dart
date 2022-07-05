import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/auth-component/register.dart';
import 'package:seniorapp/component/page/Staff-page/staff_home.dart';
import 'package:seniorapp/component/page/Staff-page/staff_profile.dart';

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
    null,
    StaffProfile(),
  ];

  void _onPageTap(int index) {
    setState(() {
      _selected_idx = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    checkRegister();
    return isRegister ? Scaffold(
      body: Container(
        child: _StaffPageList.elementAt(_selected_idx),
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
    ) : Register();
  }

  void checkRegister() {
    String username = FirebaseAuth.instance.currentUser.displayName;
    if (username == null) {
      isRegister = false;
    }
    else {
      isRegister = true;
    }
  }
}
