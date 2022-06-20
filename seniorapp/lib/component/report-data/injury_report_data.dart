import 'dart:convert';

import 'package:flutter/foundation.dart';

class InjuryReportData {
  final String staff_uid;
  final String athlete_no;
  final String report_type;
  final String sport_event;
  final String round_heat_training;
  final DateTime injuryDateTime;
  final int injuredBodyCode;
  final String injuredBody;
  final int injuredTypeCode;
  final String injuryType;
  final int injuryCauseCode;
  final String injuryCause;
  final String no_day;
  
  InjuryReportData({
    @required this.staff_uid,
    @required this.athlete_no,
    @required this.report_type,
    @required this.sport_event,
    @required this.round_heat_training,
    @required this.injuryDateTime,
    @required this.injuredBodyCode,
    @required this.injuredBody,
    @required this.injuredTypeCode,
    @required this.injuryType,
    @required this.injuryCauseCode,
    @required this.injuryCause,
    @required this.no_day,
  });

  InjuryReportData copyWith({
    String staff_uid,
    String athlete_no,
    String report_type,
    String sport_event,
    String round_heat_training,
    DateTime injuryDateTime,
    int injuredBodyCode,
    String injuredBody,
    int injuredTypeCode,
    String injuryType,
    int injuryCauseCode,
    String injuryCause,
    String no_day,
  }) {
    return InjuryReportData(
      staff_uid: staff_uid ?? this.staff_uid,
      athlete_no: athlete_no ?? this.athlete_no,
      report_type: report_type ?? this.report_type,
      sport_event: sport_event ?? this.sport_event,
      round_heat_training: round_heat_training ?? this.round_heat_training,
      injuryDateTime: injuryDateTime ?? this.injuryDateTime,
      injuredBodyCode: injuredBodyCode ?? this.injuredBodyCode,
      injuredBody: injuredBody ?? this.injuredBody,
      injuredTypeCode: injuredTypeCode ?? this.injuredTypeCode,
      injuryType: injuryType ?? this.injuryType,
      injuryCauseCode: injuryCauseCode ?? this.injuryCauseCode,
      injuryCause: injuryCause ?? this.injuryCause,
      no_day: no_day ?? this.no_day,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'staff_uid': staff_uid});
    result.addAll({'athlete_no': athlete_no});
    result.addAll({'report_type': report_type});
    result.addAll({'sport_event': sport_event});
    result.addAll({'round_heat_training': round_heat_training});
    result.addAll({'injuryDateTime': injuryDateTime});
    result.addAll({'injuredBodyCode': injuredBodyCode});
    result.addAll({'injuredBody': injuredBody});
    result.addAll({'injuredTypeCode': injuredTypeCode});
    result.addAll({'injuryType': injuryType});
    result.addAll({'injuryCauseCode': injuryCauseCode});
    result.addAll({'injuryCause': injuryCause});
    result.addAll({'no_day': no_day});

    return result;
  }

  factory InjuryReportData.fromMap(Map<String, dynamic> map) {
    return InjuryReportData(
      staff_uid: map['staff_uid'] ?? '',
      athlete_no: map['athlete_no'] ?? '',
      report_type: map['report_type'] ?? '',
      sport_event: map['sport_event'] ?? '',
      round_heat_training: map['round_heat_training'] ?? '',
      injuryDateTime: DateTime.parse(map['injuryDateTime'].toDate().toString()),
      injuredBodyCode: map['injuredBodyCode']?.toInt() ?? 0,
      injuredBody: map['injuredBody'] ?? '',
      injuredTypeCode: map['injuredTypeCode']?.toInt() ?? 0,
      injuryType: map['injuryType'] ?? '',
      injuryCauseCode: map['injuryCauseCode']?.toInt() ?? 0,
      injuryCause: map['injuryCause'] ?? '',
      no_day: map['no_day'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory InjuryReportData.fromJson(String source) =>
      InjuryReportData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'InjuryReportData(staff_uid: $staff_uid, athlete_no: $athlete_no, report_type: $report_type, sport_event: $sport_event, round_heat_training: $round_heat_training, injuryDateTime: $injuryDateTime, injuredBodyCode: $injuredBodyCode, injuredBody: $injuredBody, injuredTypeCode: $injuredTypeCode, injuryType: $injuryType, injuryCauseCode: $injuryCauseCode, injuryCause: $injuryCause, no_day: $no_day)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InjuryReportData &&
        other.staff_uid == staff_uid &&
        other.athlete_no == athlete_no &&
        other.report_type == report_type &&
        other.sport_event == sport_event &&
        other.round_heat_training == round_heat_training &&
        other.injuryDateTime == injuryDateTime &&
        other.injuredBodyCode == injuredBodyCode &&
        other.injuredBody == injuredBody &&
        other.injuredTypeCode == injuredTypeCode &&
        other.injuryType == injuryType &&
        other.injuryCauseCode == injuryCauseCode &&
        other.injuryCause == injuryCause &&
        other.no_day == no_day;
  }

  @override
  int get hashCode {
    return staff_uid.hashCode ^
        athlete_no.hashCode ^
        report_type.hashCode ^
        sport_event.hashCode ^
        round_heat_training.hashCode ^
        injuryDateTime.hashCode ^
        injuredBodyCode.hashCode ^
        injuredBody.hashCode ^
        injuredTypeCode.hashCode ^
        injuryType.hashCode ^
        injuryCauseCode.hashCode ^
        injuryCause.hashCode ^
        no_day.hashCode;
  }
}
