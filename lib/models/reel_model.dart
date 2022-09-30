// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:reel_ro/models/profile_model.dart';

class ReelModel {
  final int id;
  final String video_title;
  final String description;
  final String filename;
  final String media_ext;
  final String thumbnail;
  final ProfileModel user;

  ReelModel({
    required this.id,
    required this.video_title,
    required this.description,
    required this.filename,
    required this.media_ext,
    required this.thumbnail,
    required this.user,
  });

  ReelModel copyWith({
    int? id,
    String? video_title,
    String? description,
    String? filename,
    String? media_ext,
    String? thumbnail,
    ProfileModel? user,
  }) {
    return ReelModel(
      id: id ?? this.id,
      video_title: video_title ?? this.video_title,
      description: description ?? this.description,
      filename: filename ?? this.filename,
      media_ext: media_ext ?? this.media_ext,
      thumbnail: thumbnail ?? this.thumbnail,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'video_title': video_title,
      'description': description,
      'filename': filename,
      'media_ext': media_ext,
      'thumbnail': thumbnail,
      'user': user.toMap(),
    };
  }

  factory ReelModel.fromMap(Map<String, dynamic> map) {
    return ReelModel(
      id: map['id'] as int,
      video_title: ((map['video_title'] ?? map['title']) ?? '') as String,
      description: ((map['description'] ?? map['content']) ?? '') as String,
      filename: map['filename'] as String,
      media_ext: (map['media_ext'] ?? '') as String,
      thumbnail: (map['thumbnail'] ?? '') as String,
      user: ProfileModel.fromMap(
          (map['user'] ?? map['owner']) as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReelModel.fromJson(String source) =>
      ReelModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReelModel(id: $id, video_title: $video_title, description: $description, filename: $filename, media_ext: $media_ext, thumbnail: $thumbnail, user: $user)';
  }

  @override
  bool operator ==(covariant ReelModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.video_title == video_title &&
        other.description == description &&
        other.filename == filename &&
        other.media_ext == media_ext &&
        other.thumbnail == thumbnail &&
        other.user == user;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        video_title.hashCode ^
        description.hashCode ^
        filename.hashCode ^
        media_ext.hashCode ^
        thumbnail.hashCode ^
        user.hashCode;
  }
}
