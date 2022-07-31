import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:reel_ro/models/comment_model.dart';

import '../utils/base.dart';

class CommentRepository {
  Future<List<CommentModel>> getCommentByReelId(
      int reelId, String token) async {
    printInfo(info: "getCommentByreelId: $reelId");
    final response = await http.get(
      Uri.parse("${Base.getCommentByReelId}/$reelId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    printInfo(info: "getCommentsByReelIdBody: $body");
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Iterable list = body;
      return list.map((e) => CommentModel.fromMap(e)).toList();
    } else {
      return Future.error(body['detail']);
    }
  }

  Future<String> addCommentToReelId(
      String token, Map<String, dynamic> data, int reelId) async {
    final response = await http.post(
      Uri.parse("${Base.addCommentToReelId}/$reelId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: jsonEncode(data),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return "";
    } else {
      return Future.error(body['detail']);
    }
  }

  Future<int> getCommentCountByReelId(int reelId, String token) async {
    final response = await http.get(
      Uri.parse("${Base.getCommentCount}/$reelId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return body['comment_count'] as int;
    } else {
      print(body['meesage']);
      return Future.error(body['message']);
    }
  }

  Future<void> toggleCommentLike(
      int commentId, int userId, String token) async {
    final response = await http.post(
      Uri.parse(
          "${Base.toggleCommentLike}?commentId=$commentId&userId=$userId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      printInfo(info: body['message']);
      return;
    } else {
      return Future.error(body['message']);
    }
  }
}
