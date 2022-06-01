import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class Staff {
  final String username;
  final String firstname;
  final String lastname;
  final String staffType;
  final DateTime date;
  final String department;
  Staff({
    this.username,
    this.firstname,
    this.lastname,
    this.staffType,
    this.date,
    this.department,
  });

  Staff copyWith({
    String username,
    String firstname,
    String lastname,
    String staffType,
    DateTime date,
    String department,
  }) {
    return Staff(
      username: username ?? this.username,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      staffType: staffType ?? this.staffType,
      date: date ?? this.date,
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
    result.addAll({'date': date});
    result.addAll({'department': department});

    return result;
  }

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      username: map['username'] ?? '',
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      staffType: map['staffType'] ?? '',
      date: DateTime(map['date']),
      department: map['department'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Staff.fromJson(String source) => Staff.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Staff(username: $username, firstname: $firstname, lastname: $lastname, staffType: $staffType, date: $date, department: $department)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Staff &&
        other.username == username &&
        other.firstname == firstname &&
        other.lastname == lastname &&
        other.staffType == staffType &&
        other.date == date &&
        other.department == department;
  }

  @override
  int get hashCode {
    return username.hashCode ^
        firstname.hashCode ^
        lastname.hashCode ^
        staffType.hashCode ^
        date.hashCode ^
        department.hashCode;
  }
}
