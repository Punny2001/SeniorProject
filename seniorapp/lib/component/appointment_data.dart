import 'dart:convert';

import 'package:flutter/material.dart';

class AppointmentData {
  final String caseID;
  final String appointmentNo;
  final DateTime appointDate;
  final String detail;
  final DateTime doDate;
  final String staffUID;
  final String athleteUID;
  final bool appointStatus;
  final DateTime receivedDate;
  final bool receivedStatus;
  final bool staffReadStatus;
  final DateTime staffReadDate;

  AppointmentData({
    @required this.caseID,
    @required this.appointmentNo,
    @required this.appointDate,
    @required this.detail,
    @required this.doDate,
    @required this.staffUID,
    @required this.athleteUID,
    @required this.appointStatus,
    @required this.receivedDate,
    @required this.receivedStatus,
    @required this.staffReadStatus,
    @required this.staffReadDate,
  });

  AppointmentData copyWith({
    String caseID,
    String appointmentNo,
    DateTime appointDate,
    String detail,
    DateTime doDate,
    String staffUID,
    String athleteUID,
    bool appointStatus,
    DateTime receivedDate,
    bool receivedStatus,
    bool staffReadStatus,
    DateTime staffReadDate,
  }) {
    return AppointmentData(
      caseID: caseID ?? this.caseID,
      appointmentNo: appointmentNo ?? this.appointmentNo,
      appointDate: appointDate ?? this.appointDate,
      detail: detail ?? this.detail,
      doDate: doDate ?? this.doDate,
      staffUID: staffUID ?? this.staffUID,
      athleteUID: athleteUID ?? this.athleteUID,
      appointStatus: appointStatus ?? this.appointStatus,
      receivedDate: receivedDate ?? this.receivedDate,
      receivedStatus: receivedStatus ?? this.receivedStatus,
      staffReadStatus: staffReadStatus ?? this.staffReadStatus,
      staffReadDate: staffReadDate ?? this.staffReadDate,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'caseID': caseID});
    result.addAll({'appointmentNo': appointmentNo});
    result.addAll({'appointDate': appointDate});
    result.addAll({'detail': detail});
    result.addAll({'doDate': doDate});
    result.addAll({'staffUID': staffUID});
    result.addAll({'athleteUID': athleteUID});
    result.addAll({'appointStatus': appointStatus});
    result.addAll({'receivedDate': receivedDate});
    result.addAll({'receivedStatus': receivedStatus});
    result.addAll({'staffReadStatus': staffReadStatus});
    result.addAll({'staffReadDate': staffReadDate});

    return result;
  }

  factory AppointmentData.fromMap(Map<String, dynamic> map) {
    return AppointmentData(
        caseID: map['caseID'] ?? '',
        appointmentNo: map['appointmentNo'] ?? '',
        appointDate: DateTime.parse(map['appointDate'].toDate().toString()),
        detail: map['detail'] ?? '',
        doDate: DateTime.parse(map['doDate'].toDate().toString()),
        staffUID: map['staffUID'] ?? '',
        athleteUID: map['athleteUID'] ?? '',
        appointStatus: map['appointStatus'] ?? false,
        receivedDate: DateTime.parse(map['receivedDate'].toDate().toString()),
        receivedStatus: map['receivedStatus'] ?? false,
        staffReadStatus: map['staffReadStatus'] ?? false,
        staffReadDate: DateTime.parse(map['receivedDate'].toDate().toString()));
  }

  String toJson() => json.encode(toMap());

  factory AppointmentData.fromJson(String source) =>
      AppointmentData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppointmentData(caseID: $caseID, appointmentNo: $appointmentNo, appointDate: $appointDate, detail: $detail, doDate: $doDate, staffUID: $staffUID, athleteUID: $athleteUID, appointStatus: $appointStatus, receivedDate: $receivedDate, receivedStatus: $receivedStatus, staffReadStatus: $staffReadStatus, staffReadDate: $staffReadDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppointmentData &&
        other.caseID == caseID &&
        other.appointmentNo == appointmentNo &&
        other.appointDate == appointDate &&
        other.detail == detail &&
        other.doDate == doDate &&
        other.staffUID == staffUID &&
        other.athleteUID == athleteUID &&
        other.appointStatus == appointStatus &&
        other.receivedDate == receivedDate &&
        other.receivedStatus == receivedStatus &&
        other.staffReadStatus == staffReadStatus &&
        other.staffReadDate == staffReadDate;
  }

  @override
  int get hashCode {
    return caseID.hashCode ^
        appointmentNo.hashCode ^
        appointDate.hashCode ^
        detail.hashCode ^
        doDate.hashCode ^
        staffUID.hashCode ^
        athleteUID.hashCode ^
        appointStatus.hashCode ^
        receivedDate.hashCode ^
        receivedStatus.hashCode ^
        staffReadStatus.hashCode ^
        staffReadDate.hashCode;
  }
}
