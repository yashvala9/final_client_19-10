import 'dart:convert';
import 'dart:io';

import 'package:reel_ro/models/comment_model.dart';
import 'package:reel_ro/models/notification_model.dart';
import 'package:http/http.dart' as http;

import '../utils/base.dart';

class NotificationRepository {
  Future<List<NotificationModel>> getNotificationList(String token) async {
    final response = await http.post(
      Uri.parse(Base.notificaitonList),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    print(response.body);
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Iterable list = body;
      return list.map((e) => NotificationModel.fromMap(e)).toList();
    } else {
      return Future.error(body['detail']);
    }
  }

  Future<CommentModel> getCommentById(int id,String token) async {
    final response = await http.get(
      Uri.parse("${Base.getEntity}/comment/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    print(response.body);
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return CommentModel.fromMap(body);
    } else {
      return Future.error(body['detail']);
    }
  }
}
