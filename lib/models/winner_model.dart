// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:reel_ro/models/prize_model.dart';
import 'package:reel_ro/models/profile_model.dart';

class WinnerModel {
  final int id;
  final ProfileModel user;
  final Contest contest;
  final PrizeModel prize;
  WinnerModel({
    required this.id,
    required this.user,
    required this.contest,
    required this.prize,
  });

  WinnerModel copyWith({
    int? id,
    ProfileModel? user,
    Contest? contest,
    PrizeModel? prize,
  }) {
    return WinnerModel(
      id: id ?? this.id,
      user: user ?? this.user,
      contest: contest ?? this.contest,
      prize: prize ?? this.prize,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user.toMap(),
      'contest': contest.toMap(),
      'prize': prize.toMap(),
    };
  }

  factory WinnerModel.fromMap(Map<String, dynamic> map) {
    return WinnerModel(
      id: map['id'] as int,
      user: ProfileModel.fromMap(map['user'] as Map<String, dynamic>),
      contest: Contest.fromMap(map['contest'] as Map<String, dynamic>),
      prize: PrizeModel.fromMap(map['prize'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory WinnerModel.fromJson(String source) =>
      WinnerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WinnerModel(id: $id, user: $user, contest: $contest, prize: $prize)';
  }

  @override
  bool operator ==(covariant WinnerModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user == user &&
        other.contest == contest &&
        other.prize == prize;
  }

  @override
  int get hashCode {
    return id.hashCode ^ user.hashCode ^ contest.hashCode ^ prize.hashCode;
  }
}

class Contest {
  final int id;
  final String contest_name;
  Contest({
    required this.id,
    required this.contest_name,
  });

  Contest copyWith({
    int? id,
    String? contest_name,
  }) {
    return Contest(
      id: id ?? this.id,
      contest_name: contest_name ?? this.contest_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'contest_name': contest_name,
    };
  }

  factory Contest.fromMap(Map<String, dynamic> map) {
    return Contest(
      id: map['id'] as int,
      contest_name: map['contest_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Contest.fromJson(String source) =>
      Contest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Contest(id: $id, contest_name: $contest_name)';

  @override
  bool operator ==(covariant Contest other) {
    if (identical(this, other)) return true;

    return other.id == id && other.contest_name == contest_name;
  }

  @override
  int get hashCode => id.hashCode ^ contest_name.hashCode;
}
