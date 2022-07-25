// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:reel_ro/models/profile_model.dart';

class WinnerModel {
  final int id;
  final int user_id;
  final ProfileModel user;
  final int contest_id;
  final int prize_id;
  WinnerModel({
    required this.id,
    required this.user_id,
    required this.user,
    required this.contest_id,
    required this.prize_id,
  });

  WinnerModel copyWith({
    int? id,
    int? user_id,
    ProfileModel? user,
    int? contest_id,
    int? prize_id,
  }) {
    return WinnerModel(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      user: user ?? this.user,
      contest_id: contest_id ?? this.contest_id,
      prize_id: prize_id ?? this.prize_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user_id': user_id,
      'user': user.toMap(),
      'contest_id': contest_id,
      'prize_id': prize_id,
    };
  }

  factory WinnerModel.fromMap(Map<String, dynamic> map) {
    return WinnerModel(
      id: map['id'] as int,
      user_id: map['user_id'] as int,
      user: ProfileModel.fromMap(map['user'] as Map<String, dynamic>),
      contest_id: map['contest_id'] as int,
      prize_id: map['prize_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory WinnerModel.fromJson(String source) =>
      WinnerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Winnermodel(id: $id, user_id: $user_id, user: $user, contest_id: $contest_id, prize_id: $prize_id)';
  }

  @override
  bool operator ==(covariant WinnerModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user_id == user_id &&
        other.user == user &&
        other.contest_id == contest_id &&
        other.prize_id == prize_id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user_id.hashCode ^
        user.hashCode ^
        contest_id.hashCode ^
        prize_id.hashCode;
  }
}
