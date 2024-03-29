import 'dart:convert';

import 'package:flutter/material.dart';

class Staff {
  final String token;
  final String staff_no;
  final String username;
  final String firstname;
  final String lastname;
  final String staffType;
  final DateTime birthdate;
  final String phoneNo;
  final String department;
  final String email;
  final String gender;
  final int age;
  final bool pdpaAgreement;
  final String association;

  Staff({
    @required this.token,
    @required this.staff_no,
    @required this.username,
    @required this.firstname,
    @required this.lastname,
    @required this.staffType,
    @required this.birthdate,
    @required this.phoneNo,
    @required this.department,
    @required this.email,
    @required this.gender,
    @required this.age,
    @required this.pdpaAgreement,
    @required this.association,
  });

  Staff copyWith({
    String token,
    String staff_no,
    String username,
    String firstname,
    String lastname,
    String staffType,
    DateTime birthdate,
    String phoneNo,
    String department,
    String email,
    String gender,
    int age,
    bool pdpaAgreement,
    String association,
  }) {
    return Staff(
      token: token ?? this.token,
      staff_no: staff_no ?? this.staff_no,
      username: username ?? this.username,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      staffType: staffType ?? this.staffType,
      birthdate: birthdate ?? this.birthdate,
      phoneNo: phoneNo ?? this.phoneNo,
      department: department ?? this.department,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      pdpaAgreement: pdpaAgreement ?? this.pdpaAgreement,
      association: association ?? this.association,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'token': token});
    result.addAll({'staff_no': staff_no});
    result.addAll({'username': username});
    result.addAll({'firstname': firstname});
    result.addAll({'lastname': lastname});
    result.addAll({'staffType': staffType});
    result.addAll({'birthdate': birthdate});
    result.addAll({'phoneNo': phoneNo});
    result.addAll({'department': department});
    result.addAll({'email': email});
    result.addAll({'gender': gender});
    result.addAll({'age': age});
    result.addAll({'pdpaAgreement': pdpaAgreement});
    result.addAll({'association': association});

    return result;
  }

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      token: map['token'] ?? '',
      staff_no: map['staff_no'] ?? '',
      username: map['username'] ?? '',
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      staffType: map['staffType'] ?? '',
      birthdate: DateTime.parse(map['birthdate'].toDate().toString()),
      phoneNo: map['phoneNo'] ?? '',
      department: map['department'] ?? '',
      email: map['email'] ?? '',
      gender: map['gender'] ?? '',
      age: map['age']?.toInt() ?? 0,
      pdpaAgreement: map['pdpaAgreement'] ?? false,
      association: map['association'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Staff.fromJson(String source) => Staff.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Staff(token: $token, staff_no: $staff_no, username: $username, firstname: $firstname, lastname: $lastname, staffType: $staffType, birthdate: $birthdate, phoneNo: $phoneNo, department: $department, email: $email, gender: $gender, age: $age, pdpaAgreement: $pdpaAgreement, association: $association)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Staff &&
        other.token == token &&
        other.staff_no == staff_no &&
        other.username == username &&
        other.firstname == firstname &&
        other.lastname == lastname &&
        other.staffType == staffType &&
        other.birthdate == birthdate &&
        other.phoneNo == phoneNo &&
        other.department == department &&
        other.email == email &&
        other.gender == gender &&
        other.age == age &&
        other.pdpaAgreement == pdpaAgreement &&
        other.association == association;
  }

  @override
  int get hashCode {
    return token.hashCode ^
        staff_no.hashCode ^
        username.hashCode ^
        firstname.hashCode ^
        lastname.hashCode ^
        staffType.hashCode ^
        birthdate.hashCode ^
        phoneNo.hashCode ^
        department.hashCode ^
        email.hashCode ^
        gender.hashCode ^
        age.hashCode ^
        pdpaAgreement.hashCode ^
        association.hashCode;
  }
}
