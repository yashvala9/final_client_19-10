import 'dart:convert';

class VideoModel {
  int id;
  String name;
  String ext;
  String url;
  VideoModel({
    required this.id,
    required this.name,
    required this.ext,
    required this.url,
  });

  VideoModel copyWith({
    int? id,
    String? name,
    String? ext,
    String? url,
  }) {
    return VideoModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ext: ext ?? this.ext,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'ext': ext,
      'url': url,
    };
  }

  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? "",
      ext: map['ext'] ?? "",
      url: map['url'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoModel.fromJson(String source) =>
      VideoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VideoModel(id: $id, name: $name, ext: $ext, url: $url)';
  }

  @override
  bool operator ==(covariant VideoModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.ext == ext &&
        other.url == url;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ ext.hashCode ^ url.hashCode;
  }
}
