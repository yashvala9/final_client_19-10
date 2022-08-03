import 'dart:convert';

import 'package:reel_ro/models/profile_model.dart';

class NestedCommentModel {
  final int id;
  final int commentId;
  final String response;
  final DateTime createdAt;
  final ProfileModel owner;
  NestedCommentModel({
    required this.id,
    required this.commentId,
    required this.response,
    required this.createdAt,
    required this.owner,
  });

  NestedCommentModel copyWith({
    int? id,
    int? commentId,
    String? response,
    DateTime? createdAt,
    ProfileModel? owner,
  }) {
    return NestedCommentModel(
      id: id ?? this.id,
      commentId: commentId ?? this.commentId,
      response: response ?? this.response,
      createdAt: createdAt ?? this.createdAt,
      owner: owner ?? this.owner,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'commentId': commentId});
    result.addAll({'response': response});
    result.addAll({'created_at': createdAt.millisecondsSinceEpoch});
    result.addAll({'owner': owner.toMap()});
  
    return result;
  }

  factory NestedCommentModel.fromMap(Map<String, dynamic> map) {
    return NestedCommentModel(
      id: map['id']?.toInt() ?? 0,
      commentId: map['comment_id']?.toInt() ?? 0,
      response: map['response'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
      owner: ProfileModel.fromMap(map['owner']),
    );
  }

  String toJson() => json.encode(toMap());

  factory NestedCommentModel.fromJson(String source) => NestedCommentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NestedCommentModel(id: $id, commentId: $commentId, response: $response, createdAt: $createdAt, owner: $owner)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is NestedCommentModel &&
      other.id == id &&
      other.commentId == commentId &&
      other.response == response &&
      other.createdAt == createdAt &&
      other.owner == owner;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      commentId.hashCode ^
      response.hashCode ^
      createdAt.hashCode ^
      owner.hashCode;
  }
}
