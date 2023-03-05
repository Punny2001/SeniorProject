import 'dart:convert';

import 'package:flutter/material.dart';

class AppointmentData {
  final String apppointmentNo;
  final DateTime appointDate;
  final String detail;
  final DateTime doDate;
  final String staffUID;
  final String athleteUID;
  final bool appointStatus;
  final DateTime receivedDate;
  final bool receivedStatus;

  AppointmentData({
    @required this.apppointmentNo,
    @required this.appointDate,
    @required this.detail,
    @required this.doDate,
    @required this.staffUID,
    @required this.athleteUID,
    @required this.appointStatus,
    @required this.receivedDate,
    @required this.receivedStatus,
  });

  AppointmentData copyWith({
    String apppointmentNo,
    DateTime appointDate,
    String detail,
    DateTime doDate,
    String staffUID,
    String athleteUID,
    bool appointStatus,
    DateTime receivedDate,
    bool receivedStatus,
  }) {
    return AppointmentData(
      apppointmentNo: apppointmentNo ?? this.apppointmentNo,
      appointDate: appointDate ?? this.appointDate,
      detail: detail ?? this.detail,
      doDate: doDate ?? this.doDate,
      staffUID: staffUID ?? this.staffUID,
      athleteUID: athleteUID ?? this.athleteUID,
      appointStatus: appointStatus ?? this.appointStatus,
      receivedDate: receivedDate ?? this.receivedDate,
      receivedStatus: receivedStatus ?? this.receivedStatus,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'apppointmentNo': apppointmentNo});
    result.addAll({'appointDate': appointDate});
    result.addAll({'detail': detail});
    result.addAll({'doDate': doDate});
    result.addAll({'staffUID': staffUID});
    result.addAll({'athleteUID': athleteUID});
    result.addAll({'appointStatus': appointStatus});
    result.addAll({'receivedDate': receivedDate});
    result.addAll({'receivedStatus': receivedStatus});

    return result;
  }

  factory AppointmentData.fromMap(Map<String, dynamic> map) {
    return AppointmentData(
      apppointmentNo: map['apppointmentNo'] ?? '',
      appointDate: DateTime.parse(map['appointDate'].toDate().toString()),
      detail: map['detail'] ?? '',
      doDate: DateTime.parse(map['doDate'].toDate().toString()),
      staffUID: map['staffUID'] ?? '',
      athleteUID: map['athleteUID'] ?? '',
      appointStatus: map['appointStatus'] ?? false,
      receivedDate: DateTime.parse(map['receivedDate'].toDate().toString()),
      receivedStatus: map['receivedStatus'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppointmentData.fromJson(String source) =>
      AppointmentData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppointmentData(apppointmentNo: $apppointmentNo, appointDate: $appointDate, detail: $detail, doDate: $doDate, staffUID: $staffUID, athleteUID: $athleteUID, appointStatus: $appointStatus, receivedDate: $receivedDate, receivedStatus: $receivedStatus)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppointmentData &&
        other.apppointmentNo == apppointmentNo &&
        other.appointDate == appointDate &&
        other.detail == detail &&
        other.doDate == doDate &&
        other.staffUID == staffUID &&
        other.athleteUID == athleteUID &&
        other.appointStatus == appointStatus &&
        other.receivedDate == receivedDate &&
        other.receivedStatus == receivedStatus;
  }

  @override
  int get hashCode {
    return apppointmentNo.hashCode ^
        appointDate.hashCode ^
        detail.hashCode ^
        doDate.hashCode ^
        staffUID.hashCode ^
        athleteUID.hashCode ^
        appointStatus.hashCode ^
        receivedDate.hashCode ^
        receivedStatus.hashCode;
  }
}
