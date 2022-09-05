import 'dart:convert';

import 'package:flutter/foundation.dart';

class MentalResultData {
  String athlete_no;
  String Questionaire_type;
  DateTime DoDate;
  int TotalPoint;
  Map<String, int> answer_list;
  MentalResultData({
    @required this.athlete_no,
    @required this.Questionaire_type,
    @required this.DoDate,
    @required this.TotalPoint,
    @required this.answer_list,
  });

  MentalResultData copyWith({
    String athlete_no,
    String Questionaire_type,
    DateTime DoDate,
    int TotalPoint,
    Map answer_list,
  }) {
    return MentalResultData(
      athlete_no: athlete_no ?? this.athlete_no,
      Questionaire_type: Questionaire_type ?? this.Questionaire_type,
      DoDate: DoDate ?? this.DoDate,
      TotalPoint: TotalPoint ?? this.TotalPoint,
      answer_list: answer_list ?? this.answer_list,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'athlete_no': athlete_no});
    result.addAll({'Questionaire_type': Questionaire_type});
    result.addAll({'DoDate': DoDate});
    result.addAll({'TotalPoint': TotalPoint});
    result.addAll({'answer_list': answer_list});
  
    return result;
  }

  factory MentalResultData.fromMap(Map<String, dynamic> map) {
    return MentalResultData(
      athlete_no: map['athlete_no'] ?? '',
      Questionaire_type: map['Questionaire_type'] ?? '',
      DoDate: DateTime.parse(map['occured_date'].toDate().toString()),
      TotalPoint: map['TotalPoint']?.toInt() ?? 0,
      answer_list: Map.from(map['answer_list']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MentalResultData.fromJson(String source) => MentalResultData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MentalResultData(athlete_no: $athlete_no, Questionaire_type: $Questionaire_type, DoDate: $DoDate, TotalPoint: $TotalPoint, answer_list: $answer_list)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MentalResultData &&
      other.athlete_no == athlete_no &&
      other.Questionaire_type == Questionaire_type &&
      other.DoDate == DoDate &&
      other.TotalPoint == TotalPoint &&
      mapEquals(other.answer_list, answer_list);
  }

  @override
  int get hashCode {
    return athlete_no.hashCode ^
      Questionaire_type.hashCode ^
      DoDate.hashCode ^
      TotalPoint.hashCode ^
      answer_list.hashCode;
  }
}
