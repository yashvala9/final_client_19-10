import 'dart:convert';

class NotificationModel {
  final String title;
  final String body;
  final DateTime createdAt;
  final Data data;
  NotificationModel({
    required this.title,
    required this.body,
    required this.createdAt,
    required this.data,
  });

  NotificationModel copyWith({
    String? title,
    String? body,
    DateTime? createdAt,
    Data? data,
  }) {
    return NotificationModel(
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': title});
    result.addAll({'body': body});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});
    result.addAll({'data': data.toMap()});

    return result;
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
      data: Data.fromMap(map['data']),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NotificationModel(title: $title, body: $body, createdAt: $createdAt, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationModel &&
        other.title == title &&
        other.body == body &&
        other.createdAt == createdAt &&
        other.data == data;
  }

  @override
  int get hashCode {
    return title.hashCode ^ body.hashCode ^ createdAt.hashCode ^ data.hashCode;
  }
}

class Data {
  final String notificationType;
  final String entityType;
  final String entityId;
  final int userId;
  Data({
    required this.notificationType,
    required this.entityType,
    required this.entityId,
    required this.userId,
  });

  Data copyWith({
    String? notificationType,
    String? entityType,
    String? entityId,
    int? userId,
  }) {
    return Data(
      notificationType: notificationType ?? this.notificationType,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'notificationType': notificationType});
    result.addAll({'entityType': entityType});
    result.addAll({'entityId': entityId});
    result.addAll({'userId': userId});

    return result;
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      notificationType: map['notification_type'] ?? '',
      entityType: map['entity_type'] ?? '',
      entityId: map['entity_id'] ?? '',
      userId: map['user_id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Data.fromJson(String source) => Data.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Data(notificationType: $notificationType, entityType: $entityType, entityId: $entityId, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Data &&
        other.notificationType == notificationType &&
        other.entityType == entityType &&
        other.entityId == entityId &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return notificationType.hashCode ^
        entityType.hashCode ^
        entityId.hashCode ^
        userId.hashCode;
  }
}
