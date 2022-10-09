// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class PrizeModel {
  final int id;
  final int contest_id;
  final String prize_name;
  final String prize_image;
  final String prize_description;
  PrizeModel({
    required this.id,
    required this.contest_id,
    required this.prize_name,
    required this.prize_image,
    required this.prize_description,
  });

  PrizeModel copyWith({
    int? id,
    int? contest_id,
    String? prize_name,
    String? prize_image,
    String? prize_description,
  }) {
    return PrizeModel(
      id: id ?? this.id,
      contest_id: contest_id ?? this.contest_id,
      prize_name: prize_name ?? this.prize_name,
      prize_image: prize_image ?? this.prize_image,
      prize_description: prize_description ?? this.prize_description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'contest_id': contest_id,
      'prize_name': prize_name,
      'prize_image': prize_image,
      'prize_description': prize_description,
    };
  }

  factory PrizeModel.fromMap(Map<String, dynamic> map) {
    return PrizeModel(
      id: map['id'].toInt() as int,
      contest_id: map['contest_id'].toInt() as int,
      prize_name: map['prize_name'] as String,
      prize_image: map['prize_image'] as String,
      prize_description: map['prize_description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PrizeModel.fromJson(String source) =>
      PrizeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PrizeModel(id: $id, contest_id: $contest_id, prize_name: $prize_name, prize_image: $prize_image, prize_description: $prize_description)';
  }

  @override
  bool operator ==(covariant PrizeModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.contest_id == contest_id &&
        other.prize_name == prize_name &&
        other.prize_image == prize_image &&
        other.prize_description == prize_description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        contest_id.hashCode ^
        prize_name.hashCode ^
        prize_image.hashCode ^
        prize_description.hashCode;
  }
}
