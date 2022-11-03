import 'package:flutter/material.dart';

class AthleteSearch extends StatefulWidget {
  const AthleteSearch({Key key}) : super(key: key);

  @override
  State<AthleteSearch> createState() => _AthleteSearchState();
}

class _AthleteSearchState extends State<AthleteSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text(
          'อยู่ระหว่างการปรับปรุง',
          style: TextStyle(
            fontSize: 50,
            color: Colors.red.shade900,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
