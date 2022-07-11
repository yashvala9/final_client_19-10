import 'dart:convert';

class CommentModel {
  int id;
  String comment;
  int likeCount;
  int responseCount;
  int profile;
  String reelId;
  bool isLiked;
  CommentModel({
    required this.id,
    required this.comment,
    required this.likeCount,
    required this.responseCount,
    required this.profile,
    required this.reelId,
   required this.isLiked ,
  });

  CommentModel copyWith({
    int? id,
    String? comment,
    int? likeCount,
    int? responseCount,
    int? profile,
    String? reelId,
    bool? isLiked,
  }) {
    return CommentModel(
      id: id ?? this.id,
      comment: comment ?? this.comment,
      likeCount: likeCount ?? this.likeCount,
      responseCount: responseCount ?? this.responseCount,
      profile: profile ?? this.profile,
      reelId: reelId ?? this.reelId,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'comment': comment,
      'likeCount': likeCount,
      'responseCount': responseCount,
      'profile': profile,
      'reelId': reelId,
      'isLiked': isLiked,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id']?.toInt() ?? 0,
      comment: map['comment'] ?? '',
      likeCount: map['likeCount']?.toInt() ?? 0,
      responseCount: map['responseCount']?.toInt() ?? 0,
      profile: map['profile']?.toInt() ?? 0,
      reelId: map['reelId']?.toString() ?? '',
      isLiked: map['isLiked'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CommentModel(id: $id, comment: $comment, likeCount: $likeCount,isLiked $isLiked,responseCount: $responseCount, profile: $profile, reelId: $reelId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CommentModel &&
        other.id == id &&
        other.comment == comment &&
        other.likeCount == likeCount &&
        other.responseCount == responseCount &&
        other.profile == profile &&
        other.reelId == reelId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        comment.hashCode ^
        likeCount.hashCode ^
        responseCount.hashCode ^
        profile.hashCode ^
        reelId.hashCode;
  }
}
