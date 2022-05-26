import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Staff {
  final String _username;
  final String _firstname;
  final String _lastname;
  final String _staffType;
  final DateTime _date;
  final String _department;

  Staff(this._username, this._firstname, this._lastname, this._date,
      this._department, this._staffType);

  final String _uid = FirebaseAuth.instance.currentUser.uid.toString();
  final String _email = FirebaseAuth.instance.currentUser.email.toString();

  Future<void> staffSetup() async {
    FirebaseFirestore.instance.collection('StaffData').add(
      {
        'uid': _uid,
        'email': _email,
        'username': _username,
        'firstname': _firstname,
        'lastname': _lastname,
        'birthdate': _date,
        'department': _department,
        'staffType': _staffType
      },
    );
  }

  Future<void> userUpdate() async {}
}
