import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:reel_ro/models/comment_model.dart';

import '../utils/base.dart';

class CommentRepository {
  Future<List<CommentModel>> getCommentByReelId(
      String reelId, int profileId, String token) async {
    printInfo(info: "getCommentByreelId: $reelId");
    final response = await http.get(
      Uri.parse(
          "${Base.getCommentByReelId}?reelId=$reelId&currentUserId=$profileId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    printInfo(info: "getCommentsByReelIdBody: $body");
    if (response.statusCode == 200) {
      final Iterable list = body['comments'];
      return list.map((e) => CommentModel.fromMap(e)).toList();
    } else {
      return Future.error(body['message']);
    }
  }

  Future<String> addCommentToReelId(
      String token, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(Base.addCommentToReelId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: jsonEncode(data),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return "";
    } else {
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
