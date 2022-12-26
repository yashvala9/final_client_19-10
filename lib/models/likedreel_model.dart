// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LikedreelModel {
  final String updated_at;
  final int userid;
  final int reel_id;
  final String created_at;
  final Reels reels;
  LikedreelModel({
    required this.updated_at,
    required this.userid,
    required this.reel_id,
    required this.created_at,
    required this.reels,
  });

  LikedreelModel copyWith({
    String? updated_at,
    int? userid,
    int? reel_id,
    String? created_at,
    Reels? reels,
  }) {
    return LikedreelModel(
      updated_at: updated_at ?? this.updated_at,
      userid: userid ?? this.userid,
      reel_id: reel_id ?? this.reel_id,
      created_at: created_at ?? this.created_at,
      reels: reels ?? this.reels,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'updated_at': updated_at,
      'userid': userid,
      'reel_id': reel_id,
      'created_at': created_at,
      'reels': reels.toMap(),
    };
  }

  factory LikedreelModel.fromMap(Map<String, dynamic> map) {
    return LikedreelModel(
      updated_at: map['updated_at'] ?? '',
      userid: map['userid'] as int,
      reel_id: map['reel_id'] as int,
      created_at: map['created_at'] ?? '',
      reels: Reels.fromMap(map['reels'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory LikedreelModel.fromJson(String source) =>
      LikedreelModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LikedreelModel(updated_at: $updated_at, userid: $userid, reel_id: $reel_id, created_at: $created_at, reels: $reels)';
  }

  @override
  bool operator ==(covariant LikedreelModel other) {
    if (identical(this, other)) return true;

    return other.updated_at == updated_at &&
        other.userid == userid &&
        other.reel_id == reel_id &&
        other.created_at == created_at &&
        other.reels == reels;
  }

  @override
  int get hashCode {
    return updated_at.hashCode ^
        userid.hashCode ^
        reel_id.hashCode ^
        created_at.hashCode ^
        reels.hashCode;
  }
}

class Reels {
  final String created_at;
  final int id;
  final String description;
  final String media_ext;
  final String status;
  final int userid;
  final String updated_at;
  final String video_title;
  final String filename;
  final int media_size;
  Reels({
    required this.created_at,
    required this.id,
    required this.description,
    required this.media_ext,
    required this.status,
    required this.userid,
    required this.updated_at,
    required this.video_title,
    required this.filename,
    required this.media_size,
  });

  Reels copyWith({
    String? created_at,
    int? id,
    String? description,
    String? media_ext,
    String? status,
    int? userid,
    String? updated_at,
    String? video_title,
    String? filename,
    int? media_size,
  }) {
    return Reels(
      created_at: created_at ?? this.created_at,
      id: id ?? this.id,
      description: description ?? this.description,
      media_ext: media_ext ?? this.media_ext,
      status: status ?? this.status,
      userid: userid ?? this.userid,
      updated_at: updated_at ?? this.updated_at,
      video_title: video_title ?? this.video_title,
      filename: filename ?? this.filename,
      media_size: media_size ?? this.media_size,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'created_at': created_at,
      'id': id,
      'description': description,
      'media_ext': media_ext,
      'status': status,
      'userid': userid,
      'updated_at': updated_at,
      'video_title': video_title,
      'filename': filename,
      'media_size': media_size,
    };
  }

  factory Reels.fromMap(Map<String, dynamic> map) {
    return Reels(
      created_at: map['created_at'] ?? '',
      id: map['id'] as int,
      description: map['description'] ?? '',
      media_ext: map['media_ext'] ?? '',
      status: map['status'] ?? '',
      userid: map['userid'] as int,
      updated_at: map['updated_at'] ?? '',
      video_title: map['video_title'] ?? '',
      filename: map['filename'] ?? '',
      media_size: map['media_size'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Reels.fromJson(String source) =>
      Reels.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Reels(created_at: $created_at, id: $id, description: $description, media_ext: $media_ext, status: $status, userid: $userid, updated_at: $updated_at, video_title: $video_title, filename: $filename, media_size: $media_size)';
  }

  @override
  bool operator ==(covariant Reels other) {
    if (identical(this, other)) return true;

    return other.created_at == created_at &&
        other.id == id &&
        other.description == description &&
        other.media_ext == media_ext &&
        other.status == status &&
        other.userid == userid &&
        other.updated_at == updated_at &&
        other.video_title == video_title &&
        other.filename == filename &&
        other.media_size == media_size;
  }

  @override
  int get hashCode {
    return created_at.hashCode ^
        id.hashCode ^
        description.hashCode ^
        media_ext.hashCode ^
        status.hashCode ^
        userid.hashCode ^
        updated_at.hashCode ^
        video_title.hashCode ^
        filename.hashCode ^
        media_size.hashCode;
  }
}

class Video_title {}
