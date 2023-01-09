import 'dart:convert';

import 'package:flutter/foundation.dart';

class MentalResultData {
  String questionnaireNo;
  String athleteUID;
  String athleteNo;
  String questionnaireType;
  DateTime doDate;
  Map<String, int> answerListPart1;
  Map<String, int> answerListPart2;
  Map<String, int> answerListPart3;
  MentalResultData({
    @required this.questionnaireNo,
    @required this.athleteUID,
    @required this.athleteNo,
    @required this.questionnaireType,
    @required this.doDate,
    @required this.answerListPart1,
    @required this.answerListPart2,
    @required this.answerListPart3,
  });

  MentalResultData copyWith({
    String questionnaireNo,
    String athleteUID,
    String athleteNo,
    String questionnaireType,
    DateTime doDate,
    Map<String, int> answerListPart1,
    Map<String, int> answerListPart2,
    Map<String, int> answerListPart3,
  }) {
    return MentalResultData(
      questionnaireNo: questionnaireNo ?? this.questionnaireNo,
      athleteUID: athleteUID ?? this.athleteUID,
      athleteNo: athleteNo ?? this.athleteNo,
      questionnaireType: questionnaireType ?? this.questionnaireType,
      doDate: doDate ?? this.doDate,
      answerListPart1: answerListPart1 ?? this.answerListPart1,
      answerListPart2: answerListPart2 ?? this.answerListPart2,
      answerListPart3: answerListPart3 ?? this.answerListPart3,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'questionnaireNo': questionnaireNo});
    result.addAll({'athleteUID': athleteUID});
    result.addAll({'athleteNo': athleteNo});
    result.addAll({'questionnaireType': questionnaireType});
    result.addAll({'doDate': doDate});
    result.addAll({'answerListPart1': answerListPart1});
    result.addAll({'answerListPart2': answerListPart2});
    result.addAll({'answerListPart3': answerListPart3});

    return result;
  }

  factory MentalResultData.fromMap(Map<String, dynamic> map) {
    return MentalResultData(
      questionnaireNo: map['questionnaireNo'] ?? '',
      athleteUID: map['athleteUID'] ?? '',
      athleteNo: map['athleteNo'] ?? '',
      questionnaireType: map['questionnaireType'] ?? '',
      doDate: DateTime.parse(map['doDate'].toDate().toString()),
      answerListPart1: Map<String, int>.from(map['answerListPart1']),
      answerListPart2: Map<String, int>.from(map['answerListPart2']),
      answerListPart3: Map<String, int>.from(map['answerListPart3']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MentalResultData.fromJson(String source) =>
      MentalResultData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MentalResultData(questionnaireNo: $questionnaireNo, athleteUID: $athleteUID, athleteNo: $athleteNo, questionnaireType: $questionnaireType, doDate: $doDate, answerListPart1: $answerListPart1, answerListPart2: $answerListPart2, answerListPart3: $answerListPart3)';
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
        mapEquals(other.answerListPart1, answerListPart1) &&
        mapEquals(other.answerListPart2, answerListPart2) &&
        mapEquals(other.answerListPart3, answerListPart3);
  }

  @override
  int get hashCode {
    return questionnaireNo.hashCode ^
        athleteUID.hashCode ^
        athleteNo.hashCode ^
        questionnaireType.hashCode ^
        doDate.hashCode ^
        answerListPart1.hashCode ^
        answerListPart2.hashCode ^
        answerListPart3.hashCode;
  }
}
