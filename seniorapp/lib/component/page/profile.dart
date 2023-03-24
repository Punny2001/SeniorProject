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
            const Padding(
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
                  const SizedBox(height: 10),

                  Text(
                    widget.athlete.firstname + ' ' + widget.athlete.lastname,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.person,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                      ),
                      Text(
                        widget.athlete.username,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                      ),
                      Text(
                        widget.athlete.department +
                            ' | ' +
                            widget.athlete.sportType,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.email),
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                      ),
                      Text(
                        widget.athlete.email,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.phone),
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                      ),
                      Text(
                        widget.athlete.phoneNo,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
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
                  const SizedBox(height: 10),
                  Text(
                    widget.athlete.firstname + ' ' + widget.athlete.lastname,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.athlete.department + ': ' + widget.athlete.sportType,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    widget.athlete.email,
                    style: const TextStyle(
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
