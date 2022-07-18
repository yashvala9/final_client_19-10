// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// ignore: non_constant_identifier_names
class WinnerModel {
  int id;
  String prizeName;
  String winnerName;
  String contestName;
  String winnerImageUrl;
  WinnerModel({
    this.id = 0,
    this.prizeName = '',
    this.winnerName = '',
    this.contestName = '',
    this.winnerImageUrl = '',
  });

  WinnerModel copyWith({
    int? id,
    String? prizeName,
    String? winnerName,
    String? contestName,
    String? winnerImageUrl,
  }) {
    return WinnerModel(
      id: id ?? this.id,
      prizeName: prizeName ?? this.prizeName,
      winnerName: winnerName ?? this.winnerName,
      contestName: contestName ?? this.contestName,
      winnerImageUrl: winnerImageUrl ?? this.winnerImageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'prizeName': prizeName,
      'winnerName': winnerName,
      'contestName': contestName,
      'winnerImageUrl': winnerImageUrl,
    };
  }

  factory WinnerModel.fromMap(Map<String, dynamic> map) {
    return WinnerModel(
      id: (map['id'] ?? 0) as int,
      prizeName: (map['prizeName'] ?? '') as String,
      winnerName: (map['winnerName'] ?? '') as String,
      contestName: (map['contestName'] ?? '') as String,
      winnerImageUrl: (map['winnerImageUrl'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WinnerModel.fromJson(String source) =>
      WinnerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WinnerModel(id: $id, prizeName: $prizeName, winnerName: $winnerName, contestName: $contestName, winnerImageUrl: $winnerImageUrl)';
  }

  @override
  bool operator ==(covariant WinnerModel other) {
    if (identical(this, other)) return true;
  
    return other.id == id &&
        other.prizeName == prizeName &&
        other.winnerName == winnerName &&
        other.contestName == contestName &&
        other.winnerImageUrl == winnerImageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        prizeName.hashCode ^
        winnerName.hashCode ^
        contestName.hashCode ^
        winnerImageUrl.hashCode;
  }
}
