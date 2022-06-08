import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class Athlete {
  final String username;
  final String firstname;
  final String lastname;
  final String sportType;
  final DateTime date;
  final String department;
  final double weight;
  final double height;
  Athlete({
    this.username,
    this.firstname,
    this.lastname,
    this.sportType,
    this.date,
    this.department,
    this.weight,
    this.height,
  });

  Athlete copyWith({
    String username,
    String firstname,
    String lastname,
    String sportType,
    DateTime date,
    String department,
    double weight,
    double height,
  }) {
    return Athlete(
      username: username ?? this.username,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      sportType: sportType ?? this.sportType,
      date: date ?? this.date,
      department: department ?? this.department,
      weight: weight ?? this.weight,
      height: height ?? this.height,
    );
  }

  final String email = FirebaseAuth.instance.currentUser.email.toString();

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'email': email});
    result.addAll({'username': username});
    result.addAll({'firstname': firstname});
    result.addAll({'lastname': lastname});
    result.addAll({'sportType': sportType});
    result.addAll({'date': date});
    result.addAll({'department': department});
    result.addAll({'weight': weight});
    result.addAll({'height': height});

    return result;
  }

  factory Athlete.fromMap(Map<String, dynamic> map) {
    return Athlete(
      username: map['username'] ?? '',
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      sportType: map['sportType'] ?? '',
      date: DateTime.parse(map['date'].toDate().toString()),
      department: map['department'] ?? '',
      weight: map['weight'].toDouble() ?? 0.0,
      height: map['height'].toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Athlete.fromJson(String source) =>
      Athlete.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Athlete(username: $username, firstname: $firstname, lastname: $lastname, sportType: $sportType, date: $date, department: $department, weight: $weight, height: $height)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Athlete &&
        other.username == username &&
        other.firstname == firstname &&
        other.lastname == lastname &&
        other.sportType == sportType &&
        other.date == date &&
        other.department == department &&
        other.weight == weight &&
        other.height == height;
  }

  @override
  int get hashCode {
    return username.hashCode ^
        firstname.hashCode ^
        lastname.hashCode ^
        sportType.hashCode ^
        date.hashCode ^
        department.hashCode ^
        weight.hashCode ^
        height.hashCode;
  }
}
