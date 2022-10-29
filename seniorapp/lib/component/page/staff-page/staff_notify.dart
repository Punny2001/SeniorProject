import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class StaffNotify extends StatefulWidget {
  const StaffNotify({Key key}) : super(key: key);

  @override
  State<StaffNotify> createState() => _StaffNotifyState();
}

class _StaffNotifyState extends State<StaffNotify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('This is notifications page.'),
    );
  }
}
