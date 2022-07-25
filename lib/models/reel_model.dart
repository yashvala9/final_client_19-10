// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/models/user_model.dart';

class ReelModel {
  final int id;
  final String description;
  final String filename;
  final String status;
  final int userid;
  final ProfileModel user;
  ReelModel({
    required this.id,
    required this.description,
    required this.filename,
    required this.status,
    required this.userid,
    required this.user,
  });

  ReelModel copyWith({
    int? id,
    String? description,
    String? filename,
    String? status,
    int? userid,
    ProfileModel? user,
  }) {
    return ReelModel(
      id: id ?? this.id,
      description: description ?? this.description,
      filename: filename ?? this.filename,
      status: status ?? this.status,
      userid: userid ?? this.userid,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'description': description,
      'filename': filename,
      'status': status,
      'userid': userid,
      'user': user.toMap(),
    };
  }

  factory ReelModel.fromMap(Map<String, dynamic> map) {
    return ReelModel(
      id: map['id'] as int,
      description: map['description'] as String,
      filename: map['filename'] as String,
      status: map['status'] as String,
      userid: map['userid'] as int,
      user: ProfileModel.fromMap(map['user'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReelModel.fromJson(String source) =>
      ReelModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Reelmodel(id: $id, description: $description, filename: $filename, status: $status, userid: $userid, user: $user)';
  }

  @override
  bool operator ==(covariant ReelModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.description == description &&
        other.filename == filename &&
        other.status == status &&
        other.userid == userid &&
        other.user == user;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        filename.hashCode ^
        status.hashCode ^
        userid.hashCode ^
        user.hashCode;
  }
}
