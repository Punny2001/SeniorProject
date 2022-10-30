import 'dart:convert';

import 'package:flutter/foundation.dart';

class HealthResultData {
  String questionnaireNo;
  String athleteNo;
  String questionnaireType;
  DateTime doDate;
  int totalPoint;
  Map<String, int> answerList;
  String healthSymptom;

  HealthResultData({
    @required this.questionnaireNo,
    @required this.athleteNo,
    @required this.questionnaireType,
    @required this.doDate,
    @required this.totalPoint,
    @required this.answerList,
    @required this.healthSymptom,
  });

  HealthResultData copyWith({
    String questionnaireNo,
    String athleteNo,
    String questionnaireType,
    DateTime doDate,
    int totalPoint,
    Map<String, int> answerList,
    String healthSymptom,
  }) {
    return HealthResultData(
      questionnaireNo: questionnaireNo ?? this.questionnaireNo,
      athleteNo: athleteNo ?? this.athleteNo,
      questionnaireType: questionnaireType ?? this.questionnaireType,
      doDate: doDate ?? this.doDate,
      totalPoint: totalPoint ?? this.totalPoint,
      answerList: answerList ?? this.answerList,
      healthSymptom: healthSymptom ?? this.healthSymptom,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'questionnaireNo': questionnaireNo});
    result.addAll({'athleteNo': athleteNo});
    result.addAll({'questionnaireType': questionnaireType});
    result.addAll({'doDate': doDate});
    result.addAll({'totalPoint': totalPoint});
    result.addAll({'answerList': answerList});
    result.addAll({'healthSymptom': healthSymptom});

    return result;
  }

  factory HealthResultData.fromMap(Map<String, dynamic> map) {
    return HealthResultData(
      questionnaireNo: map['questionnaireNo'] ?? '',
      athleteNo: map['athleteNo'] ?? '',
      questionnaireType: map['questionnaireType'] ?? '',
      doDate: DateTime.parse(map['doDate'].toDate().toString()),
      totalPoint: map['totalPoint']?.toInt() ?? 0,
      answerList: Map<String, int>.from(map['answerList']),
      healthSymptom: map['healthSymptom'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory HealthResultData.fromJson(String source) =>
      HealthResultData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HealthResultData(athleteNo: $athleteNo, questionnaireType: $questionnaireType, doDate: $doDate, totalPoint: $totalPoint, answerList: $answerList, healthSymptom: $healthSymptom)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HealthResultData &&
        other.questionnaireNo == questionnaireNo &&
        other.athleteNo == athleteNo &&
        other.questionnaireType == questionnaireType &&
        other.doDate == doDate &&
        other.totalPoint == totalPoint &&
        mapEquals(other.answerList, answerList) &&
        other.healthSymptom == healthSymptom;
  }

  @override
  int get hashCode {
    return questionnaireNo.hashCode ^
        athleteNo.hashCode ^
        questionnaireType.hashCode ^
        doDate.hashCode ^
        totalPoint.hashCode ^
        answerList.hashCode ^
        healthSymptom.hashCode;
  }
}
