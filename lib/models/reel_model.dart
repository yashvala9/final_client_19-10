import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:reel_ro/models/comment_model.dart';
import 'package:reel_ro/models/profile_model.dart';

class ReelModel {
  int id;
  String description;
  String mediaLink;
  String title;
  String song;
  String reelId;
  int likeCount;
  int commentCount;
  List<String> hashtags;
  List<CommentModel> reelComments;
  ProfileModel profile;
  bool isLiked;
  ReelModel({
    required this.id,
    required this.description,
    required this.mediaLink,
    required this.title,
    required this.song,
    required this.reelId,
    required this.likeCount,
    required this.commentCount,
    required this.hashtags,
    required this.reelComments,
    required this.profile,
    this.isLiked = false,
  });

  ReelModel copyWith({
    int? id,
    String? description,
    String? mediaLink,
    String? title,
    String? song,
    String? reelId,
    int? likeCount,
    int? commentCount,
    List<String>? hashtags,
    List<CommentModel>? reelComments,
    ProfileModel? profile,
    bool? isLiked,
  }) {
    return ReelModel(
      id: id ?? this.id,
      description: description ?? this.description,
      mediaLink: mediaLink ?? this.mediaLink,
      title: title ?? this.title,
      song: song ?? this.song,
      reelId: reelId ?? this.reelId,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      hashtags: hashtags ?? this.hashtags,
      reelComments: reelComments ?? this.reelComments,
      profile: profile ?? this.profile,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'mediaLink': mediaLink,
      'title': title,
      'song': song,
      'reelId': reelId,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'hashtags': hashtags,
      'reel_comments': reelComments.map((x) => x.toMap()).toList(),
      'profile': profile.toMap(),
      'isLiked': isLiked,
    };
  }

  factory ReelModel.fromMap(Map<String, dynamic> map) {
    return ReelModel(
      id: map['id']?.toInt() ?? 0,
      description: map['description'] ?? '',
      mediaLink: map['mediaLink'] ?? '',
      title: map['title'] ?? '',
      song: map['song'] ?? '',
      reelId: map['reelId'] ?? '',
      likeCount: map['likeCount']?.toInt() ?? 0,
      commentCount: map['commentCount']?.toInt() ?? 0,
      hashtags:[], /*  List<String>.from(map['hashtags']) */
      reelComments: List<CommentModel>.from(map['reel_comments']?.map((x) => CommentModel.fromMap(x))),
      profile: ProfileModel.fromMap(map['profile']),
      isLiked: map['isLiked'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReelModel.fromJson(String source) =>
      ReelModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReelModel(id: $id, description: $description, mediaLink: $mediaLink, title: $title, song: $song, reelId: $reelId, likeCount: $likeCount, commentCount: $commentCount, hashtags: $hashtags, reelComments: $reelComments, profile: $profile, isLiked: $isLiked)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ReelModel &&
      other.id == id &&
      other.description == description &&
      other.mediaLink == mediaLink &&
      other.title == title &&
      other.song == song &&
      other.reelId == reelId &&
      other.likeCount == likeCount &&
      other.commentCount == commentCount &&
      listEquals(other.hashtags, hashtags) &&
      listEquals(other.reelComments, reelComments) &&
      other.profile == profile &&
      other.isLiked == isLiked;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      description.hashCode ^
      mediaLink.hashCode ^
      title.hashCode ^
      song.hashCode ^
      reelId.hashCode ^
      likeCount.hashCode ^
      commentCount.hashCode ^
      hashtags.hashCode ^
      reelComments.hashCode ^
      profile.hashCode ^
      isLiked.hashCode;
  }
}
