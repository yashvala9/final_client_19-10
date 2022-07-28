// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:reel_ro/models/prize_model.dart';
import 'package:reel_ro/models/winner_model.dart';

class ContestModel {
  final String contest_name;
  final String creator_type;
  final DateTime start_date;
  final DateTime end_date;
  final String rules;
  final List<PrizeModel> prizes;
  final List<WinnerModel>? winners;
  ContestModel({
    required this.contest_name,
    required this.creator_type,
    required this.start_date,
    required this.end_date,
    required this.rules,
    required this.prizes,
    required this.winners,
  });

  ContestModel copyWith({
    String? contest_name,
    String? creator_type,
    DateTime? start_date,
    DateTime? end_date,
    String? rules,
    List<PrizeModel>? prizes,
    List<WinnerModel>? winners,
  }) {
    return ContestModel(
      contest_name: contest_name ?? this.contest_name,
      creator_type: creator_type ?? this.creator_type,
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
      rules: rules ?? this.rules,
      prizes: prizes ?? this.prizes,
      winners: winners ?? this.winners,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'contest_name': contest_name,
      'creator_type': creator_type,
      'start_date': start_date.toString(),
      'end_date': end_date.toString(),
      'rules': rules,
      'prizes': prizes.map((x) => x.toMap()).toList(),
      'winners': winners?.map((x) => x.toMap()).toList(),
    };
  }

  factory ContestModel.fromMap(Map<String, dynamic> map) {
    return ContestModel(
      contest_name: map['contest_name'] as String,
      creator_type: map['creator_type'] as String,
      start_date: DateTime.parse(map['start_date']),
      end_date: DateTime.parse(map['end_date']),
      rules: map['rules'] as String,
      prizes: List<PrizeModel>.from(
        (map['prizes'] as List<dynamic>).map<PrizeModel>(
          (x) => PrizeModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      winners: map['winners'] != null
          ? List<WinnerModel>.from(
              (map['winners'] as List<dynamic>).map<WinnerModel?>(
                (x) => WinnerModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContestModel.fromJson(String source) =>
      ContestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ContestModel(contest_name: $contest_name, creator_type: $creator_type, start_date: $start_date, end_date: $end_date, rules: $rules, prizes: $prizes, winners: $winners)';
  }

  @override
  bool operator ==(covariant ContestModel other) {
    if (identical(this, other)) return true;

    return other.contest_name == contest_name &&
        other.creator_type == creator_type &&
        other.start_date == start_date &&
        other.end_date == end_date &&
        other.rules == rules &&
        listEquals(other.prizes, prizes) &&
        listEquals(other.winners, winners);
  }

  @override
  int get hashCode {
    return contest_name.hashCode ^
        creator_type.hashCode ^
        start_date.hashCode ^
        end_date.hashCode ^
        rules.hashCode ^
        prizes.hashCode ^
        winners.hashCode;
  }
}
