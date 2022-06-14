import 'dart:convert';

class InjuryReportData {
  final String staff_uid;
  final String athlete_no;
  final String report_type;
  final String sport_event;
  final String round_heat_training;
  final DateTime injuryDateTime;
  final String injuredBody;
  final String injuryType;
  final String injuryCause;
  final String no_day;
  
  InjuryReportData({
    this.staff_uid,
    this.athlete_no,
    this.report_type,
    this.sport_event,
    this.round_heat_training,
    this.injuryDateTime,
    this.injuredBody,
    this.injuryType,
    this.injuryCause,
    this.no_day,
  });

  InjuryReportData copyWith({
    String staff_uid,
    String athlete_no,
    String report_type,
    String sport_event,
    String round_heat_training,
    DateTime injuryDateTime,
    String injuredBody,
    String injuryType,
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
      injuredBody: injuredBody ?? this.injuredBody,
      injuryType: injuryType ?? this.injuryType,
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
    result.addAll({'injuredBody': injuredBody});
    result.addAll({'injuryType': injuryType});
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
      injuredBody: map['injuredBody'] ?? '',
      injuryType: map['injuryType'] ?? '',
      injuryCause: map['injuryCause'] ?? '',
      no_day: map['no_day'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory InjuryReportData.fromJson(String source) => InjuryReportData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'InjuryReportData(staff_uid: $staff_uid, athlete_no: $athlete_no, report_type: $report_type, sport_event: $sport_event, round_heat_training: $round_heat_training, injuryDateTime: $injuryDateTime, injuredBody: $injuredBody, injuryType: $injuryType, injuryCause: $injuryCause, no_day: $no_day)';
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
      other.injuredBody == injuredBody &&
      other.injuryType == injuryType &&
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
      injuredBody.hashCode ^
      injuryType.hashCode ^
      injuryCause.hashCode ^
      no_day.hashCode;
  }
}
