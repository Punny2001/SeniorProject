import 'dart:convert';

import 'package:flutter/foundation.dart';

class HealthResultData {
  String questionnaireNo;
  String athleteUID;
  String athleteNo;
  String questionnaireType;
  DateTime doDate;
  int totalPoint;
  Map<String, int> answerList;
  String healthSymptom;
  bool caseReceived;
  String staff_no_received;
  String staff_uid_received;
  bool caseFinished;
  DateTime caseReceivedDateTime;
  DateTime caseFinishedDateTime;
  String adviceMessage;
  bool messageReceived;
  DateTime messageReceivedDateTime;

  HealthResultData({
    @required this.questionnaireNo,
    @required this.athleteUID,
    @required this.athleteNo,
    @required this.questionnaireType,
    @required this.doDate,
    @required this.totalPoint,
    @required this.answerList,
    @required this.healthSymptom,
    this.caseReceived,
    this.staff_no_received,
    this.staff_uid_received,
    this.caseFinished,
    this.caseReceivedDateTime,
    this.caseFinishedDateTime,
    this.adviceMessage,
    this.messageReceived,
    this.messageReceivedDateTime,
  });

  HealthResultData copyWith({
    String questionnaireNo,
    String athleteUID,
    String athleteNo,
    String questionnaireType,
    DateTime doDate,
    int totalPoint,
    Map<String, int> answerList,
    String healthSymptom,
    bool caseReceived,
    String staff_no_received,
    String staff_uid_received,
    bool caseFinished,
    DateTime caseReceivedDateTime,
    DateTime caseFinishedDateTime,
    String adviceMessage,
    bool messageReceived,
    DateTime messageReceivedDateTime,
  }) {
    return HealthResultData(
      questionnaireNo: questionnaireNo ?? this.questionnaireNo,
      athleteUID: athleteUID ?? this.athleteUID,
      athleteNo: athleteNo ?? this.athleteNo,
      questionnaireType: questionnaireType ?? this.questionnaireType,
      doDate: doDate ?? this.doDate,
      totalPoint: totalPoint ?? this.totalPoint,
      answerList: answerList ?? this.answerList,
      healthSymptom: healthSymptom ?? this.healthSymptom,
      caseReceived: caseReceived ?? this.caseReceived,
      staff_no_received: staff_no_received ?? this.staff_no_received,
      staff_uid_received: staff_uid_received ?? this.staff_uid_received,
      caseFinished: caseFinished ?? this.caseFinished,
      caseReceivedDateTime: caseReceivedDateTime ?? this.caseReceivedDateTime,
      caseFinishedDateTime: caseFinishedDateTime ?? this.caseFinishedDateTime,
      adviceMessage: adviceMessage ?? this.adviceMessage,
      messageReceived: messageReceived ?? this.messageReceived,
      messageReceivedDateTime:
          messageReceivedDateTime ?? this.messageReceivedDateTime,
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
    result.addAll({'healthSymptom': healthSymptom});
    result.addAll({'caseReceived': caseReceived});
    result.addAll({'staff_no_received': staff_no_received});
    result.addAll({'staff_uid_received': staff_uid_received});
    result.addAll({'caseFinished': caseFinished});
    result.addAll({'caseReceivedDateTime': caseReceivedDateTime});
    result.addAll({'caseFinishedDateTime': caseFinishedDateTime});
    result.addAll({'adviceMessage': adviceMessage});
    result.addAll({'messageReceived': messageReceived});
    result.addAll({'messageReceivedDateTime': messageReceivedDateTime});

    return result;
  }

  factory HealthResultData.fromMap(Map<String, dynamic> map) {
    return HealthResultData(
      questionnaireNo: map['questionnaireNo'] ?? '',
      athleteUID: map['athleteUID'] ?? '',
      athleteNo: map['athleteNo'] ?? '',
      questionnaireType: map['questionnaireType'] ?? '',
      doDate: DateTime.parse(map['doDate'].toDate().toString()),
      totalPoint: map['totalPoint']?.toInt() ?? 0,
      answerList: Map<String, int>.from(map['answerList']),
      healthSymptom: map['healthSymptom'] ?? '',
      caseReceived: map['caseReceived'] ?? false,
      staff_no_received: map['staff_no_received'] ?? '',
      staff_uid_received: map['staff_uid_received'] ?? '',
      caseFinished: map['caseFinished'] ?? false,
      caseReceivedDateTime:
          DateTime.parse(map['caseReceivedDateTime'].toDate().toString()),
      caseFinishedDateTime:
          DateTime.parse(map['caseFinishedDateTime'].toDate().toString()),
      adviceMessage: map['adviceMessage'] ?? '',
      messageReceived: map['messageReceived'] ?? false,
      messageReceivedDateTime:
          DateTime.parse(map['messageReceivedDateTime'].toDate().toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory HealthResultData.fromJson(String source) =>
      HealthResultData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HealthResultData(questionnaireNo: $questionnaireNo, athleteUID: $athleteUID, athleteNo: $athleteNo, questionnaireType: $questionnaireType, doDate: $doDate, totalPoint: $totalPoint, answerList: $answerList, healthSymptom: $healthSymptom, caseReceived: $caseReceived, staff_no_received: $staff_no_received, staff_uid_received: $staff_uid_received, caseFinished: $caseFinished, caseReceivedDateTime: $caseReceivedDateTime, caseFinishedDateTime: $caseFinishedDateTime, adviceMessage: $adviceMessage, messageReceived: $messageReceived, messageReceivedDateTime: $messageReceivedDateTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HealthResultData &&
        other.questionnaireNo == questionnaireNo &&
        other.athleteUID == athleteUID &&
        other.athleteNo == athleteNo &&
        other.questionnaireType == questionnaireType &&
        other.doDate == doDate &&
        other.totalPoint == totalPoint &&
        mapEquals(other.answerList, answerList) &&
        other.healthSymptom == healthSymptom &&
        other.caseReceived == caseReceived &&
        other.staff_no_received == staff_no_received &&
        other.staff_uid_received == staff_uid_received &&
        other.caseFinished == caseFinished &&
        other.caseReceivedDateTime == caseReceivedDateTime &&
        other.caseFinishedDateTime == caseFinishedDateTime &&
        other.adviceMessage == adviceMessage &&
        other.messageReceived == messageReceived &&
        other.messageReceivedDateTime == messageReceivedDateTime;
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
        healthSymptom.hashCode ^
        caseReceived.hashCode ^
        staff_no_received.hashCode ^
        staff_uid_received.hashCode ^
        caseFinished.hashCode ^
        caseReceivedDateTime.hashCode ^
        caseFinishedDateTime.hashCode ^
        adviceMessage.hashCode ^
        messageReceived.hashCode ^
        messageReceivedDateTime.hashCode;
  }
}
