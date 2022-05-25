import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Athlete {
  final String _username;
  final String _firstname;
  final String _lastname;
  final String _sportType;
  final DateTime _date;
  final String _department;

  Athlete(this._username, this._firstname, this._lastname, this._date,
      this._department, this._sportType);

  final String _uid = FirebaseAuth.instance.currentUser.uid.toString();
  final String _email = FirebaseAuth.instance.currentUser.email.toString();

  Future<void> atheleSetup() async {
    FirebaseFirestore.instance.collection('AthleteData').add(
      {
        'uid': _uid,
        'email': _email,
        'username': _username,
        'firstname': _firstname,
        'lastname': _lastname,
        'birthdate': _date,
        'department': _department,
        'sportType': _sportType
      },
    );
  }

  Future<void> userUpdate() async {}
}
