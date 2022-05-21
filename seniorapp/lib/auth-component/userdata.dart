import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypt/crypt.dart';

Future<void> userSetup(final String _username, final String _firstname,
    final String _lastname, final String _sportType) {
  FirebaseAuth auth = FirebaseAuth.instance;
  final String _uid = auth.currentUser.uid.toString();
  final String _email = auth.currentUser.email.toString();

  FirebaseFirestore.instance.collection('UserData').add(
    {
      'uid': _uid,
      'email': _email,
      'username': _username,
      'firstname': _firstname,
      'lastname': _lastname,
      'sportType': _sportType
    },
  );
}
