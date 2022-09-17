import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Staff {
  final String staff_no;
  final String username;
  final String firstname;
  final String lastname;
  final String staffType;
  final DateTime birthdate;
  final String department;
  final String email;
  final String gender;
  final int age;
  Staff({
    @required this.staff_no,
    @required this.username,
    @required this.firstname,
    @required this.lastname,
    @required this.staffType,
    @required this.birthdate,
    @required this.department,
    @required this.email,
    @required this.gender,
    @required this.age,
  });

  Staff copyWith({
    String staff_no,
    String username,
    String firstname,
    String lastname,
    String staffType,
    DateTime birthdate,
    String department,
    String email,
    String gender,
    int age,
  }) {
    return Staff(
      staff_no: staff_no ?? this.staff_no,
      username: username ?? this.username,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      staffType: staffType ?? this.staffType,
      birthdate: birthdate ?? this.birthdate,
      department: department ?? this.department,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      age: age ?? this.age,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'staff_no': staff_no});
    result.addAll({'username': username});
    result.addAll({'firstname': firstname});
    result.addAll({'lastname': lastname});
    result.addAll({'staffType': staffType});
    result.addAll({'birthdate': birthdate});
    result.addAll({'department': department});
    result.addAll({'email': email});
    result.addAll({'gender': gender});
    result.addAll({'age': age});

    return result;
  }

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      staff_no: map['staff_no'] ?? '',
      username: map['username'] ?? '',
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      staffType: map['staffType'] ?? '',
      birthdate: DateTime.parse(map['birthdate'].toDate().toString()),
      department: map['department'] ?? '',
      email: map['email'] ?? '',
      gender: map['gender'] ?? '',
      age: map['age']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Staff.fromJson(String source) => Staff.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Staff(staff_no: $staff_no, username: $username, firstname: $firstname, lastname: $lastname, staffType: $staffType, birthdate: $birthdate, department: $department, email: $email, gender: $gender, age: $age)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Staff &&
        other.staff_no == staff_no &&
        other.username == username &&
        other.firstname == firstname &&
        other.lastname == lastname &&
        other.staffType == staffType &&
        other.birthdate == birthdate &&
        other.department == department &&
        other.email == email &&
        other.gender == gender &&
        other.age == age;
  }

  @override
  int get hashCode {
    return staff_no.hashCode ^
        username.hashCode ^
        firstname.hashCode ^
        lastname.hashCode ^
        staffType.hashCode ^
        birthdate.hashCode ^
        department.hashCode ^
        email.hashCode ^
        gender.hashCode ^
        age.hashCode;
  }
}
