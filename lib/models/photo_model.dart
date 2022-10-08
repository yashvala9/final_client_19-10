import 'dart:convert';

import 'package:reel_ro/models/profile_model.dart';

class PhotoModel {
  final String title;
  final String content;
  final String filename;
  final bool published;
  final int id;
  final ProfileModel owner;
  PhotoModel({
    this.title = '',
    this.content = '',
    this.filename = '',
    this.published = false,
    this.id = 0,
    required this.owner,
  });

  PhotoModel copyWith({
    String? title,
    String? content,
    String? filename,
    bool? published,
    int? id,
    ProfileModel? owner,
  }) {
    return PhotoModel(
      title: title ?? this.title,
      content: content ?? this.content,
      filename: filename ?? this.filename,
      published: published ?? this.published,
      id: id ?? this.id,
      owner: owner ?? this.owner,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'content': content,
      'filename': filename,
      'published': published,
      'id': id,
      'owner': owner.toMap(),
    };
  }

  factory PhotoModel.fromMap(Map<String, dynamic> map) {
    return PhotoModel(
      title: map['title'] as String,
      content: map['content'] as String,
      filename: map['filename'] as String,
      published: map['published'] as bool,
      id: map['id'] as int,
      owner: ProfileModel.fromMap(map['owner'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory PhotoModel.fromJson(String source) =>
      PhotoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Photomodel(title: $title, content: $content, filename: $filename, published: $published, id: $id, owner: $owner)';
  }

  @override
  bool operator ==(covariant PhotoModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.content == content &&
        other.filename == filename &&
        other.published == published &&
        other.id == id &&
        other.owner == owner;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        content.hashCode ^
        filename.hashCode ^
        published.hashCode ^
        id.hashCode ^
        owner.hashCode;
  }
}
