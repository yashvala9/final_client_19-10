// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:reel_ro/models/profile_model.dart';

class CommentModel {
  final int id;
  final String comment;
  final ProfileModel user;
  // int likeCount;
  // int responseCount;
  // bool isLiked;
  CommentModel({
    required this.id,
    required this.comment,
    required this.user,
  });

  CommentModel copyWith({
    int? id,
    String? comment,
    ProfileModel? user,
  }) {
    return CommentModel(
      id: id ?? this.id,
      comment: comment ?? this.comment,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'comment': comment,
      'user': user.toMap(),
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] as int,
      comment: map['comment'] as String,
      user: ProfileModel.fromMap(map['user'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CommentModel(id: $id, comment: $comment, user: $user)';

  @override
  bool operator ==(covariant CommentModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.comment == comment && other.user == user;
  }

  @override
  int get hashCode => id.hashCode ^ comment.hashCode ^ user.hashCode;
}
