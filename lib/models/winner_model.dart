// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class WinnerModel {
  final int id;
  final String userName;
  final String userImage;
  final String contestName;
  final String winnerImage;
  WinnerModel({
    this.id = 0,
    this.userName = '',
    this.userImage = '',
    this.contestName = '',
    required this.winnerImage,
  });

  WinnerModel copyWith({
    int? id,
    String? userName,
    String? userImage,
    String? contestName,
    String? winnerImage,
  }) {
    return WinnerModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      userImage: userImage ?? this.userImage,
      contestName: contestName ?? this.contestName,
      winnerImage: winnerImage ?? this.winnerImage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userName': userName,
      'userImage': userImage,
      'contestName': contestName,
      'winnerImage': winnerImage,
    };
  }

  factory WinnerModel.fromMap(Map<String, dynamic> map) {
    return WinnerModel(
        id: map['id'] as int,
        userName: map['user']['user_profile']['fullname'] as String,
        userImage: map['user']['user_profile']['profile_img'] as String,
        contestName: map['contest']['contest_name'] as String,
        winnerImage: map['image'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory WinnerModel.fromJson(String source) =>
      WinnerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WinnerModel(id: $id, userName: $userName, userImage: $userImage, contestName: $contestName, winnerImage: $winnerImage)';
  }

  @override
  bool operator ==(covariant WinnerModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userName == userName &&
        other.userImage == userImage &&
        other.contestName == contestName &&
        other.winnerImage == winnerImage;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userName.hashCode ^
        userImage.hashCode ^
        contestName.hashCode ^
        winnerImage.hashCode;
  }
}
