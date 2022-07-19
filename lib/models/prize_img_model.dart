import 'dart:convert';

class PrizeImageModel {
  final int id;
  final String name;
  final String url;
  PrizeImageModel({
    this.id = 0,
    this.name = '',
    this.url = '',
  });

  PrizeImageModel copyWith({
    int? id,
    String? name,
    String? url,
  }) {
    return PrizeImageModel(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'url': url,
    };
  }

  factory PrizeImageModel.fromMap(Map<String, dynamic> map) {
    return PrizeImageModel(
      id: (map['id'].toInt() ?? 0) as int,
      name: (map['name'] ?? '') as String,
      url: (map['url'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PrizeImageModel.fromJson(String source) =>
      PrizeImageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PrizeImageModel(id: $id, name: $name, url: $url)';

  @override
  bool operator ==(covariant PrizeImageModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.url == url;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ url.hashCode;
}
