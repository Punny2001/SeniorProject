import 'dart:convert';

import 'package:flutter/foundation.dart';

class PhysicalResultData {
  String questionnaireNo;
  String athleteNo;
  String athleteUID;
  String questionnaireType;
  DateTime doDate;
  int totalPoint;
  Map<String, int> answerList;
  String bodyPart;
  bool caseReceived;
  String staff_no_received;
  String staff_uid_received;
  bool caseFinished;
  DateTime caseReceivedDateTime;
  DateTime caseFinishedDateTime;
  String adviceMessage;
  DateTime messageReceivedDateTime;

  PhysicalResultData({
    @required this.questionnaireNo,
    @required this.athleteNo,
    @required this.athleteUID,
    @required this.questionnaireType,
    @required this.doDate,
    @required this.totalPoint,
    @required this.answerList,
    @required this.bodyPart,
    this.caseReceived,
    this.staff_no_received,
    this.staff_uid_received,
    this.caseFinished,
    this.caseReceivedDateTime,
    this.caseFinishedDateTime,
    this.adviceMessage,
    this.messageReceivedDateTime,
  });

  PhysicalResultData copyWith({
    String questionnaireNo,
    String athleteNo,
    String athleteUID,
    String questionnaireType,
    DateTime doDate,
    int totalPoint,
    Map<String, int> answerList,
    String bodyPart,
    bool caseReceived,
    String staff_no_received,
    String staff_uid_received,
    bool caseFinished,
    DateTime caseReceivedDateTime,
    DateTime caseFinishedDateTime,
    String adviceMessage,
    DateTime messageReceivedDateTime,
  }) {
    return PhysicalResultData(
      questionnaireNo: questionnaireNo ?? this.questionnaireNo,
      athleteNo: athleteNo ?? this.athleteNo,
      athleteUID: athleteUID ?? this.athleteUID,
      questionnaireType: questionnaireType ?? this.questionnaireType,
      doDate: doDate ?? this.doDate,
      totalPoint: totalPoint ?? this.totalPoint,
      answerList: answerList ?? this.answerList,
      bodyPart: bodyPart ?? this.bodyPart,
      caseReceived: caseReceived ?? this.caseReceived,
      staff_no_received: staff_no_received ?? this.staff_no_received,
      staff_uid_received: staff_uid_received ?? this.staff_uid_received,
      caseFinished: caseFinished ?? this.caseFinished,
      caseReceivedDateTime: caseReceivedDateTime ?? this.caseReceivedDateTime,
      caseFinishedDateTime: caseFinishedDateTime ?? this.caseFinishedDateTime,
      adviceMessage: adviceMessage ?? this.adviceMessage,
      messageReceivedDateTime:
          messageReceivedDateTime ?? this.messageReceivedDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'questionnaireNo': questionnaireNo});
    result.addAll({'athleteNo': athleteNo});
    result.addAll({'athleteUID': athleteUID});
    result.addAll({'questionnaireType': questionnaireType});
    result.addAll({'doDate': doDate});
    result.addAll({'totalPoint': totalPoint});
    result.addAll({'answerList': answerList});
    result.addAll({'bodyPart': bodyPart});
    result.addAll({'caseReceived': caseReceived});
    result.addAll({'staff_no_received': staff_no_received});
    result.addAll({'staff_uid_received': staff_uid_received});
    result.addAll({'caseFinished': caseFinished});
    result.addAll({'caseReceivedDateTime': caseReceivedDateTime});
    result.addAll({'caseFinishedDateTime': caseFinishedDateTime});
    result.addAll({'adviceMessage': adviceMessage});
    result.addAll({'messageReceivedDateTime': messageReceivedDateTime});

    return result;
  }

  factory PhysicalResultData.fromMap(Map<String, dynamic> map) {
    return PhysicalResultData(
      questionnaireNo: map['questionnaireNo'] ?? '',
      athleteNo: map['athleteNo'] ?? '',
      athleteUID: map['athleteUID'] ?? '',
      questionnaireType: map['questionnaireType'] ?? '',
      doDate: DateTime.parse(map['doDate'].toDate().toString()),
      totalPoint: map['totalPoint']?.toInt() ?? 0,
      answerList: Map<String, int>.from(map['answerList']),
      bodyPart: map['bodyPart'] ?? '',
      caseReceived: map['caseReceived'] ?? false,
      staff_no_received: map['staff_no_received'] ?? '',
      staff_uid_received: map['staff_uid_received'] ?? '',
      caseFinished: map['caseFinished'] ?? false,
      caseReceivedDateTime:
          DateTime.parse(map['caseReceivedDateTime'].toDate().toString()),
      caseFinishedDateTime:
          DateTime.parse(map['caseFinishedDateTime'].toDate().toString()),
      adviceMessage: map['adviceMessage'] ?? '',
      messageReceivedDateTime:
          DateTime.parse(map['messageReceivedDateTime'].toDate().toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory PhysicalResultData.fromJson(String source) =>
      PhysicalResultData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PhysicalResultData(questionnaireNo: $questionnaireNo, athleteNo: $athleteNo, athleteUID: $athleteUID, questionnaireType: $questionnaireType, doDate: $doDate, totalPoint: $totalPoint, answerList: $answerList, bodyPart: $bodyPart, caseReceived: $caseReceived, staff_no_received: $staff_no_received, staff_uid_received: $staff_uid_received, caseFinished: $caseFinished, caseReceivedDateTime: $caseReceivedDateTime, caseFinishedDateTime: $caseFinishedDateTime, adviceMessage: $adviceMessage, messageReceivedDateTime: $messageReceivedDateTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PhysicalResultData &&
        other.questionnaireNo == questionnaireNo &&
        other.athleteNo == athleteNo &&
        other.athleteUID == athleteUID &&
        other.questionnaireType == questionnaireType &&
        other.doDate == doDate &&
        other.totalPoint == totalPoint &&
        mapEquals(other.answerList, answerList) &&
        other.bodyPart == bodyPart &&
        other.caseReceived == caseReceived &&
        other.staff_no_received == staff_no_received &&
        other.staff_uid_received == staff_uid_received &&
        other.caseFinished == caseFinished &&
        other.caseReceivedDateTime == caseReceivedDateTime &&
        other.caseFinishedDateTime == caseFinishedDateTime &&
        other.adviceMessage == adviceMessage &&
        other.messageReceivedDateTime == messageReceivedDateTime;
  }

  @override
  int get hashCode {
    return questionnaireNo.hashCode ^
        athleteNo.hashCode ^
        athleteUID.hashCode ^
        questionnaireType.hashCode ^
        doDate.hashCode ^
        totalPoint.hashCode ^
        answerList.hashCode ^
        bodyPart.hashCode ^
        caseReceived.hashCode ^
        staff_no_received.hashCode ^
        staff_uid_received.hashCode ^
        caseFinished.hashCode ^
        caseReceivedDateTime.hashCode ^
        caseFinishedDateTime.hashCode ^
        adviceMessage.hashCode ^
        messageReceivedDateTime.hashCode;
  }
}
