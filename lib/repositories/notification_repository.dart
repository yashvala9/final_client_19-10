import 'dart:convert';
import 'dart:io';

import 'package:reel_ro/models/comment_model.dart';
import 'package:reel_ro/models/notification_model.dart';
import 'package:http/http.dart' as http;
import 'package:reel_ro/utils/snackbar.dart';

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

  Future<void> pokeSingleUser(String token, int userId) async {
    final response = await http.post(
      Uri.parse('${Base.pokeSingleUser}$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    print(response.body);
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      showSnackBar("Poke successful!");
    } else {
      return Future.error(body['detail']);
    }
  }

  Future<void> pokeAllInactiveUser(String token) async {
    final response = await http.post(
      Uri.parse(Base.pokeAllInactiveUser),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    print(response.body);
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      showSnackBar("Poke successful!");
    } else {
      return Future.error(body['detail']);
    }
  }
}
