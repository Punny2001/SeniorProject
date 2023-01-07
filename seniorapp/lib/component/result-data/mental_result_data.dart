import 'dart:convert';

import 'package:flutter/foundation.dart';

class MentalResultData {
  String questionnaireNo;
  String athleteUID;
  String athleteNo;
  String questionnaireType;
  DateTime doDate;
  int totalPoint;
  Map<String, int> answerList;
  bool caseReceived;
  String staff_no_received;
  String staff_uid_received;
  bool caseFinished;
  MentalResultData({
    @required this.questionnaireNo,
    @required this.athleteUID,
    @required this.athleteNo,
    @required this.questionnaireType,
    @required this.doDate,
    @required this.totalPoint,
    @required this.answerList,
    @required this.caseReceived,
    this.staff_no_received,
    this.staff_uid_received,
    @required this.caseFinished,
  });

  MentalResultData copyWith({
    String questionnaireNo,
    String athleteUID,
    String athleteNo,
    String questionnaireType,
    DateTime doDate,
    int totalPoint,
    Map<String, int> answerList,
    bool caseReceived,
    String staff_no_received,
    String staff_uid_received,
    bool caseFinished,
  }) {
    return MentalResultData(
      questionnaireNo: questionnaireNo ?? this.questionnaireNo,
      athleteUID: athleteUID ?? this.athleteUID,
      athleteNo: athleteNo ?? this.athleteNo,
      questionnaireType: questionnaireType ?? this.questionnaireType,
      doDate: doDate ?? this.doDate,
      totalPoint: totalPoint ?? this.totalPoint,
      answerList: answerList ?? this.answerList,
      caseReceived: caseReceived ?? this.caseReceived,
      staff_no_received: staff_no_received ?? this.staff_no_received,
      staff_uid_received: staff_uid_received ?? this.staff_uid_received,
      caseFinished: caseFinished ?? this.caseFinished,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'questionnaireNo': questionnaireNo});
    result.addAll({'athleteUID': athleteUID});
    result.addAll({'athleteNo': athleteNo});
    result.addAll({'questionnaireType': questionnaireType});
    result.addAll({'doDate': doDate});
    result.addAll({'totalPoint': totalPoint});
    result.addAll({'answerList': answerList});
    result.addAll({'caseReceived': caseReceived});
    result.addAll({'staff_no_received': staff_no_received});
    result.addAll({'staff_uid_received': staff_uid_received});
    result.addAll({'caseFinished': caseFinished});

    return result;
  }

  factory MentalResultData.fromMap(Map<String, dynamic> map) {
    return MentalResultData(
      questionnaireNo: map['questionnaireNo'] ?? '',
      athleteUID: map['athleteUID'] ?? '',
      athleteNo: map['athleteNo'] ?? '',
      questionnaireType: map['questionnaireType'] ?? '',
      doDate: DateTime.parse(map['doDate'].toDate().toString()),
      totalPoint: map['totalPoint']?.toInt() ?? 0,
      answerList: Map<String, int>.from(map['answerList']),
      caseReceived: map['caseReceived'] ?? false,
      staff_no_received: map['staff_no_received'] ?? '',
      staff_uid_received: map['staff_uid_received'] ?? '',
      caseFinished: map['caseFinished'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory MentalResultData.fromJson(String source) =>
      MentalResultData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MentalResultData(questionnaireNo: $questionnaireNo, athleteUID: $athleteUID, athleteNo: $athleteNo, questionnaireType: $questionnaireType, doDate: $doDate, totalPoint: $totalPoint, answerList: $answerList, caseReceived: $caseReceived, staff_no_received: $staff_no_received, staff_uid_received: $staff_uid_received, caseFinished: $caseFinished)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MentalResultData &&
        other.questionnaireNo == questionnaireNo &&
        other.athleteUID == athleteUID &&
        other.athleteNo == athleteNo &&
        other.questionnaireType == questionnaireType &&
        other.doDate == doDate &&
        other.totalPoint == totalPoint &&
        mapEquals(other.answerList, answerList) &&
        other.caseReceived == caseReceived &&
        other.staff_no_received == staff_no_received &&
        other.staff_uid_received == staff_uid_received &&
        other.caseFinished == caseFinished;
  }

  @override
  int get hashCode {
    return questionnaireNo.hashCode ^
        athleteUID.hashCode ^
        athleteNo.hashCode ^
        questionnaireType.hashCode ^
        doDate.hashCode ^
        totalPoint.hashCode ^
        answerList.hashCode ^
        caseReceived.hashCode ^
        staff_no_received.hashCode ^
        staff_uid_received.hashCode ^
        caseFinished.hashCode;
  }
}
