import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:reel_ro/models/comment_model.dart';

import 'package:reel_ro/models/photo_model.dart';
import 'package:reel_ro/models/reel_model.dart';
import 'package:reel_ro/utils/base.dart';
import 'package:reel_ro/utils/snackbar.dart';

class ReelRepository {
  Future<List<ReelModel>> getFeeds(int profileId, String token,
      {int limit = 10, int skip = 0}) async {
    final response = await http.get(
      Uri.parse('${Base.reels}?limit=$limit&skip=$skip'),
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
      return Future.error(body['detail']);
    }
  }

  Future<List<ReelModel>> getFeedsWithAds(int profileId, String token,
      {int limit = 10, int skip = 0}) async {
    final response = await http.get(
      Uri.parse('${Base.reelsWithAds}?limit=$limit&skip=$skip'),
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
      return Future.error(body['detail']);
    }
  }

  Future<List<ReelModel>> getReelsByHashTag(
      String hashTag, int profileId, String token,
      {int limit = 10, int skip = 0}) async {
    hashTag = hashTag.replaceAll(RegExp('[#]'), '');
    final response = await http.get(
      Uri.parse('${Base.reelsByHashTag}%23$hashTag?limit=$limit&skip=$skip'),
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
      return Future.error(body['detail']);
    }
  }

  Future<bool> getLikeFlag(int reelId, String token) async {
    final response = await http.get(
      Uri.parse("${Base.getLikeFlag}/$reelId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return body['is_liked'] as bool;
    } else {
      print(body['meesage']);
      return Future.error(body['message']);
    }
  }

  Future<int> getLikeCountByReelId(int reelId, String token) async {
    final response = await http.get(
      Uri.parse("${Base.getLikeCount}/$reelId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return body['like_count'] as int;
    } else {
      print(body['meesage']);
      return Future.error(body['message']);
    }
  }

  Future<int> getCommentLikeCountByCommentId(
      int commentId, String token) async {
    final response = await http.get(
      Uri.parse("${Base.getCommentLikeCount}/$commentId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return body['like_count'] as int;
    } else {
      print(body['meesage']);
      return Future.error(body['message']);
    }
  }

  Future<void> toggleLike(int reelId, String token) async {
    final response = await http.get(
      Uri.parse("${Base.toggleLike}/$reelId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      // return body['liked'] as bool;
      return;
    } else {
      print(body['meesage']);
      return Future.error(body['message']);
    }
  }

  Future<List<CommentModel>> getCommentByReelId(
      int reelId, String token) async {
    final response = await http.get(
      Uri.parse("${Base.getCommentByReelId}$reelId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 201) {
      final Iterable list = body;
      return list.map((e) => CommentModel.fromMap(e)).toList();
    } else {
      return Future.error(body['message']);
    }
  }

  Future<bool> isReelLikedByCurrentUser(int reelId, String token) async {
    final response = await http.get(
      Uri.parse("$reelId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    final body = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return false;
    } else {
      return Future.error(body['message']);
    }
  }

  Future<void> addReel(Map<String, dynamic> data, String token) async {
    final response = await http.post(
      Uri.parse(Base.reels),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 201) {
      return;
    } else {
      final body = jsonDecode(response.body);
      return Future.error(body['detail']);
    }
  }

  Future<void> reportReelOrComment(String type, int id, String token) async {
    final response = await http.post(
      Uri.parse("${Base.report}/$type/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: jsonEncode(
        {
          "reason": "Report",
          "info": {},
        },
      ),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      final body = jsonDecode(response.body);
      return Future.error(body['detail']);
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
    print(body);
    if (response.statusCode == 200) {
      final Iterable list = body;
      return list.map((e) => ReelModel.fromMap(e)).toList();
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
    print(body);
    if (response.statusCode == 200) {
      return photoFromJson(response.body);
    } else {
      return Future.error(body['error']['message']);
    }
  }

  Future<int> addPhotoOrVideo(File file, String token) async {
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
    if (res.statusCode == 200) {
      return resData[0]['id'];
    } else {
      return Future.error(resData['message']);
    }
  }

  /// Uploads the video file to AWS VOD input bucket and saves the key to get url later
  Future<String?> uploadFileToAwsS3({
    required String userID,
    required File file,
    required String fileName,
  }) async {
    try {
      final response = await AwsS3.uploadFile(
        accessKey: "AKIARYAXXOSN5XYB5M67",
        secretKey: "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",
        file: file,
        bucket: "reelro-vod-sourcebucket",
        region: "ap-south-1",
        filename: fileName,
        destDir: 'inputs',
      );
      log("UploadVideoToS3Bucket: $response");
      return "https://reelro-image-bucket.s3.ap-south-1.amazonaws.com/inputs/$fileName";
    } catch (e) {
      showSnackBar("Error Uploading File");
      printInfo(info: "File Uploading error.......");

      return null;
    }
  }

  Future<void> updateStatus(
      String fileName, String status, String token) async {
    final response = await http.put(
      Uri.parse('${Base.updateStatus}$fileName/$status'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return;
    } else {
      return Future.error(body['error']['message']);
    }
  }

  Future<void> deleteReel(int reelId, String token) async {
    final response = await http.delete(
      Uri.parse("${Base.deleteReel}/$reelId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      return Future.error(body['detail']);
    }
  }

  Future<List<String>> setRandomWinner(String contestId, String token) async {
    final response = await http.post(
      Uri.parse('${Base.setRandomWinner}/$contestId/setRandom'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    print('2121 ${response.statusCode}');
    print('2121 ${response.body}');
    List<String> a = [];
    final body = json.decode(response.body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('2121 ${response.body}');
      a.add(body['user_id'].toString());
      a.add(body['user']['user_profile']['fullname']);
      return a;
    } else if (response.statusCode == 400) {
      a.add(body['detail']);
      a.add(body['detail']);
      return a;
    } else {
      final body = jsonDecode(response.body);
      showSnackBar(body['detail'], color: Colors.red);
      return Future.error(body['detail']);
    }
  }

  Future<void> updateAdsHistory(
      int secondsWatched, int adId, String token) async {
    // http://13.234.159.127/ads/history/1

    var map = {"time_duration": secondsWatched};
    final response = await http.post(
      Uri.parse('${Base.adsHistory}$adId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: jsonEncode(map),
    );
    if (response.statusCode == 201) {
      return;
    } else {
      final body = jsonDecode(response.body);
      return Future.error(body['detail']);
    }
  }

  Future<void> updateReelHistory(
      int secondsWatched, int reelId, String token) async {
    // /reels/history/51

    var map = {"time_duration": secondsWatched};
    final response = await http.post(
      Uri.parse('${Base.reelHistory}$reelId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: jsonEncode(map),
    );
    if (response.statusCode == 201) {
      return;
    } else {
      final body = jsonDecode(response.body);
      return Future.error(body['detail']);
    }
  }
}
