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
  final String prize_name;
  final String prize_image;
  final String winnerName;
  final int winnerId;
  final int id;

  // final List<WinnerModel>? winners;
  ContestModel({
    required this.contest_name,
    required this.creator_type,
    required this.start_date,
    required this.end_date,
    required this.rules,
    this.prize_name = '',
    this.prize_image = '',
    this.winnerName = '',
    this.winnerId = 0,
    this.id = 0,
  });

  ContestModel copyWith({
    String? contest_name,
    String? creator_type,
    DateTime? start_date,
    DateTime? end_date,
    String? rules,
    String? prize_name,
    String? prize_image,
    String? winnerName,
    int? winnerId,
    int? id,
  }) {
    return ContestModel(
      contest_name: contest_name ?? this.contest_name,
      creator_type: creator_type ?? this.creator_type,
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
      rules: rules ?? this.rules,
      prize_name: prize_name ?? this.prize_name,
      prize_image: prize_image ?? this.prize_image,
      winnerName: winnerName ?? this.winnerName,
      winnerId: winnerId ?? this.winnerId,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'contest_name': contest_name,
      'creator_type': creator_type,
      'start_date': start_date.millisecondsSinceEpoch,
      'end_date': end_date.millisecondsSinceEpoch,
      'rules': rules,
      'prize_name': prize_name,
      'prize_image': prize_image,
      'winnerName': winnerName,
      'winnerId': winnerId,
      'id': id,
    };
  }

  factory ContestModel.fromMap(Map<String, dynamic> map) {
    print('212145 map $map');
    var v = ContestModel(
      contest_name: map['contest_name'] as String,
      creator_type: map['creator_type'] as String,
      start_date: DateTime.parse(map['start_date']).toLocal(),
      end_date: DateTime.parse(map['end_date']).toLocal(),
      rules: map['rules'] as String,
      prize_name: map['prizes'].isNotEmpty
          ? map['prizes'][0]['prize_name'] as String
          : '',
      prize_image: map['prizes'].isNotEmpty
          ? map['prizes'][0]['prize_image'] as String
          : '',
      winnerName: map['winners'].isNotEmpty
          ? map['winners'][0]['user']['user_profile']['fullname'] as String
          : '',
      winnerId: map['winners'].isNotEmpty
          ? map['winners'][0]['user']['id'] as int
          : 0,
      id: map['id'] as int,
    );
    print('212145 v $v');
    return v;
  }

  String toJson() => json.encode(toMap());

  factory ContestModel.fromJson(String source) =>
      ContestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ContestModel(contest_name: $contest_name, creator_type: $creator_type, start_date: $start_date, end_date: $end_date, rules: $rules, prize_name: $prize_name, prize_image: $prize_image, winnerName: $winnerName, winnerId: $winnerId, id: $id)';
  }

  @override
  bool operator ==(covariant ContestModel other) {
    if (identical(this, other)) return true;

    return other.contest_name == contest_name &&
        other.creator_type == creator_type &&
        other.start_date == start_date &&
        other.end_date == end_date &&
        other.rules == rules &&
        other.prize_name == prize_name &&
        other.prize_image == prize_image &&
        other.winnerName == winnerName &&
        other.winnerId == winnerId &&
        other.id == id;
  }

  @override
  int get hashCode {
    return contest_name.hashCode ^
        creator_type.hashCode ^
        start_date.hashCode ^
        end_date.hashCode ^
        rules.hashCode ^
        prize_name.hashCode ^
        prize_image.hashCode ^
        winnerName.hashCode ^
        winnerId.hashCode ^
        id.hashCode;
  }
}
