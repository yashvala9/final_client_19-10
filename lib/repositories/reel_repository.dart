import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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

  Future<ReelModel> getSingleReel(
    String reelId,
    String token,
  ) async {
    final response = await http.get(
      Uri.parse('${Base.getSingleReel}/$reelId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ReelModel.fromMap(body);
    } else {
      return Future.error(body['detail']);
    }
  }

  Future<int> getReelViews(
    String reelId,
    String token,
  ) async {
    final response = await http.get(
      Uri.parse('${Base.reelHistory}$reelId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return body['data']['total_views'];
    } else {
      return Future.error(body['detail']);
    }
  }

  Future<ReelModel> getReelByCommentId(String commentId, String token) async {
    try {
      final response = await http.get(
        Uri.parse("${Base.getEntity}/comment/$commentId"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
      final body = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return await getSingleReel(body['reel_id'].toString(), token);
      } else {
        return Future.error(body['detail']);
      }
    } catch (e) {
      printInfo(info: "Error getReelByCommentId $e");

      return Future.error(e);
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

  Future<List<ReelModel>> getReelsWithoutAd(int profileId, String token,
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

  Future<PhotoModel> getPhotosById(
    String id,
    String token,
  ) async {
    log("PhotoId:: $id");
    final response = await http.get(
      Uri.parse('${Base.posts}$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    log("SinglePhotoBody:: $body");
    if (response.statusCode == 200) {
      log("Body:: $body");
      var photo = PhotoModel.fromMap(body);
      log("Photo:: $photo");
      return photo;
    } else {
      return Future.error(body['detail']);
    }
  }

  Future<List<PhotoModel>> getPhotosWithoutAds(int profileId, String token,
      {int limit = 15, int skip = 0}) async {
    final response = await http.get(
      Uri.parse('${Base.posts}?limit=$limit&skip=$skip'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final Iterable list = body;
      return list.map((e) => PhotoModel.fromMap(e)).toList();
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
      return Future.error(body['message']);
    }
  }

  Future<bool> getPhotosLikeFlag(int reelId, String token) async {
    final response = await http.get(
      Uri.parse("${Base.getPhotoLikeFlag}/$reelId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return body['is_liked'] as bool;
    } else {
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
      return Future.error(body['message']);
    }
  }

  Future<int> getLikeCountByPhotoId(int reelId, String token) async {
    final response = await http.get(
      Uri.parse("${Base.getPhotoLikeCount}/$reelId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return body['like_count'] as int;
    } else {
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
      return;
    } else {
      return Future.error(body['message']);
    }
  }

  Future<void> photoToggleLike(int reelId, String token) async {
    final response = await http.get(
      Uri.parse("${Base.photoToggleLike}/$reelId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      return Future.error(body['message']);
    }
  }

  Future<void> updateReelCaption(
      int reelId, String token, String caption) async {
    final response = await http.put(
      Uri.parse("${Base.reels}$reelId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: json.encode({"description": caption}),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      return Future.error(body['message']);
    }
  }

  Future<void> updatePhotoCaption(
      int postId, String token, String caption, String title) async {
    final response = await http.put(
      Uri.parse("${Base.posts}$postId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: json.encode({"title": title, "content": caption}),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
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

  Future<void> addPhoto(Map<String, dynamic> data, String token) async {
    final response = await http.post(
      Uri.parse(Base.posts),
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

  Future<void> reportReelOrComment(
      String type, String reason, int id, String token) async {
    final response = await http.post(
      Uri.parse("${Base.report}/$type/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: jsonEncode(
        {
          "reason": reason,
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
    if (response.statusCode == 200) {
      final Iterable list = body;
      return list.map((e) => ReelModel.fromMap(e)).toList();
    } else {
      return Future.error(body['error']['message']);
    }
  }

  Future<List<PhotoModel>> getPhotosByUserId(
      int profileId, String token) async {
    final response = await http.get(
      Uri.parse("${Base.getPhotosByUserId}?currentUserId=14"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final Iterable list = body;
      return list.map((e) => PhotoModel.fromMap(e)).toList();
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

  Future<void> deletePost(int id, String token) async {
    final response = await http.delete(
      Uri.parse("${Base.deletePost}/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
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
    List<String> a = [];
    final body = json.decode(response.body);

    if (response.statusCode == 201 || response.statusCode == 200) {
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
      int secondsWatched, int totalLength, int adId, String token) async {
    try {
      var map = {"time_duration": totalLength, "reel_length": totalLength};
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
    } catch (e) {
      printInfo(info: "updateAdsHistory.......");
    }
  }

  Future<void> updateReelHistory(
      int secondsWatched, int totalSeconds, int reelId, String token) async {
    try {
      var map = {"time_duration": secondsWatched, "reel_length": totalSeconds};
      final response = await http.post(
        Uri.parse('${Base.reelHistory}$reelId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
        body: jsonEncode(map),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return;
      } else {
        final body = jsonDecode(response.body);
        return Future.error(body['detail']);
      }
    } catch (e) {
      showSnackBar("Error updateReelHistory $e");
      printInfo(info: "updateReelHistory.......$e");
    }
  }

  Future<bool> isActive(int userId, String token) async {
    final response = await http.get(
      Uri.parse('${Base.isActive}$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return (body == 'active');
    } else {
      return false;
    }
  }
}
