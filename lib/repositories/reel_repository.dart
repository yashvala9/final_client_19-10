import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:reel_ro/models/reel_model.dart';
import 'package:reel_ro/utils/base.dart';

class ReelRepository {
  Future<List<ReelModel>> getFeeds(int profileId, String token) async {
    final response = await http.get(
      Uri.parse("${Base.getFeedsByUserId}?currentUserId=2"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final Iterable list = body;
      return list.map((e) => ReelModel.fromMap(e)).toList();
    } else {
      return Future.error(body['message']);
    }
  }

  Future<bool> getLikeFlag(String reelId, int profileId, String token) async {
    final response = await http.get(
      Uri.parse("${Base.getLikeFlag}?reelId=$reelId&userId=2"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return body['liked'] as bool;
    } else {
      print(body['meesage']);
      return Future.error(body['message']);
    }
  }

  Future<void> toggleLike(String reelId, int profileId, String token) async {
    final response = await http.post(
      Uri.parse("${Base.toggleLike}?reelId=$reelId&userId=2"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // return body['liked'] as bool;
      return;
    } else {
      print(body['meesage']);
      return Future.error(body['message']);
    }
  }

  Future<List<ReelModel>> getCommentByReelId(
      String reelId, String token) async {
    final response = await http.get(
      Uri.parse("${Base.getCommentByReelId}?reelId==$reelId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final Iterable list = body;
      return list.map((e) => ReelModel.fromMap(e)).toList();
    } else {
      return Future.error(body['message']);
    }
  }

  Future<void> addReel(Map<String, dynamic> data, String token) async {
    final response = await http.post(
      Uri.parse(Base.addReel),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: jsonEncode(data),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return;
    } else {
      return Future.error(body['message']);
    }
  }

  Future<List<ReelModel>> getReelsById(int profileId, String token) async {
    List<ReelModel> reels = [];
    final response = await http.get(
      Uri.parse("${Base.getReelsByUserId}/currentUserId=13"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      reels.add(ReelModel.fromMap(body));
      return reels;
    } else {
      return Future.error(body['error']['message']);
    }
  }
}
