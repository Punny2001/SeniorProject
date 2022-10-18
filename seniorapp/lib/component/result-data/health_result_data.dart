import 'dart:convert';

import 'package:flutter/foundation.dart';

class HealthResultData {
  String questionnaireNo;
  String athleteNo;
  String questionaireType;
  DateTime doDate;
  int totalPoint;
  Map<String, int> answerList;
  String healthSymptom;

  HealthResultData({
    @required this.questionnaireNo,
    @required this.athleteNo,
    @required this.questionaireType,
    @required this.doDate,
    @required this.totalPoint,
    @required this.answerList,
    @required this.healthSymptom,
  });

  HealthResultData copyWith({
    String questionnaireNo,
    String athleteNo,
    String questionaireType,
    DateTime doDate,
    int totalPoint,
    Map<String, int> answerList,
    String healthSymptom,
  }) {
    return HealthResultData(
      questionnaireNo: questionnaireNo ?? this.questionnaireNo,
      athleteNo: athleteNo ?? this.athleteNo,
      questionaireType: questionaireType ?? this.questionaireType,
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
    result.addAll({'questionaireType': questionaireType});
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
      questionaireType: map['questionaireType'] ?? '',
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
    return 'HealthResultData(athleteNo: $athleteNo, questionaireType: $questionaireType, doDate: $doDate, totalPoint: $totalPoint, answerList: $answerList, healthSymptom: $healthSymptom)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HealthResultData &&
        other.questionnaireNo == questionnaireNo &&
        other.athleteNo == athleteNo &&
        other.questionaireType == questionaireType &&
        other.doDate == doDate &&
        other.totalPoint == totalPoint &&
        mapEquals(other.answerList, answerList) &&
        other.healthSymptom == healthSymptom;
  }

  @override
  int get hashCode {
    return questionnaireNo.hashCode ^
        athleteNo.hashCode ^
        questionaireType.hashCode ^
        doDate.hashCode ^
        totalPoint.hashCode ^
        answerList.hashCode ^
        healthSymptom.hashCode;
  }
}
