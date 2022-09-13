import 'dart:convert';

import 'package:flutter/foundation.dart';

class IllnessReportData {
  final String staff_uid;
  final String athlete_no;
  final String report_type;
  final String sport_event;
  final String diagnosis;
  final DateTime occured_date;
  final String affected_system;
  final int affected_system_code;
  final List<String> mainSymptoms;
  final List<int> mainSymptomsCode;
  final String illness_cause;
  final int illness_cause_code;
  final String no_day;
  final DateTime doDate;
  IllnessReportData({
    @required this.staff_uid,
    @required this.athlete_no,
    @required this.report_type,
    @required this.sport_event,
    @required this.diagnosis,
    @required this.occured_date,
    @required this.affected_system,
    @required this.affected_system_code,
    @required this.mainSymptoms,
    @required this.mainSymptomsCode,
    @required this.illness_cause,
    @required this.illness_cause_code,
    @required this.no_day,
    @required this.doDate,
  });

  IllnessReportData copyWith({
    String staff_uid,
    String athlete_no,
    String report_type,
    String sport_event,
    String diagnosis,
    DateTime occured_date,
    String affected_system,
    int affected_system_code,
    List<String> mainSymptoms,
    List<int> mainSymptomsCode,
    String illness_cause,
    int illness_cause_code,
    String no_day,
    DateTime doDate,
  }) {
    return IllnessReportData(
      staff_uid: staff_uid ?? this.staff_uid,
      athlete_no: athlete_no ?? this.athlete_no,
      report_type: report_type ?? this.report_type,
      sport_event: sport_event ?? this.sport_event,
      diagnosis: diagnosis ?? this.diagnosis,
      occured_date: occured_date ?? this.occured_date,
      affected_system: affected_system ?? this.affected_system,
      affected_system_code: affected_system_code ?? this.affected_system_code,
      mainSymptoms: mainSymptoms ?? this.mainSymptoms,
      mainSymptomsCode: mainSymptomsCode ?? this.mainSymptomsCode,
      illness_cause: illness_cause ?? this.illness_cause,
      illness_cause_code: illness_cause_code ?? this.illness_cause_code,
      no_day: no_day ?? this.no_day,
      doDate: doDate ?? this.doDate,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'staff_uid': staff_uid});
    result.addAll({'athlete_no': athlete_no});
    result.addAll({'report_type': report_type});
    result.addAll({'sport_event': sport_event});
    result.addAll({'diagnosis': diagnosis});
    result.addAll({'occured_date': occured_date});
    result.addAll({'affected_system': affected_system});
    result.addAll({'affected_system_code': affected_system_code});
    result.addAll({'mainSymptoms': mainSymptoms});
    result.addAll({'mainSymptomsCode': mainSymptomsCode});
    result.addAll({'illness_cause': illness_cause});
    result.addAll({'illness_cause_code': illness_cause_code});
    result.addAll({'no_day': no_day});
    result.addAll({'doDate': doDate});

    return result;
  }

  factory IllnessReportData.fromMap(Map<String, dynamic> map) {
    return IllnessReportData(
      staff_uid: map['staff_uid'] ?? '',
      athlete_no: map['athlete_no'] ?? '',
      report_type: map['report_type'] ?? '',
      sport_event: map['sport_event'] ?? '',
      diagnosis: map['diagnosis'] ?? '',
      occured_date: DateTime.parse(map['occured_date'].toDate().toString()),
      affected_system: map['affected_system'] ?? '',
      affected_system_code: map['affected_system_code']?.toInt() ?? 0,
      mainSymptoms: List<String>.from(map['mainSymptoms']),
      mainSymptomsCode: List<int>.from(map['mainSymptomsCode']),
      illness_cause: map['illness_cause'] ?? '',
      illness_cause_code: map['illness_cause_code']?.toInt() ?? 0,
      no_day: map['no_day'] ?? '',
      doDate: DateTime.parse(map['doDate'].toDate().toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory IllnessReportData.fromJson(String source) =>
      IllnessReportData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'IllnessReportData(staff_uid: $staff_uid, athlete_no: $athlete_no, report_type: $report_type, sport_event: $sport_event, diagnosis: $diagnosis, occured_date: $occured_date, affected_system: $affected_system, affected_system_code: $affected_system_code, mainSymptoms: $mainSymptoms, mainSymptomsCode: $mainSymptomsCode, illness_cause: $illness_cause, illness_cause_code: $illness_cause_code, no_day: $no_day, doDate: $doDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IllnessReportData &&
        other.staff_uid == staff_uid &&
        other.athlete_no == athlete_no &&
        other.report_type == report_type &&
        other.sport_event == sport_event &&
        other.diagnosis == diagnosis &&
        other.occured_date == occured_date &&
        other.affected_system == affected_system &&
        other.affected_system_code == affected_system_code &&
        listEquals(other.mainSymptoms, mainSymptoms) &&
        listEquals(other.mainSymptomsCode, mainSymptomsCode) &&
        other.illness_cause == illness_cause &&
        other.illness_cause_code == illness_cause_code &&
        other.no_day == no_day &&
        other.doDate == doDate;
  }

  @override
  int get hashCode {
    return staff_uid.hashCode ^
        athlete_no.hashCode ^
        report_type.hashCode ^
        sport_event.hashCode ^
        diagnosis.hashCode ^
        occured_date.hashCode ^
        affected_system.hashCode ^
        affected_system_code.hashCode ^
        mainSymptoms.hashCode ^
        mainSymptomsCode.hashCode ^
        illness_cause.hashCode ^
        illness_cause_code.hashCode ^
        no_day.hashCode ^
        doDate.hashCode;
  }
}
