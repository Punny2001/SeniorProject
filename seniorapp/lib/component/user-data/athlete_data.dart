import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class Athlete {
  final String athlete_no;
  final String username;
  final String firstname;
  final String lastname;
  final String sportType;
  final DateTime birthdate;
  final String department;
  final double weight;
  final double height;
  final String email;
  Athlete({
    this.athlete_no,
    this.username,
    this.firstname,
    this.lastname,
    this.sportType,
    this.birthdate,
    this.department,
    this.weight,
    this.height,
    this.email,
  });

  Athlete copyWith(
      {String athlete_no,
      String username,
      String firstname,
      String lastname,
      String sportType,
      DateTime birthdate,
      String department,
      double weight,
      double height,
      String email}) {
    return Athlete(
        athlete_no: athlete_no ?? this.athlete_no,
        username: username ?? this.username,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        sportType: sportType ?? this.sportType,
        birthdate: birthdate ?? this.birthdate,
        department: department ?? this.department,
        weight: weight ?? this.weight,
        height: height ?? this.height,
        email: email ?? this.email);
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'athlete_no': athlete_no});
    result.addAll({'email': email});
    result.addAll({'username': username});
    result.addAll({'firstname': firstname});
    result.addAll({'lastname': lastname});
    result.addAll({'sportType': sportType});
    result.addAll({'birthdate': birthdate});
    result.addAll({'department': department});
    result.addAll({'weight': weight});
    result.addAll({'height': height});

    return result;
  }

  factory Athlete.fromMap(Map<String, dynamic> map) {
    return Athlete(
        athlete_no: map['athlete_no'] ?? '',
        username: map['username'] ?? '',
        firstname: map['firstname'] ?? '',
        lastname: map['lastname'] ?? '',
        sportType: map['sportType'] ?? '',
        birthdate: DateTime.parse(map['birthdate'].toDate().toString()),
        department: map['department'] ?? '',
        weight: map['weight'].toDouble() ?? 0.0,
        height: map['height'].toDouble() ?? 0.0,
        email: map['email'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory Athlete.fromJson(String source) =>
      Athlete.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Athlete(username: $username, firstname: $firstname, lastname: $lastname, sportType: $sportType, birthdate: $birthdate, department: $department, weight: $weight, height: $height)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Athlete &&
        other.athlete_no == athlete_no &&
        other.username == username &&
        other.firstname == firstname &&
        other.lastname == lastname &&
        other.sportType == sportType &&
        other.birthdate == birthdate &&
        other.department == department &&
        other.weight == weight &&
        other.height == height &&
        other.email == email;
  }

  @override
  int get hashCode {
    return athlete_no.hashCode ^
        username.hashCode ^
        firstname.hashCode ^
        lastname.hashCode ^
        sportType.hashCode ^
        birthdate.hashCode ^
        department.hashCode ^
        weight.hashCode ^
        height.hashCode ^
        email.hashCode;
  }
}
