import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:http/http.dart' as http;
import 'package:reel_ro/models/photo_model.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/services/auth_service.dart';

import '../models/reel_model.dart';
import '../utils/base.dart';
import '../utils/snackbar.dart';

class ProfileRepository {
  Future<ProfileModel> getCurrentUsesr(String token) async {
    final response = await http.get(
      Uri.parse(Base.currentUser),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ProfileModel.fromMap(body);
    } else {
      return Future.error("Something went wrong");
    }
  }

  Future<ProfileModel> getUserProfile(String token) async {
    final response = await http.get(
      Uri.parse(Base.getUserProfile),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ProfileModel.fromMap(body['user']);
    } else {
      return Future.error("Something went wrong");
    }
  }

  Future<ProfileModel?> getProfileByToken(String token) async {
    final response = await http.get(
      Uri.parse(Base.getProfileByToken),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    print('2121 body $body');
    if (response.statusCode == 200 && body['id'] != null) {
      return ProfileModel.fromMap(body);
    } else {
      return null;
    }
  }

  Future<ProfileModel> getProfileById(int profileId, String token) async {
    final response = await http.get(
      Uri.parse("${Base.getProfileById}/$profileId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ProfileModel.fromMap(body['user']);
    } else {
      return Future.error(body['detail']);
    }
  }

  Future<List<ProfileModel>> searchByUserName(
      String userName, String token) async {
    print('username:' + userName);
    final response = await http.get(
      Uri.parse("${Base.searchUser}/$userName"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    print(response.body);
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Iterable list = body;
      return list.map((e) => ProfileModel.fromMap(e)).toList();
    } else {
      return Future.error(body['detail']);
    }
  }

  Future<String?> uploadProfileToAwsS3({
    required String userID,
    required File file,
    required String fileName,
  }) async {
    print('2121 s3 filename $fileName');
    try {
      final response = await AwsS3.uploadFile(
        accessKey: "AKIARYAXXOSN6RLGJZRH",
        secretKey: "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",
        file: file,
        bucket: "reelro-image-bucket",
        region: "ap-south-1",
        filename: fileName,
        destDir: 'inputs',
      );
      log("UploadProfiletoS3: $response");
      return "https://reelro-image-bucket.s3.ap-south-1.amazonaws.com/inputs/$fileName";
    } catch (e) {
      showSnackBar("Error Uploading File");
      printInfo(info: "File Uploading error.......");
      return null;
    }
  }

  Future<void> createProfile(
      Map<String, dynamic> profileData, String token) async {
    final response = await http.post(
      Uri.parse(Base.createProfile),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: jsonEncode(profileData),
    );
    print(response.statusCode);
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      // AuthService().redirectUser();
      return;
    } else {
      return Future.error(body['detail']);
    }
  }

  Future<void> updateProfile(
      Map<String, dynamic> profileData, String token) async {
    final response = await http.put(
      Uri.parse(Base.updateProfile),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: jsonEncode(profileData),
    );
    print(response.statusCode);
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      return Future.error(body['detail']);
    }
  }

  // Future<ProfileModel?> getReelsByUserId(String userId, String token) async {
  //   final response = await http.get(
  //     Uri.parse("${Base.getReelsByUserId}?currentUserId=$userId"),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       HttpHeaders.authorizationHeader: "Bearer $token",
  //     },
  //   );
  //   final body = jsonDecode(response.body);
  //   if (response.statusCode == 200) {
  //     if (body['profile'] != null) {
  //       int profileId = body['profile'];
  //       return await getProfileById(profileId, token);
  //     } else {
  //       return null;
  //     }
  //   } else {
  //     return Future.error(body['message']);
  //   }
  // }

  Future<List<ReelModel>> getReelByProfileId(
      int profileId, String token) async {
    final response = await http.get(
      //TODO need to create this lazy loading and remove limit as 300
      Uri.parse("${Base.getReelsByUserId}/$profileId?limit=300&skip=0"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Iterable list = body;
      return list.map((e) => ReelModel.fromMap(e)).toList();
    } else {
      return Future.error(body['detail']);
    }
  }

  Future<bool> isFollowing(int profileId, String token) async {
    final response = await http.get(
      Uri.parse("${Base.isFollowing}/$profileId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return body['is_following'];
    } else {
      return Future.error(body['detail']);
    }
  }

  // Future<List<ReelModel>> getReelByProfileId(
  //     int profileId, String token) async {
  //   List<ReelModel> reels = [];
  //   final response = await http.get(
  //     Uri.parse("${Base.getReelsByUserId}?currentUserId=$profileId"),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       HttpHeaders.authorizationHeader: "Bearer $token",
  //     },
  //   );

  //   final body = jsonDecode(response.body);
  //   print('listRolls $body');
  //   if (response.statusCode == 200) {
  //     final Iterable list = body;

  //     return list.map((e) => ReelModel.fromMap(e)).toList();
  //   } else {
  //     return Future.error(body['message']);
  //   }
  // }

  Future<List<PhotoModel>> getPhotosByProfileId(
      int profileId, String token) async {
    List<PhotoModel> photos = [];
    final response = await http.get(
      Uri.parse("${Base.getPhotosByUserId}?currentUserId=$profileId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final Iterable list = body;

      for (var item in list as List<dynamic>) {
        photos.add(PhotoModel.fromJson(item));
      }
      return photos;
    } else {
      return Future.error(body['detail']);
    }
  }

  Future<void> toggleFollow(int followingProfileId, String token) async {
    printInfo(info: "FolloingProfileId: $followingProfileId");

    final response = await http.post(
      Uri.parse(Base.toggleFollow),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: jsonEncode({
        'user_id': followingProfileId,
      }),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      printInfo(info: "$body");
      return;
    } else {
      printInfo(info: "toggleFollowError: ${body['detail']}");
      return Future.error(body['detail']);
    }
  }
}
