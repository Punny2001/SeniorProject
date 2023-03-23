import 'package:flutter/material.dart';

import 'package:seniorapp/component/user-data/athlete_data.dart';
import 'package:seniorapp/component/user-data/staff_data.dart';
import 'package:seniorapp/decoration/padding.dart';

class ProfilePage extends StatefulWidget {
  final Athlete athlete;
  final Staff staff;
  const ProfilePage({
    Key key,
    this.athlete,
    this.staff,
  }) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        primary: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Ink(
              decoration: ShapeDecoration(
                shape: const CircleBorder(),
                color: widget.athlete != null
                    ? Colors.green[300]
                    : Colors.blue[200],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                alignment: Alignment.centerRight,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
            ),
            Text(widget.athlete.athlete_no),
          ],
        ),
      ),
      body: widget.athlete != null
          ? SizedBox(
              width: w,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // CircleAvatar(
                  //   radius: 50,
                  //   backgroundImage: NetworkImage(
                  //     'https://www.example.com/profile.jpg',
                  //   ),
                  // ),
                  SizedBox(height: 10),

                  Text(
                    widget.athlete.firstname + ' ' + widget.athlete.lastname,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                      ),
                      Text(
                        widget.athlete.username,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                      ),
                      Text(
                        widget.athlete.department +
                            ' | ' +
                            widget.athlete.sportType,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.athlete.email,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.athlete.phoneNo,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : SizedBox(
              width: w,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // CircleAvatar(
                  //   radius: 50,
                  //   backgroundImage: NetworkImage(
                  //     'https://www.example.com/profile.jpg',
                  //   ),
                  // ),
                  SizedBox(height: 10),
                  Text(
                    widget.athlete.firstname + ' ' + widget.athlete.lastname,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.athlete.department + ': ' + widget.athlete.sportType,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 10),

                  Text(
                    widget.athlete.email,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
