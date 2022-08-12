// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:reel_ro/models/profile_model.dart';

class AdsModel {
  final int id;
  final String video_title;
  final String description;
  final String filename;
  final String filepath;
  final String thumbnail;
  final ProfileModel user;
  AdsModel({
    this.id = 0,
    required this.video_title,
    this.description = '',
    this.filename = '',
    this.filepath = '',
    this.thumbnail = '',
    required this.user,
  });

  AdsModel copyWith({
    int? id,
    String? video_title,
    String? description,
    String? filename,
    String? filepath,
    String? thumbnail,
    ProfileModel? user,
  }) {
    return AdsModel(
      id: id ?? this.id,
      video_title: video_title ?? this.video_title,
      description: description ?? this.description,
      filename: filename ?? this.filename,
      filepath: filepath ?? this.filepath,
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
      'filepath': filepath,
      'thumbnail': thumbnail,
      'user': user.toMap(),
    };
  }

  factory AdsModel.fromMap(Map<String, dynamic> map) {
    return AdsModel(
      id: map['id'] as int,
      video_title: map['video_title'] as String,
      description: map['description'] as String,
      filename: map['filename'] as String,
      filepath: map['filepath'] as String,
      thumbnail: map['thumbnail'] as String,
      user: ProfileModel.fromMap(map['user'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory AdsModel.fromJson(String source) =>
      AdsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Adsmodel(id: $id, video_title: $video_title, description: $description, filename: $filename, filepath: $filepath, thumbnail: $thumbnail, user: $user)';
  }

  @override
  bool operator ==(covariant AdsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.video_title == video_title &&
        other.description == description &&
        other.filename == filename &&
        other.filepath == filepath &&
        other.thumbnail == thumbnail &&
        other.user == user;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        video_title.hashCode ^
        description.hashCode ^
        filename.hashCode ^
        filepath.hashCode ^
        thumbnail.hashCode ^
        user.hashCode;
  }
}
