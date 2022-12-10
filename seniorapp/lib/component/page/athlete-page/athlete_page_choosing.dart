import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_history.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_home.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_profile.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_search.dart';

class AthletePageChoosing extends StatefulWidget {
  const AthletePageChoosing({Key key}) : super(key: key);

  @override
  State<AthletePageChoosing> createState() => _AthletePageChoosingState();
}

class _AthletePageChoosingState extends State<AthletePageChoosing> {
  int _selected_idx = 0;
  int notificationCount = 1;

  static const List<Widget> _athletePageList = <Widget>[
    AthleteHomePage(),
    AthleteSearch(),
    AthleteHistory(),
  ];

  void _onPageTap(int index) {
    setState(() {
      _selected_idx = index;
    });
  }

  void initState() {
    super.initState();
    setState(() {});
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        primary: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Ink(
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                color: Colors.green.shade300,
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pushNamed('/athleteProfile');
                  });
                },
                icon: Icon(Icons.menu),
              ),
            ),
            Ink(
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                color: Colors.green.shade300,
              ),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        Navigator.of(context)
                            .pushNamed(
                              '/athleteNotification',
                            )
                            .then((_) => setState(() {}));
                      });
                    },
                    icon: Icon(Icons.notifications_none),
                  ),
                  Badge(
                    badgeContent: Text(
                      ' ',
                      style: TextStyle(color: Colors.white),
                    ),
                    elevation: 0,
                    showBadge: notificationCount > 0 ? true : false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: _athletePageList.elementAt(_selected_idx),
      ),
      bottomNavigationBar: Container(
        // padding: EdgeInsets.only(top: h * 0.01),

        child: ClipRRect(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.green.shade300,
            unselectedItemColor: Colors.black,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_off),
                activeIcon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history_toggle_off),
                activeIcon: Icon(Icons.history),
                label: 'History',
              ),
            ],
            currentIndex: _selected_idx,
            onTap: _onPageTap,
            selectedItemColor: Colors.black,
            showUnselectedLabels: false,

            // selectedLabelStyle: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
