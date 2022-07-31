import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

import 'package:reel_ro/models/photo_model.dart';
import 'package:reel_ro/models/reel_model.dart';
import 'package:reel_ro/utils/base.dart';
import 'package:reel_ro/utils/snackbar.dart';

class ReelRepository {
  Future<List<ReelModel>> getFeeds(int profileId, String token) async {
    print('343434');
    final response = await http.get(
      Uri.parse(Base.reels),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    print(response.body.toString() + '343434');
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
    print('2121 ${jsonEncode(data)}');
    final response = await http.post(
      Uri.parse(Base.reels),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: jsonEncode(data),
    );
    print('2121 ${Base.reels}');
    print('2121 ${response.statusCode}');
    print('2121 ${response.body}');
    if (response.statusCode == 201) {
      return;
    } else {
      final body = jsonDecode(response.body);
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

  /// Uploads the video file to AWS VOD input bucket and saves the key to get url later
  Future<String?> uploadFileToAwsS3({
    required String userID,
    required File file,
    required String fileName,
  }) async {
    print('2121 s3 filename $fileName');
    try {
      final response = await AwsS3.uploadFile(
        accessKey: "AKIARYAXXOSN5XYB5M67",
        secretKey: "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",
        file: file,
        bucket: "reelro-mediaconvert-source",
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
}
