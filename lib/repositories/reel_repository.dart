import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:reel_ro/models/photo_model.dart';
import 'package:reel_ro/models/reel_model.dart';
import 'package:reel_ro/utils/base.dart';

class ReelRepository {
  Future<List<ReelModel>> getFeeds(int profileId, String token) async {
    final response = await http.get(
      Uri.parse("${Base.getFeedsByUserId}?currentUserId=$profileId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final Iterable list = body;
      return reelFromJson(response.body);
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
      return reelFromJson(response.body);
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
    final response = await http.get(
      Uri.parse("${Base.getReelsByUserId}?currentUserId=14"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    print("running reels by id 323232");
    print(body);
    if (response.statusCode == 200) {
      return reelFromJson(response.body);
    } else {
      return Future.error(body['error']['message']);
    }
  }

  Future<List<PhotoModel>> getPhotosById(int profileId, String token) async {
    final response = await http.get(
      Uri.parse("${Base.getPhotosByUserId}?currentUserId=14"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    print("running reels by id 323232");
    print(body);
    if (response.statusCode == 200) {
      return photoFromJson(response.body);
    } else {
      return Future.error(body['error']['message']);
    }
  }

  Future<int> addPhotoOrVideo(File file, String token) async {
    printInfo(info: "File path: ${file.path}");
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(Base.uploadVideo),
    );
    var headers = <String, String>{
      'Content-Type': 'multipart/form-data; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Bearer $token",
    };
    request.headers.addAll(headers);
    request.files.add(
      await http.MultipartFile.fromPath('files', file.path),
    );

    var res = await request.send();
    var responsed = await http.Response.fromStream(res);
    var resData = json.decode(responsed.body);
    printInfo(info: resData.toString());
    if (res.statusCode == 200) {
      return resData[0]['id'];
    } else {
      return Future.error(resData['message']);
    }
  }
}
