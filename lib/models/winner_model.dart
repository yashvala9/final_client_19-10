// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// ignore: non_constant_identifier_names
class WinnerModel {
  int id;
  int profileId;
  int contestId;
  WinnerModel(
    this.id,
    this.profileId,
    this.contestId,
  );

  WinnerModel copyWith({
    int? id,
    int? profileId,
    int? contestId,
  }) {
    return WinnerModel(
      id ?? this.id,
      profileId ?? this.profileId,
      contestId ?? this.contestId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'profileId': profileId,
      'contestId': contestId,
    };
  }

  factory WinnerModel.fromMap(Map<String, dynamic> map) {
    return WinnerModel(
      map['id'] as int,
      map['profileId'] as int,
      map['contestId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory WinnerModel.fromJson(String source) =>
      WinnerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'WinnerModel(id: $id, profileId: $profileId, contestId: $contestId)';

  @override
  bool operator ==(covariant WinnerModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.profileId == profileId &&
        other.contestId == contestId;
  }

  @override
  int get hashCode => id.hashCode ^ profileId.hashCode ^ contestId.hashCode;
}
