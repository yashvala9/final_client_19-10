// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:reel_ro/models/profile_model.dart';

class CommentModel {
  int id;
  String comment;
  int likeCount;
  int responseCount;
  ProfileModel user;
  String reelId;
  bool isLiked;
  DateTime createdAt;
  CommentModel({
    required this.id,
    required this.comment,
    required this.likeCount,
    required this.responseCount,
    required this.user,
    required this.reelId,
    required this.isLiked,
    required this.createdAt,
  });

  CommentModel copyWith({
    int? id,
    String? comment,
    int? likeCount,
    int? responseCount,
    ProfileModel? user,
    String? reelId,
    bool? isLiked,
    DateTime? createdAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      comment: comment ?? this.comment,
      likeCount: likeCount ?? this.likeCount,
      responseCount: responseCount ?? this.responseCount,
      user: user ?? this.user,
      reelId: reelId ?? this.reelId,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'comment': comment});
    result.addAll({'likeCount': likeCount});
    result.addAll({'responseCount': responseCount});
    result.addAll({'user': user.toMap()});
    result.addAll({'reelId': reelId});
    result.addAll({'isLiked': isLiked});
    result.addAll({'createdAt': createdAt});

    return result;
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
        id: map['id']?.toInt() ?? 0,
        comment: map['comment'] ?? '',
        likeCount: map['likes_count']?.toInt() ?? 0,
        responseCount: map['response_count']?.toInt() ?? 0,
        user: ProfileModel.fromMap(map['user']),
        reelId: map['reelId'] ?? '',
        isLiked: map['is_liked'] ?? false,
        createdAt: DateTime.parse(map['created_at']));
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CommentModel(id: $id, comment: $comment, likeCount: $likeCount, responseCount: $responseCount, user: $user, reelId: $reelId, isLiked: $isLiked)';
  }

  @override
  bool operator ==(covariant CommentModel other) {
    if (identical(this, other)) return true;

    // ignore: unnecessary_type_check
    return other is CommentModel &&
        other.id == id &&
        other.comment == comment &&
        other.likeCount == likeCount &&
        other.responseCount == responseCount &&
        other.user == user &&
        other.reelId == reelId &&
        other.isLiked == isLiked;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        comment.hashCode ^
        likeCount.hashCode ^
        responseCount.hashCode ^
        user.hashCode ^
        reelId.hashCode ^
        isLiked.hashCode;
  }
}
