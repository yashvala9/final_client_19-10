// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ContestModel {
  final int id;
  final String contestName;
  final int createdBy;
  final String creatorType;
  final DateTime? endDate;
  final String rules;
  final String prizeName;
  final String prizeImageUrl;
  final String winnerName;
  ContestModel({
    this.id = 0,
    this.contestName = '',
    this.createdBy = 0,
    this.creatorType = '',
    this.endDate,
    this.rules = '',
    this.prizeName = '',
    this.prizeImageUrl = '',
    this.winnerName = '',
  });

  ContestModel copyWith({
    int? id,
    String? contestName,
    int? createdBy,
    String? creatorType,
    DateTime? endDate,
    String? rules,
    String? prizeName,
    String? prizeImageUrl,
    String? winnerName,
  }) {
    return ContestModel(
      id: id ?? this.id,
      contestName: contestName ?? this.contestName,
      createdBy: createdBy ?? this.createdBy,
      creatorType: creatorType ?? this.creatorType,
      endDate: endDate ?? this.endDate,
      rules: rules ?? this.rules,
      prizeName: prizeName ?? this.prizeName,
      prizeImageUrl: prizeImageUrl ?? this.prizeImageUrl,
      winnerName: winnerName ?? this.winnerName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'contestName': contestName,
      'createdBy': createdBy,
      'creatorType': creatorType,
      'endDate': endDate?.millisecondsSinceEpoch,
      'rules': rules,
      'prizeName': prizeName,
      'prizeImageUrl': prizeImageUrl,
      'winnerName': winnerName,
    };
  }

  factory ContestModel.fromMap(Map<String, dynamic> map) {
    return ContestModel(
      id: (map['id'] ?? 0) as int,
      contestName: (map['contestName'] ?? '') as String,
      createdBy: (map['createdBy'] ?? 0) as int,
      creatorType: (map['creatorType'] ?? '') as String,
      endDate: map['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch((map['endDate'] ?? 0) as int)
          : null,
      rules: (map['rules'] ?? '') as String,
      prizeName: (map['prizeName'] ?? '') as String,
      prizeImageUrl: (map['prizeImageUrl'] ?? '') as String,
      winnerName: (map['winnerName'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContestModel.fromJson(String source) =>
      ContestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ContestModel(id: $id, contestName: $contestName, createdBy: $createdBy, creatorType: $creatorType, endDate: $endDate, rules: $rules, prizeName: $prizeName, prizeImageUrl: $prizeImageUrl, winnerName: $winnerName)';
  }

  @override
  bool operator ==(covariant ContestModel other) {
    if (identical(this, other)) return true;
  
    return other.id == id &&
        other.contestName == contestName &&
        other.createdBy == createdBy &&
        other.creatorType == creatorType &&
        other.endDate == endDate &&
        other.rules == rules &&
        other.prizeName == prizeName &&
        other.prizeImageUrl == prizeImageUrl &&
        other.winnerName == winnerName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        contestName.hashCode ^
        createdBy.hashCode ^
        creatorType.hashCode ^
        endDate.hashCode ^
        rules.hashCode ^
        prizeName.hashCode ^
        prizeImageUrl.hashCode ^
        winnerName.hashCode;
  }
}
