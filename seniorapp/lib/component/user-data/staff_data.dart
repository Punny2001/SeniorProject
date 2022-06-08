import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class Staff {
  final String username;
  final String firstname;
  final String lastname;
  final String staffType;
  final DateTime birthdate;
  final String department;
  Staff({
    this.username,
    this.firstname,
    this.lastname,
    this.staffType,
    this.birthdate,
    this.department,
  });

  Staff copyWith({
    String username,
    String firstname,
    String lastname,
    String staffType,
    DateTime birthdate,
    String department,
  }) {
    return Staff(
      username: username ?? this.username,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      staffType: staffType ?? this.staffType,
      birthdate: birthdate ?? this.birthdate,
      department: department ?? this.department,
    );
  }

  final String email = FirebaseAuth.instance.currentUser.email.toString();
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'email': email});
    result.addAll({'username': username});
    result.addAll({'firstname': firstname});
    result.addAll({'lastname': lastname});
    result.addAll({'staffType': staffType});
    result.addAll({'date': birthdate});
    result.addAll({'department': department});

    return result;
  }

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      username: map['username'] ?? '',
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      staffType: map['staffType'] ?? '',
      birthdate: DateTime.parse(map['date'].toDate().toString()),
      department: map['department'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Staff.fromJson(String source) => Staff.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Staff(username: $username, firstname: $firstname, lastname: $lastname, staffType: $staffType, date: $birthdate, department: $department)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Staff &&
        other.username == username &&
        other.firstname == firstname &&
        other.lastname == lastname &&
        other.staffType == staffType &&
        other.birthdate == birthdate &&
        other.department == department;
  }

  @override
  int get hashCode {
    return username.hashCode ^
        firstname.hashCode ^
        lastname.hashCode ^
        staffType.hashCode ^
        birthdate.hashCode ^
        department.hashCode;
  }
}
