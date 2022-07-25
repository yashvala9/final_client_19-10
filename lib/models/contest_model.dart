// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class ContestModel {
  final String contest_name;
  final String creator_type;
  final DateTime end_date;
  final int id;
  final int creator_id;
  final DateTime start_date;
  final String rules;
  final bool is_deleted;
  ContestModel({
    required this.contest_name,
    required this.creator_type,
    required this.end_date,
    required this.id,
    required this.creator_id,
    required this.start_date,
    required this.rules,
    required this.is_deleted,
  });

  ContestModel copyWith({
    String? contest_name,
    String? creator_type,
    DateTime? end_date,
    int? id,
    int? creator_id,
    DateTime? start_date,
    String? rules,
    bool? is_deleted,
  }) {
    return ContestModel(
      contest_name: contest_name ?? this.contest_name,
      creator_type: creator_type ?? this.creator_type,
      end_date: end_date ?? this.end_date,
      id: id ?? this.id,
      creator_id: creator_id ?? this.creator_id,
      start_date: start_date ?? this.start_date,
      rules: rules ?? this.rules,
      is_deleted: is_deleted ?? this.is_deleted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'contest_name': contest_name,
      'creator_type': creator_type,
      'end_date': end_date.toString(),
      'id': id,
      'creator_id': creator_id,
      'start_date': start_date.toString(),
      'rules': rules,
      'is_deleted': is_deleted,
    };
  }

  factory ContestModel.fromMap(Map<String, dynamic> map) {
    return ContestModel(
      contest_name: map['contest_name'] as String,
      creator_type: map['creator_type'] as String,
      end_date: DateTime.parse(map['end_date']),
      id: map['id'] as int,
      creator_id: map['creator_id'] as int,
      start_date: DateTime.parse(map['start_date']),
      rules: map['rules'] as String,
      is_deleted: map['is_deleted'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContestModel.fromJson(String source) =>
      ContestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Contestmodel(contest_name: $contest_name, creator_type: $creator_type, end_date: $end_date, id: $id, creator_id: $creator_id, start_date: $start_date, rules: $rules, is_deleted: $is_deleted)';
  }

  @override
  bool operator ==(covariant ContestModel other) {
    if (identical(this, other)) return true;

    return other.contest_name == contest_name &&
        other.creator_type == creator_type &&
        other.end_date == end_date &&
        other.id == id &&
        other.creator_id == creator_id &&
        other.start_date == start_date &&
        other.rules == rules &&
        other.is_deleted == is_deleted;
  }

  @override
  int get hashCode {
    return contest_name.hashCode ^
        creator_type.hashCode ^
        end_date.hashCode ^
        id.hashCode ^
        creator_id.hashCode ^
        start_date.hashCode ^
        rules.hashCode ^
        is_deleted.hashCode;
  }
}
