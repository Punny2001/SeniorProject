import 'dart:convert';

class UserData {
  final String username;
  final String firstname;
  final String lastname;
  final String staffType;
  final DateTime date;
  final String department;
  final double weight;
  final double height;
  UserData({
    this.username,
    this.firstname,
    this.lastname,
    this.staffType,
    this.date,
    this.department,
    this.weight,
    this.height,
  });

  UserData copyWith({
    String username,
    String firstname,
    String lastname,
    String staffType,
    DateTime date,
    String department,
    double weight,
    double height,
  }) {
    return UserData(
      username: username ?? this.username,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      staffType: staffType ?? this.staffType,
      date: date ?? this.date,
      department: department ?? this.department,
      weight: weight ?? this.weight,
      height: height ?? this.height,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'username': username});
    result.addAll({'firstname': firstname});
    result.addAll({'lastname': lastname});
    result.addAll({'staffType': staffType});
    result.addAll({'date': date.millisecondsSinceEpoch});
    result.addAll({'department': department});
    result.addAll({'weight': weight});
    result.addAll({'height': height});

    return result;
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      username: map['username'] ?? '',
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      staffType: map['staffType'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      department: map['department'] ?? '',
      weight: map['weight']?.toDouble() ?? 0.0,
      height: map['height']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) =>
      UserData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserData(username: $username, firstname: $firstname, lastname: $lastname, staffType: $staffType, date: $date, department: $department, weight: $weight, height: $height)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserData &&
        other.username == username &&
        other.firstname == firstname &&
        other.lastname == lastname &&
        other.staffType == staffType &&
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
        staffType.hashCode ^
        date.hashCode ^
        department.hashCode ^
        weight.hashCode ^
        height.hashCode;
  }
}
