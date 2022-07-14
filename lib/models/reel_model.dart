// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final reel = reelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:reel_ro/models/comment_model.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/models/video_model.dart';

class ReelModel {
  int id;
  String description;
  dynamic mediaLink;
  dynamic mediaType;
  dynamic mediaExt;
  dynamic isDeleted;
  ProfileModel profile;
  String title;
  bool type;
  String song;
  String reelId;
  DateTime publishedAt;
  DateTime createdAt;
  DateTime updatedAt;
  int likeCount;
  int commentCount;
  VideoModel video;
  List<CommentModel> reelComments;
  List<String> hashtags;
  bool isLiked;
  ReelModel({
    required this.id,
    required this.description,
    required this.mediaLink,
    required this.mediaType,
    required this.mediaExt,
    required this.isDeleted,
    required this.profile,
    required this.title,
    required this.type,
    required this.song,
    required this.reelId,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.likeCount,
    required this.commentCount,
    required this.video,
    required this.reelComments,
    required this.hashtags,
    required this.isLiked,
  });

  ReelModel copyWith({
    int? id,
    String? description,
    dynamic? mediaLink,
    dynamic? mediaType,
    dynamic? mediaExt,
    dynamic? isDeleted,
    ProfileModel? profile,
    String? title,
    bool? type,
    String? song,
    String? reelId,
    DateTime? publishedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likeCount,
    int? commentCount,
    VideoModel? video,
    List<CommentModel>? reelComments,
    List<String>? hashtags,
    bool? isLiked,
  }) {
    return ReelModel(
      id: id ?? this.id,
      description: description ?? this.description,
      mediaLink: mediaLink ?? this.mediaLink,
      mediaType: mediaType ?? this.mediaType,
      mediaExt: mediaExt ?? this.mediaExt,
      isDeleted: isDeleted ?? this.isDeleted,
      profile: profile ?? this.profile,
      title: title ?? this.title,
      type: type ?? this.type,
      song: song ?? this.song,
      reelId: reelId ?? this.reelId,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      video: video ?? this.video,
      reelComments: reelComments ?? this.reelComments,
      hashtags: hashtags ?? this.hashtags,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'description': description,
      'mediaLink': mediaLink,
      'mediaType': mediaType,
      'mediaExt': mediaExt,
      'isDeleted': isDeleted,
      'profile': profile.toMap(),
      'title': title,
      'type': type,
      'song': song,
      'reelId': reelId,
      'publishedAt': publishedAt.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'videoId': video.toMap(),
      'reelComments': reelComments.map((x) => x.toMap()).toList(),
      'hashtags': hashtags,
      'isLiked': isLiked,
    };
  }

  factory ReelModel.fromMap(Map<String, dynamic> map) {
    return ReelModel(
      id: map['id'] ?? 0,
      isLiked: map['isLiked'] ?? false,
      description: map['description'] ?? "",
      mediaLink: map['mediaLink'] ?? "",
      mediaType: map['mediaType'] ?? "",
      mediaExt: map['mediaExt'] ?? "",
      isDeleted: map['isDeleted'] ?? "",
      profile: ProfileModel.fromMap(map['profile'] as Map<String, dynamic>),
      title: map['title'] ?? "",
      type: map['type'] ?? false,
      song: map['song'] ?? "",
      reelId: map['reelId'] ?? "",
      publishedAt: DateTime.parse(map['published_at']),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      likeCount: map['likeCount'] ?? 0,
      commentCount: map['commentCount'] ?? 0,
      video: VideoModel.fromMap(map['videoId'] as Map<String, dynamic>),
      reelComments: List<CommentModel>.from(
        (map['reel_comments']).map<CommentModel>(
          (x) => CommentModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      hashtags: List<String>.from(
        (map['hashtags']),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReelModel.fromJson(String source) =>
      ReelModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReelModel(id: $id, description: $description, mediaLink: $mediaLink, mediaType: $mediaType, mediaExt: $mediaExt, isDeleted: $isDeleted, profile: $profile, title: $title, type: $type, song: $song, reelId: $reelId, publishedAt: $publishedAt, createdAt: $createdAt, updatedAt: $updatedAt, likeCount: $likeCount, commentCount: $commentCount, video: $video, reelComments: $reelComments, hashtags: $hashtags, isLiked: $isLiked)';
  }

  @override
  bool operator ==(covariant ReelModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.description == description &&
        other.mediaLink == mediaLink &&
        other.mediaType == mediaType &&
        other.mediaExt == mediaExt &&
        other.isDeleted == isDeleted &&
        other.profile == profile &&
        other.title == title &&
        other.type == type &&
        other.song == song &&
        other.reelId == reelId &&
        other.publishedAt == publishedAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.likeCount == likeCount &&
        other.commentCount == commentCount &&
        other.video == video &&
        listEquals(other.reelComments, reelComments) &&
        listEquals(other.hashtags, hashtags) &&
        other.isLiked == isLiked;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        mediaLink.hashCode ^
        mediaType.hashCode ^
        mediaExt.hashCode ^
        isDeleted.hashCode ^
        profile.hashCode ^
        title.hashCode ^
        type.hashCode ^
        song.hashCode ^
        reelId.hashCode ^
        publishedAt.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        likeCount.hashCode ^
        commentCount.hashCode ^
        video.hashCode ^
        reelComments.hashCode ^
        hashtags.hashCode ^
        isLiked.hashCode;
  }
}
