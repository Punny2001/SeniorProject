import 'dart:convert';
import 'package:flutter/material.dart';

class MessageData {
  final String messageNo;
  final String staffUID;
  final String athleteNo;
  final DateTime messageDateTime;
  final String messageDescription;
  MessageData({
    @required this.messageNo,
    @required this.staffUID,
    @required this.athleteNo,
    @required this.messageDateTime,
    @required this.messageDescription,
  });

  MessageData copyWith({
    String messageNo,
    String staffUID,
    String athleteNo,
    DateTime messageDateTime,
    String messageDescription,
  }) {
    return MessageData(
      messageNo: messageNo ?? this.messageNo,
      staffUID: staffUID ?? this.staffUID,
      athleteNo: athleteNo ?? this.athleteNo,
      messageDateTime: messageDateTime ?? this.messageDateTime,
      messageDescription: messageDescription ?? this.messageDescription,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'messageNo': messageNo});
    result.addAll({'staffUID': staffUID});
    result.addAll({'athleteNo': athleteNo});
    result.addAll({'messageDateTime': messageDateTime.millisecondsSinceEpoch});
    result.addAll({'messageDescription': messageDescription});

    return result;
  }

  factory MessageData.fromMap(Map<String, dynamic> map) {
    return MessageData(
      messageNo: map['messageNo'] ?? '',
      staffUID: map['staffUID'] ?? '',
      athleteNo: map['athleteNo'] ?? '',
      messageDateTime:
          DateTime.parse(map['messageDateTime'].toDate().toString()),
      messageDescription: map['messageDescription'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageData.fromJson(String source) =>
      MessageData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MessageData(messageNo: $messageNo, staffUID: $staffUID, athleteNo: $athleteNo, messageDateTime: $messageDateTime, messageDescription: $messageDescription)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageData &&
        other.messageNo == messageNo &&
        other.staffUID == staffUID &&
        other.athleteNo == athleteNo &&
        other.messageDateTime == messageDateTime &&
        other.messageDescription == messageDescription;
  }

  @override
  int get hashCode {
    return messageNo.hashCode ^
        staffUID.hashCode ^
        athleteNo.hashCode ^
        messageDateTime.hashCode ^
        messageDescription.hashCode;
  }
}
