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
  final String filepath;
  final String url;
  final ProfileModel user;

  ReelModel({
    required this.id,
    required this.video_title,
    required this.description,
    required this.filename,
    required this.media_ext,
    required this.thumbnail,
    required this.filepath,
    this.url = '',
    required this.user,
  });

  ReelModel copyWith({
    int? id,
    String? video_title,
    String? description,
    String? filename,
    String? media_ext,
    String? thumbnail,
    String? filepath,
    String? url,
    ProfileModel? user,
  }) {
    return ReelModel(
      id: id ?? this.id,
      video_title: video_title ?? this.video_title,
      description: description ?? this.description,
      filename: filename ?? this.filename,
      media_ext: media_ext ?? this.media_ext,
      thumbnail: thumbnail ?? this.thumbnail,
      filepath: filepath ?? this.filepath,
      url: url ?? this.url,
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
      'filepath': filepath,
      'url': url,
      'user': user.toMap(),
    };
  }

  factory ReelModel.fromMap(Map<String, dynamic> map) {
    return ReelModel(
      id: map['id'] as int,
      video_title:
          map['video_title'] != null ? map['video_title'] as String : "",
      url: map['url'] != null ? map['url'] as String : "",
      description: map['description'] as String,
      filename: map['filename'] as String,
      media_ext: map['media_ext'] as String,
      thumbnail: map['thumbnail'] ?? '',
      filepath: map['filepath'] ?? '',
      user: ProfileModel.fromMap(map['user'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReelModel.fromJson(String source) =>
      ReelModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReelModel(id: $id, video_title: $video_title, description: $description, filename: $filename, media_ext: $media_ext, thumbnail: $thumbnail, filepath: $filepath, url: $url, user: $user)';
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
        other.filepath == filepath &&
        other.url == url &&
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
        filepath.hashCode ^
        url.hashCode ^
        user.hashCode;
  }
}
