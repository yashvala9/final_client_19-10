import 'dart:convert';
import 'dart:io';

import 'package:get/get_utils/get_utils.dart';
import 'package:http/http.dart' as http;
import 'package:reel_ro/models/photo_model.dart';
import 'package:reel_ro/models/profile_model.dart';

import '../models/reel_model.dart';
import '../utils/base.dart';

class ProfileRepository {
  Future<ProfileModel?> getProfileId(String token) async {
    final response = await http.get(
      Uri.parse(Base.getProfileId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (body['profile'] != null) {
        int profileId = body['profile'];
        return await getProfileById(profileId, token);
      } else {
        return null;
      }
    } else {
      return Future.error(body['message']);
    }
  }

  Future<ProfileModel> getProfileById(int profileId, String token) async {
    final response = await http.get(
      Uri.parse("${Base.getProfilebyId}/$profileId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return ProfileModel.fromMap(body);
    } else {
      return Future.error(body['error']['message']);
    }
  }

  Future<List<ProfileModel>> getProfileByUserName(
      String userName, int profileId, String token) async {
    print('username:' + userName);
    final response = await http.get(
      Uri.parse(
          "${Base.searchUser}/?username=$userName&currentUserId=$profileId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    print(response.body);
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final Iterable list = body;
      return list.map((e) => ProfileModel.fromMap(e)).toList();
    } else {
      return Future.error(body['error']['message']);
    }
  }

  Future<void> addProfile(
      Map<String, dynamic> profileData, String token) async {
    final response = await http.post(
      Uri.parse(Base.createProfile),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: jsonEncode(profileData),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return;
    } else {
      return Future.error(body['error']['message']);
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
    List<ReelModel> reels = [];
    final response = await http.get(
      Uri.parse("${Base.getReelsByUserId}?currentUserId=$profileId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final Iterable list = body;

      for (var item in list as List<dynamic>) {
        reels.add(ReelModel.fromJson(item));
      }
      return reels;
    } else {
      return Future.error(body['message']);
    }
  }

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
      return Future.error(body['message']);
    }
  }

  Future<void> toggleFollow(
      int followingProfileId, int profileId, String token) async {
    printInfo(info: "FolloingProfileId: $followingProfileId");
    printInfo(info: "Profile Id $profileId");
    final response = await http.post(
      Uri.parse(
          "${Base.toggleFollow}?currentUserId=$profileId&followingUserId=$followingProfileId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      printInfo(info: "${body['message']}");
      return;
    } else {
      printInfo(info: "toggleFollowError: ${body['message']}");
      return Future.error(body['message']);
    }
  }
}
