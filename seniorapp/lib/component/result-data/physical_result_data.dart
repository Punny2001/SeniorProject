import 'dart:convert';

import 'package:flutter/foundation.dart';

class PhysicalResultData {
  String questionnaireNo;
  String athleteNo;
  String questionnaireType;
  DateTime doDate;
  int totalPoint;
  Map<String, int> answerList;
  String bodyPart;

  PhysicalResultData({
    @required this.questionnaireNo,
    @required this.athleteNo,
    @required this.questionnaireType,
    @required this.doDate,
    @required this.totalPoint,
    @required this.answerList,
    @required this.bodyPart,
  });

  PhysicalResultData copyWith({
    String questionnaireNo,
    String athleteNo,
    String questionnaireType,
    DateTime doDate,
    int totalPoint,
    Map<String, int> answerList,
    String bodyPart,
  }) {
    return PhysicalResultData(
      questionnaireNo: questionnaireNo ?? this.questionnaireNo,
      athleteNo: athleteNo ?? this.athleteNo,
      questionnaireType: questionnaireType ?? this.questionnaireType,
      doDate: doDate ?? this.doDate,
      totalPoint: totalPoint ?? this.totalPoint,
      answerList: answerList ?? this.answerList,
      bodyPart: bodyPart ?? this.bodyPart,
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
    result.addAll({'bodyPart': bodyPart});

    return result;
  }

  factory PhysicalResultData.fromMap(Map<String, dynamic> map) {
    return PhysicalResultData(
      questionnaireNo: map['questionnaireNo'] ?? '',
      athleteNo: map['athleteNo'] ?? '',
      questionnaireType: map['questionnaireType'] ?? '',
      doDate: DateTime.parse(map['doDate'].toDate().toString()),
      totalPoint: map['totalPoint']?.toInt() ?? 0,
      answerList: Map<String, int>.from(map['answerList']),
      bodyPart: map['bodyPart'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PhysicalResultData.fromJson(String source) =>
      PhysicalResultData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PhysicalResultData(athleteNo: $athleteNo, questionnaireType: $questionnaireType, doDate: $doDate, totalPoint: $totalPoint, answerList: $answerList, bodyPart: $bodyPart)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PhysicalResultData &&
        other.questionnaireNo == questionnaireNo &&
        other.athleteNo == athleteNo &&
        other.questionnaireType == questionnaireType &&
        other.doDate == doDate &&
        other.totalPoint == totalPoint &&
        mapEquals(other.answerList, answerList) &&
        other.bodyPart == bodyPart;
  }

  @override
  int get hashCode {
    return questionnaireNo.hashCode ^
        athleteNo.hashCode ^
        questionnaireType.hashCode ^
        doDate.hashCode ^
        totalPoint.hashCode ^
        answerList.hashCode ^
        bodyPart.hashCode;
  }
}
